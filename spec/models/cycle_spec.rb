require 'rails_helper'

RSpec.describe Cycle, type: :model do
  fixtures :cycles, :levels, :cycles

  context "validation" do
    it { is_expected.to belong_to(:country)}
    it { is_expected.to have_many(:levels)}
    it { is_expected.to have_many(:products)}
    it { is_expected.to validate_presence_of(:name) }
  end

  context "scope" do
    it "filter by nil" do
      cycles = Cycle.associated_to_families_categories(nil, nil, false)
      expect(cycles.count).to eq(Cycle.all.count)
    end

    it "filter active by nil" do
      cycles = Cycle.associated_to_families_categories(nil, nil, true)
      expect(cycles.count).to eq(Cycle.with_active_products.count)
    end

    it "filter by category" do
      cycles = Cycle.associated_to_families_categories(nil, categories(:one), false)
      expect(cycles.count).not_to eq(0)
    end

    it "filter by categories" do
      cycles = Cycle.associated_to_families_categories(nil, Category.all, false)
      expect(cycles.count).not_to eq(0)
    end

    it "filter active by categories" do
      cycles = Cycle.associated_to_families_categories(nil, Category.all, true)
      expect(cycles.count).not_to eq(0)
    end

    it "filter by family" do
      cycles = Cycle.associated_to_families_categories(families(:one), nil, false)
      expect(cycles.count).not_to eq(0)
    end


    it "filter by families" do
      cycles = Cycle.associated_to_families_categories(Family.all, nil, false)
      expect(cycles.count).not_to eq(0)
    end

    it "filter active by families" do
      cycles = Cycle.associated_to_families_categories(Family.all, nil, true)
      expect(cycles.count).not_to eq(0)
    end

    it "filter by family and category" do
      cycles = Cycle.associated_to_families_categories(families(:one), categories(:one), false)
      expect(cycles.count).not_to eq(0)
    end

    it "filter active by family and category" do
      cycles = Cycle.associated_to_families_categories(families(:one), categories(:one), true)
      expect(cycles.count).not_to eq(0)
    end

  end

end
