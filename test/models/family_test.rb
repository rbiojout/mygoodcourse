require 'test_helper'

class FamilyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should filter by nil" do
    families = Family.associated_to_cycles_levels(nil, nil, false)
    assert_equal families.count, Family.all.count
  end

  test "should filter active by nil" do
    families = Family.associated_to_cycles_levels(nil, nil, true)
    assert_equal families.count, Family.with_active_products.count
  end

  test "should filter by level" do
    families = Family.associated_to_cycles_levels(nil, levels(:one), false)
    assert_not_equal families.count, 0
  end

  test "should filter by levels" do
    families = Family.associated_to_cycles_levels(nil, Level.all, false)
    assert_not_equal families.count, 0
  end

  test "should filter active by levels" do
    families = Family.associated_to_cycles_levels(nil, Level.all, true)
    assert_not_equal families.count, 0
  end

  test "should filter by cycle" do
    families = Family.associated_to_cycles_levels(cycles(:one), nil, false)
    assert_not_equal families.count, 0
  end


  test "should filter by cycles" do
    families = Family.associated_to_cycles_levels(Cycle.all, nil, false)
    assert_not_equal families.count, 0
  end

  test "should filter active by cycles" do
    families = Family.associated_to_cycles_levels(Cycle.all, nil, true)
    assert_not_equal families.count, 0
  end

  test "should filter by cycle and level" do
    families = Family.associated_to_cycles_levels(cycles(:one), levels(:one), false)
    assert_not_equal families.count, 0
  end

  test "should filter active by cycle and level" do
    families = Family.associated_to_cycles_levels(cycles(:one), levels(:one), true)
    assert_not_equal families.count, 0
  end
end
