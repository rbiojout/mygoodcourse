##
# generated with rails g task carrierwave reprocess_attachments
# use rake carrierwave:reprocess_attachments
##
namespace :carrierwave do
  task reprocess_attachments: :environment do |_task|
    desc 'Reprocess all attachments'
    Attachment.find_each do |attachment|
      puts "done attachment #{attachment.id}"
      begin
        attachment.reprocess_versions
      rescue => e
        puts "error #{e.message}"
        false
      end
    end
  end
end
