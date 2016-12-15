require 'rails_helper'

RSpec.describe Category, type: :model do
  fixtures :categories, :levels, :cycles

  context 'validation' do
    it { is_expected.to belong_to(:family) }
    it { is_expected.to have_and_belong_to_many(:products) }
    it { is_expected.to validate_presence_of(:name) }
  end

  context 'scope' do
    it 'filter by nil' do
      categories = Category.associated_to_cycles_levels(nil, nil, false)
      expect(categories.count).to eq(Category.all.count)
    end

    it 'filter active by nil' do
      categories = Category.associated_to_cycles_levels(nil, nil, true)
      expect(categories.count).to eq(Category.with_active_products.count)
    end

    it 'filter by level' do
      categories = Category.associated_to_cycles_levels(nil, levels(:C1L1), false)
      expect(categories.count).not_to eq(0)
      expect(products(:ProdF1C1_C1L1).levels).to include(levels(:C1L1))
      expect(products(:ProdF1C1_C1L1).categories).to include(categories(:F1C1))
      expect(categories).to include(categories(:F1C1))
      expect(Product.find_by_level(levels(:C1L1).id)).to include(products(:ProdF1C1_C1L1))
    end

    it 'filter by levels' do
      categories = Category.associated_to_cycles_levels(nil, Level.all, false)
      expect(categories.count).not_to eq(0)
    end

    it 'filter active by levels' do
      categories = Category.associated_to_cycles_levels(nil, Level.all, true)
      expect(categories.count).not_to eq(0)
    end

    it 'filter by cycle' do
      categories = Category.associated_to_cycles_levels(cycles(:C1), nil, false)
      expect(categories.count).not_to eq(0)
      expect(products(:ProdF1C1_C1L1).cycles).to include(cycles(:C1))
      expect(products(:ProdF1C1_C1L1).categories).to include(categories(:F1C1))
      expect(categories).to include(categories(:F1C1))
      expect(Product.find_by_category(categories(:F1C1).id)).to include(products(:ProdF1C1_C1L1))
    end

    it 'filter by cycles' do
      categories = Category.associated_to_cycles_levels(Cycle.all, nil, false)
      expect(categories.count).not_to eq(0)
    end

    it 'filter active by cycles' do
      categories = Category.associated_to_cycles_levels(Cycle.all, nil, true)
      expect(categories.count).not_to eq(0)
    end

    it 'filter by cycle and level' do
      categories = Category.associated_to_cycles_levels(cycles(:one), levels(:one), false)
      expect(categories.count).not_to eq(0)
    end

    it 'filter active by cycle and level' do
      categories = Category.associated_to_cycles_levels(cycles(:one), levels(:one), true)
      expect(categories.count).not_to eq(0)
    end
  end

  it 'is associated with query' do
    # @category_with_active_products = create(:category, :with_active_products, number_of_products: 4)
    category_with_active_products = create(:category, :with_products, number_of_products: 4)

    puts category_with_active_products
    puts category_with_active_products.products

    category_with_active_products.products.each do |prod|
      puts prod.id
      puts prod.active
      puts prod.categories.first.name
      puts prod.name
    end

    @country = create(:country, :with_cycles_and_levels, :with_families_and_categories, :with_topics_and_articles)
    puts @country.name
    puts @country.levels.count
    puts @country.categories.count
    puts @country.articles.count
  end

  it 'should filter by nil' do
    categories = Category.associated_to_cycles_levels(nil, nil, false)
    assert_equal categories.count, Category.all.count
  end
end
