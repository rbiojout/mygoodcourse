require 'rails_helper'

RSpec.describe Family, type: :model do
  context 'validation' do
    it { is_expected.to belong_to(:country) }
    it { is_expected.to have_many(:categories) }
    it { is_expected.to have_many(:products) }
    it { is_expected.to validate_presence_of(:name) }
  end

  context 'scope' do
    it 'filter by nil' do
      families = Family.associated_to_cycles_levels(nil, nil, false)
      expect(families.count).to eq(Family.all.count)
    end

    it 'filter active by nil' do
      families = Family.associated_to_cycles_levels(nil, nil, true)
      expect(families.count).to eq(Family.with_active_products.count)
    end

    it 'filter by level' do
      families = Family.associated_to_cycles_levels(nil, levels(:C1L1), false)
      expect(families.count).not_to eq(0)
      expect(products(:ProdF1C1_C1L1).levels).to include(levels(:C1L1))
      expect(products(:ProdF1C1_C1L1).families).to include(families(:F1))
      expect(families).to include(families(:F1))
      expect(Product.find_by_level(levels(:C1L1).id)).to include(products(:ProdF1C1_C1L1))
    end

    it 'filter by levels' do
      families = Family.associated_to_cycles_levels(nil, Level.all, false)
      expect(families.count).not_to eq(0)
    end

    it 'filter active by levels' do
      families = Family.associated_to_cycles_levels(nil, Level.all, true)
      expect(families.count).not_to eq(0)
    end

    it 'filter by cycle' do
      families = Family.associated_to_cycles_levels(cycles(:one), nil, false)
      expect(families.count).not_to eq(0)
    end

    it 'filter by cycles' do
      families = Family.associated_to_cycles_levels(Cycle.all, nil, false)
      expect(families.count).not_to eq(0)
      expect(products(:ProdF1C1_C1L1).cycles).to include(cycles(:C1))
      expect(products(:ProdF1C1_C1L1).families).to include(families(:F1))
      expect(families).to include(families(:F1))
      expect(Product.find_by_category(categories(:F1C1).id)).to include(products(:ProdF1C1_C1L1))
    end

    it 'filter active by cycles' do
      families = Family.associated_to_cycles_levels(Cycle.all, nil, true)
      expect(families.count).not_to eq(0)
    end

    it 'filter by cycle and level' do
      families = Family.associated_to_cycles_levels(cycles(:one), levels(:one), false)
      expect(families.count).not_to eq(0)
    end

    it 'filter active by cycle and level' do
      families = Family.associated_to_cycles_levels(cycles(:one), levels(:one), true)
      expect(families.count).not_to eq(0)
    end
  end
end
