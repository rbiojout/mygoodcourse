##
# use rake aws:copy_bucket_locally RAILS_ENV=development
# use rake aws:clean_attachments RAILS_ENV=development
##
namespace :aws do
  desc "Operations linked to aws."
  task :copy_bucket_locally  => :environment  do
    # create a connection
    # WARNING
    # THE REGION MUST BE ADAPTED TO THE BUCKET IN ORDER TO ACCESS
    #
    connection = Fog::Storage.new({
        :provider                 => 'AWS',
        :aws_access_key_id        => ENV["AWS_ACCESS_KEY_ID"],
        :aws_secret_access_key    => ENV["AWS_SECRET_ACCESS_KEY"],
        :region               => 'eu-west-1'
    })

    # list directories
    p connection.directories

    # get production
    directory = connection.directories.get('formycourse')
    #directory = connection.directories.find { |d| d.key == 'formycourse' }

    directory.files.map do |file|

      "(("+File.dirname(file.key)+"))"+File.basename(file.key)
    end


    # set-up the root folder
    upload_folder = Rails.root.join('public').to_s+'/'

    # iterate over the files in S3
    # directory.files.map is limited to 1000 files
    # need for directory.files.each
    directory.files.each do |s3_file|
      # write only if File doesn't exist
      unless File.file?(upload_folder+s3_file.key)
        # create the folders
        FileUtils.mkdir_p(upload_folder+File.dirname(s3_file.key))
        # store the file locally
          File.open(upload_folder+s3_file.key, 'w:ASCII-8BIT') do |local_file|
            local_file.write(s3_file.body)
          end

      end

    end


  end

  task :clean_attachments   => :environment do
    desc "This is going to destroy the attachments that are no longer used. MUST BE AGAINST THE RIGHT DATABASE"
    connection = Fog::Storage.new({
                                      :provider                 => 'AWS',
                                      :aws_access_key_id        => ENV["AWS_ACCESS_KEY_ID"],
                                      :aws_secret_access_key    => ENV["AWS_SECRET_ACCESS_KEY"],
                                      :region               => 'eu-west-1'
                                  })
    # list directories
    p connection.directories

    # get production
    directory = connection.directories.get('formycourse')
    #directory = connection.directories.find { |d| d.key == 'formycourse' }


    counter = 0
    result=""
    # iterate over the files in S3
    directory.files.each do |s3_file|
      # retrieve date
      if s3_file.last_modified < Time.now - 6.hours
        if(File.dirname(s3_file.key).include?"uploads/attachment/file")
          counter += 1
          result=result+s3_file.key.to_s+"|"
          s3_file.destroy
        end
      end
    end

    puts "#{counter} files deleted"
    puts "#{result}"

  end

end