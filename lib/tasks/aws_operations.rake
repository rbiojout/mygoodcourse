##
# use rake db:import_from_heroku RAILS_ENV=development
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
    directory.files.map do |s3_file|
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
end