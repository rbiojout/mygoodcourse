require 'rails_helper'

RSpec.describe Product, type: :model do


  context "validation" do
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
      expect(@attachment.file_size).to eq(516653)
      expect(@attachment.file_type).to eq('application/pdf')
      expect(@attachment.version_number).to eq(1)
    end

    it "is a confirmed owned product" do
      @product = create(:product)
      expect(@product.customer).not_to be_nil
    end
  end



  context "scope" do
    it "count filtered by cycles" do
      expect(Product.count_active_filtered_for_cycle(cycles(:C1), nil, nil)).to eq(2)
      found_for_family = Product.for_family(families(:F1))
      expect(found_for_family.count).to eq(2)
      expect(found_for_family).to  include(products(:ProdF1C1_C1L1))
      expect(found_for_family).to include(products(:ProdF1C2_C1L2))

      found_for_cycle = Product.for_cycle(cycles(:C1))
      expect(found_for_cycle.count).to eq(2)
      expect(found_for_cycle).to include(products(:ProdF1C1_C1L1))
      expect(found_for_cycle).to include(products(:ProdF1C2_C1L2))

      expect(Product.count_active_filtered_for_cycle(cycles(:C1), families(:F1), nil)).to eq(2)
      expect(Product.count_active_filtered_for_cycle(cycles(:C1), families(:F1), categories(:F1C1))).to eq(1)
      expect(Product.count_active_filtered_for_cycle(cycles(:C1), families(:F2), nil)).to eq(0)
      expect(Product.count_active_filtered_for_cycle(cycles(:C1), families(:F1), categories(:F2C1))).to eq(0)
      expect(Product.count_active_filtered_for_cycle(cycles(:C1), nil, categories(:F2C1))).to eq(0)
    end

    it "count filtered by levels" do
      expect(Product.count_active_filtered_for_level(levels(:C1L1), nil, nil)).to eq(1)
      found_for_level = Product.for_level(levels(:C1L1))
      expect(found_for_level.count).to eq(1)
      expect(found_for_level).to include(products(:ProdF1C1_C1L1))
      expect(found_for_level).not_to include(products(:ProdF1C2_C1L2))

      found_for_cycle = Product.for_cycle(cycles(:C1))
      expect(found_for_cycle.count).to eq(2)
      expect(found_for_cycle).to include(products(:ProdF1C1_C1L1))
      expect(found_for_cycle).to include(products(:ProdF1C2_C1L2))

      expect(Product.count_active_filtered_for_level(levels(:C1L1), families(:F1), nil)).to eq(1)
      expect(Product.count_active_filtered_for_level(levels(:C1L1), families(:F1), categories(:F1C1))).to eq(1)
      expect(Product.count_active_filtered_for_level(levels(:C1L1), families(:F2), nil)).to eq(0)
      expect(Product.count_active_filtered_for_level(levels(:C1L1), families(:F1), categories(:F2C1))).to eq(0)
      expect(Product.count_active_filtered_for_level(levels(:C1L1), nil, categories(:F2C1))).to eq(0)
    end

    it "count filtered by families" do
      expect(Product.count_active_filtered_for_family(families(:F1), nil, nil)).to eq(2)
      found_for_family = Product.for_family(families(:F1))
      expect(found_for_family.count).to eq(2)
      expect(found_for_family).to include(products(:ProdF1C1_C1L1))
      expect(found_for_family).to include(products(:ProdF1C2_C1L2))

      found_for_cycle = Product.for_cycle(cycles(:C1))
      expect(found_for_cycle.count).to eq(2)
      expect(found_for_cycle).to include(products(:ProdF1C1_C1L1))
      expect(found_for_cycle).to include(products(:ProdF1C2_C1L2))

      expect(Product.count_active_filtered_for_family(families(:F1), cycles(:C1), nil)).to eq(2)
      expect(Product.count_active_filtered_for_family(families(:F1), cycles(:C1), levels(:C1L1))).to eq(1)
      expect(Product.count_active_filtered_for_family(families(:F1), cycles(:C2), nil)).to eq(0)
      expect(Product.count_active_filtered_for_family(families(:F1), cycles(:C1), levels(:C2L1))).to eq(0)
      expect(Product.count_active_filtered_for_family(families(:F1), nil, levels(:C2L1))).to eq(0)
    end

    it "count filtered by categories" do
      expect(Product.count_active_filtered_for_category(categories(:F1C1), nil, nil)).to eq(1)
      found_for_category = Product.for_category(categories(:F1C1))
      expect(found_for_category.count).to eq(1)
      expect(found_for_category).to include(products(:ProdF1C1_C1L1))
      expect(found_for_category).not_to include(products(:ProdF1C2_C1L2))

      expect(Product.count_active_filtered_for_category(categories(:F1C1), cycles(:C1), nil)).to eq(1)
      expect(Product.count_active_filtered_for_category(categories(:F1C1), cycles(:C1), levels(:C1L1))).to eq(1)
      expect(Product.count_active_filtered_for_category(categories(:F1C1), cycles(:C2), nil)).to eq(0)
      expect(Product.count_active_filtered_for_category(categories(:F1C1), cycles(:C1), levels(:C2L1))).to eq(0)
      expect(Product.count_active_filtered_for_category(categories(:F1C1), nil, levels(:C2L1))).to eq(0)
    end
  end

end
