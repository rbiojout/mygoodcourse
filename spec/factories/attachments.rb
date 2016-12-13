FactoryGirl.define do
  factory :attachment, class: Attachment do
    file File.open(File.join(Rails.root, '/public/uploads/test/attachment/file/default_document.pdf'))
    product
  end
end