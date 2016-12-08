require 'rails_helper'

RSpec.describe Level, type: :model do
  fixtures :levels, :categories, :families

  context "validation" do
    it { is_expected.to belong_to(:cycle)}
    it { is_expected.to have_and_belong_to_many(:products)}
    it { is_expected.to validate_presence_of(:name) }
  end

  context "scope" do

    it "filter by nil" do
      levels = Level.associated_to_families_categories(nil, nil, false)
      expect(levels.count).to eq(Level.all.count)
    end

    it "filter active by nil" do
      levels = Level.associated_to_families_categories(nil, nil, true)
      expect(levels.count).to eq(Level.with_active_products.count)
    end

    it "filter by category" do
      levels = Level.associated_to_families_categories(nil, categories(:one),false)
      expect(levels.count).not_to eq(0)
    end

    it "filter by categories" do
      levels = Level.associated_to_families_categories(nil, Category.all, false)
      expect(levels.count).not_to eq(0)
    end

    it "filter active by categories" do
      levels = Level.associated_to_families_categories(nil, Category.all, true)
      expect(levels.count).not_to eq(0)
    end

    it "filter by family" do
      levels = Level.associated_to_families_categories(families(:one), nil, false)
      expect(levels.count).not_to eq(0)
    end


    it "filter by families" do
      levels = Level.associated_to_families_categories(Family.all, nil, false)
      expect(levels.count).not_to eq(0)
    end

    it "filter active by families" do
      levels = Level.associated_to_families_categories(Family.all, nil, true)
      expect(levels.count).not_to eq(0)
    end

    it "filter by family and category" do
      levels = Level.associated_to_families_categories(families(:one), categories(:one), false)
      expect(levels.count).not_to eq(0)
    end

    it "filter active by family and category" do
      levels = Level.associated_to_families_categories(families(:one), categories(:one), true)
      expect(levels.count).not_to eq(0)
    end

  end


end
