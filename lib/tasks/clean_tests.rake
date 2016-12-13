##
# generated with rails g task carrierwave reprocess_attachments
# use rake clean_tests:clean_files
##
namespace :clean_tests do

  task :clean_files => :environment do |task|
    desc "Re-init the files from the files fixtures in the test"
    FileUtils.rm_rf(Dir["#{Rails.root}/public/uploads/test/*"])
    FileUtils.cp_r(Dir["#{Rails.root}/spec/fixtures/files/uploads/*"], Dir["#{Rails.root}/public/uploads/test"])
  end


end
