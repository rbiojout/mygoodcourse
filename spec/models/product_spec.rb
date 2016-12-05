require 'rails_helper'

RSpec.describe Product, type: :model do


  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_presence_of(:customer) }
  it { is_expected.to validate_presence_of(:levels) }
  it { is_expected.to validate_presence_of(:categories) }
  it { is_expected.to validate_presence_of(:attachments) }

  it "has a valid factory" do
    @product = create(:product)
    expect(@product).to be_valid
  end

  it "has a correct attachment" do
    @product = create(:product)
    @attachment = @product.attachments.first
    expect(@attachment.file_size).to eq(326314)
    expect(@attachment.file_type).to eq('application/pdf')
    expect(@attachment.version_number).to eq(1)
  end

  it "is a confirmed owned product" do
    @product = create(:product)
    expect(@product.customer).not_to be_nil
  end

end
