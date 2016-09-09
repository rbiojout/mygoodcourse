##
# use rake aws:copy_bucket_locally RAILS_ENV=development
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

  task :clean do
    connection = Fog::Storage.new({
                                      :provider                 => 'AWS',
                                      :aws_access_key_id        => "AKIAJSWJDKWLZCEIEDOA",
                                      :aws_secret_access_key    => "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",
                                      :region               => 'eu-west-1'
                                  })
    # list directories
    p connection.directories

    # get production
    directory = connection.directories.get('formycourse')
    #directory = connection.directories.find { |d| d.key == 'formycourse' }

    counter = 1
    directory.files.each do |file|
      counter +=1
    end
    counter

    directory.files.map do |file|

      "(("+File.dirname(file.key)+"))"+File.basename(file.key)
    end

    # iterate over the files in S3
    counter = 1
    # directory.files.map is limited to 1000 files
    # need for directory.files.each
    directory.files.each do |s3_file|
      s3_file.key
      # retrieve file
      attachment = Attachment.find_by_file(File.basename(s3_file.key)) if ((File.dirname(s3_file.key).include?"uploads/attachment/file/") && !(s3_file.key.include?"png"))
      unless attachment.nil?
        counter+=1
        attachment.id.to_s+"---"+attachment.file.to_s
      else
        "ALERT"
      end
    end
    counter


    # iterate over the files in S3
    directory.files.each do |s3_file|
      # retrieve date
      unless s3_file.last_modified > Time.now - 6.hours
        # test path if we really have attachment
        if(File.dirname(s3_file.key).include?"uploads/attachment/file/19/cb5a7952-7dfd-498b-961f-140c4d38c321.png")
          s3_file.key
        end

      end
    end

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


  end

end