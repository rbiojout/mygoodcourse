require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should filter by nil" do
    categories = Category.associated_to_cycles_levels(nil, nil, false)
    assert_equal categories.count, Category.all.count
  end

  test "should filter active by nil" do
    categories = Category.associated_to_cycles_levels(nil, nil, true)
    assert_equal categories.count, Category.with_active_products.count
  end

  test "should filter by level" do
    categories = Category.associated_to_cycles_levels(nil, levels(:C1L1), false)
    assert_not_equal categories.count, 0
    assert products(:ProdF1C1_C1L1).levels.include?(levels(:C1L1))
    assert products(:ProdF1C1_C1L1).categories.include?(categories(:F1C1))
    assert categories.include?(categories(:F1C1))
    assert Product.find_by_level(levels(:C1L1).id).include?(products(:ProdF1C1_C1L1))
  end

  test "should filter by levels" do
    categories = Category.associated_to_cycles_levels(nil, Level.all, false)
    assert_not_equal categories.count, 0
  end

  test "should filter active by levels" do
    categories = Category.associated_to_cycles_levels(nil, Level.all, true)
    assert_not_equal categories.count, 0
  end

  test "should filter by cycle" do
    categories = Category.associated_to_cycles_levels(cycles(:C1), nil, false)
    assert_not_equal categories.count, 0
    assert products(:ProdF1C1_C1L1).cycles.include?(cycles(:C1))
    assert products(:ProdF1C1_C1L1).categories.include?(categories(:F1C1))
    assert categories.include?(categories(:F1C1))
    assert Product.find_by_category(categories(:F1C1).id).include?(products(:ProdF1C1_C1L1))
  end


  test "should filter by cycles" do
    categories = Category.associated_to_cycles_levels(Cycle.all, nil, false)
    assert_not_equal categories.count, 0
  end

  test "should filter active by cycles" do
    categories = Category.associated_to_cycles_levels(Cycle.all, nil, true)
    assert_not_equal categories.count, 0
  end

  test "should filter by cycle and level" do
    categories = Category.associated_to_cycles_levels(cycles(:one), levels(:one), false)
    assert_not_equal categories.count, 0
  end

  test "should filter active by cycle and level" do
    categories = Category.associated_to_cycles_levels(cycles(:one), levels(:one), true)
    assert_not_equal categories.count, 0
  end
end
