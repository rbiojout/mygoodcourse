FactoryGirl.define do
  factory :attachment, class: Attachment do
    file File.open(File.join(Rails.root, '/spec/fixtures/files/default_document.pdf'))
    product
  end
end