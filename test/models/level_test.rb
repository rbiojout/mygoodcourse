require 'test_helper'

class LevelTest < ActiveSupport::TestCase
  # test 'the truth' do
  #   assert true
  # end
  test 'should filter by nil' do
    levels = Level.associated_to_families_categories(nil, nil, false)
    assert_equal levels.count, Level.all.count
  end

  test 'should filter active by nil' do
    levels = Level.associated_to_families_categories(nil, nil, true)
    assert_equal levels.count, Level.with_active_products.count
  end

  test 'should filter by category' do
    levels = Level.associated_to_families_categories(nil, categories(:one), false)
    assert_not_equal levels.count, 0
  end

  test 'should filter by categories' do
    levels = Level.associated_to_families_categories(nil, Category.all, false)
    assert_not_equal levels.count, 0
  end

  test 'should filter active by categories' do
    levels = Level.associated_to_families_categories(nil, Category.all, true)
    assert_not_equal levels.count, 0
  end

  test 'should filter by family' do
    levels = Level.associated_to_families_categories(families(:one), nil, false)
    assert_not_equal levels.count, 0
  end

  test 'should filter by families' do
    levels = Level.associated_to_families_categories(Family.all, nil, false)
    assert_not_equal levels.count, 0
  end
  test 'should filter active by families' do
    levels = Level.associated_to_families_categories(Family.all, nil, true)
    assert_not_equal levels.count, 0
  end

  test 'should filter by family and category' do
    levels = Level.associated_to_families_categories(families(:one), categories(:one), false)
    assert_not_equal levels.count, 0
  end

  test 'should filter active by family and category' do
    levels = Level.associated_to_families_categories(families(:one), categories(:one), true)
    assert_not_equal levels.count, 0
  end
end
