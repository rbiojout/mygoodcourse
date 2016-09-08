##
# generated with rails g task carrierwave reprocess_attachments
# use rake carrierwave:reprocess_attachments
##
namespace :carrierwave do

  task :reprocess_attachments => :environment do |task|
    desc "Reprocess all attachments"
    Attachment.find_each(batch_size: 10) do |attachment|
      begin
      attachment.file.recreate_versions!
      attachment.save!
        puts "done attachment "+attachment.id.to_s
      rescue
        false
      end
    end

  end


end
