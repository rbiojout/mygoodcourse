##
# generated with rail g carrierwave reprocess_attachments
##
namespace :carrierwave do

  task :reprocess_attachments => :environment do |task|
    desc "Reprocess all attachments"
    Attachment.find_each do |attachment|
      begin
      attachment.file.recreate_versions!
      attachment.save!
      rescue
        false
      end
    end

  end


end