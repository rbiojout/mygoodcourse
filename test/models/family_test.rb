require 'test_helper'

class FamilyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should filter by nil" do
    families = Family.associated_to_cycles_levels(nil, nil, nil, false)
    assert_equal families.count, Family.all.count
  end

  test "should filter active by nil" do
    families = Family.associated_to_cycles_levels(nil, nil, nil, true)
    assert_equal families.count, Family.with_active_products.count
  end

  test "should filter by level" do
    families = Family.associated_to_cycles_levels(nil, levels(:C1L1), nil, false)
    assert_not_equal families.count, 0
    assert products(:ProdF1C1_C1L1).levels.include?(levels(:C1L1))
    assert products(:ProdF1C1_C1L1).families.include?(families(:F1))
    assert families.include?(families(:F1))
    assert Product.find_by_level(levels(:C1L1).id).include?(products(:ProdF1C1_C1L1))

  end

  test "should filter by levels" do
    families = Family.associated_to_cycles_levels(nil, Level.all, nil, false)
    assert_not_equal families.count, 0
  end

  test "should filter active by levels" do
    families = Family.associated_to_cycles_levels(nil, Level.all, nil, true)
    assert_not_equal families.count, 0
  end

  test "should filter by cycle" do
    families = Family.associated_to_cycles_levels(cycles(:one), nil, nil, false)
    assert_not_equal families.count, 0
  end


  test "should filter by cycles" do
    families = Family.associated_to_cycles_levels(Cycle.all, nil, nil, false)
    assert_not_equal families.count, 0
    assert products(:ProdF1C1_C1L1).cycles.include?(cycles(:C1))
    assert products(:ProdF1C1_C1L1).families.include?(families(:F1))
    assert families.include?(families(:F1))
    assert Product.find_by_category(categories(:F1C1).id).include?(products(:ProdF1C1_C1L1))
  end

  test "should filter active by cycles" do
    families = Family.associated_to_cycles_levels(Cycle.all, nil, nil, true)
    assert_not_equal families.count, 0
  end

  test "should filter by cycle and level" do
    families = Family.associated_to_cycles_levels(cycles(:one), levels(:one), nil, false)
    assert_not_equal families.count, 0
  end

  test "should filter active by cycle and level" do
    families = Family.associated_to_cycles_levels(cycles(:one), levels(:one), nil, true)
    assert_not_equal families.count, 0
  end
end
