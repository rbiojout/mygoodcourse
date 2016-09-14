require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "count filtered by cycles" do
    assert_equal 2, Product.count_active_filtered_for_cycle(cycles(:C1), nil, nil)
    found_for_family = Product.for_family(families(:F1))
    assert_equal 2, found_for_family.count
    assert found_for_family.include?(products(:ProdF1C1_C1L1))
    assert found_for_family.include?(products(:ProdF1C2_C1L2))

    found_for_cycle = Product.for_cycle(cycles(:C1))
    assert_equal 2, found_for_cycle.count
    assert found_for_cycle.include?(products(:ProdF1C1_C1L1))
    assert found_for_cycle.include?(products(:ProdF1C2_C1L2))

    assert_equal 2, Product.count_active_filtered_for_cycle(cycles(:C1), families(:F1), nil)
    assert_equal 1, Product.count_active_filtered_for_cycle(cycles(:C1), families(:F1), categories(:F1C1))
    assert_equal 0, Product.count_active_filtered_for_cycle(cycles(:C1), families(:F2), nil)
    assert_equal 0, Product.count_active_filtered_for_cycle(cycles(:C1), families(:F1), categories(:F2C1))
    assert_equal 0, Product.count_active_filtered_for_cycle(cycles(:C1), nil, categories(:F2C1))
  end

  test "count filtered by levels" do
    assert_equal 1, Product.count_active_filtered_for_level(levels(:C1L1), nil, nil)
    found_for_level = Product.for_level(levels(:C1L1))
    assert_equal 1, found_for_level.count
    assert found_for_level.include?(products(:ProdF1C1_C1L1))
    assert_not found_for_level.include?(products(:ProdF1C2_C1L2))

    found_for_cycle = Product.for_cycle(cycles(:C1))
    assert_equal 2, found_for_cycle.count
    assert found_for_cycle.include?(products(:ProdF1C1_C1L1))
    assert found_for_cycle.include?(products(:ProdF1C2_C1L2))

    assert_equal 1, Product.count_active_filtered_for_level(levels(:C1L1), families(:F1), nil)
    assert_equal 1, Product.count_active_filtered_for_level(levels(:C1L1), families(:F1), categories(:F1C1))
    assert_equal 0, Product.count_active_filtered_for_level(levels(:C1L1), families(:F2), nil)
    assert_equal 0, Product.count_active_filtered_for_level(levels(:C1L1), families(:F1), categories(:F2C1))
    assert_equal 0, Product.count_active_filtered_for_level(levels(:C1L1), nil, categories(:F2C1))
  end

  test "count filtered by families" do
    assert_equal 2, Product.count_active_filtered_for_family(families(:F1), nil, nil)
    found_for_family = Product.for_family(families(:F1))
    assert_equal 2, found_for_family.count
    assert found_for_family.include?(products(:ProdF1C1_C1L1))
    assert found_for_family.include?(products(:ProdF1C2_C1L2))

    found_for_cycle = Product.for_cycle(cycles(:C1))
    assert_equal 2, found_for_cycle.count
    assert found_for_cycle.include?(products(:ProdF1C1_C1L1))
    assert found_for_cycle.include?(products(:ProdF1C2_C1L2))

    assert_equal 2, Product.count_active_filtered_for_family(families(:F1), cycles(:C1), nil)
    assert_equal 1, Product.count_active_filtered_for_family(families(:F1), cycles(:C1), levels(:C1L1))
    assert_equal 0, Product.count_active_filtered_for_family(families(:F1), cycles(:C2), nil)
    assert_equal 0, Product.count_active_filtered_for_family(families(:F1), cycles(:C1), levels(:C2L1))
    assert_equal 0, Product.count_active_filtered_for_family(families(:F1), nil, levels(:C2L1))
  end

  test "count filtered by categories" do
    assert_equal 1, Product.count_active_filtered_for_category(categories(:F1C1), nil, nil)
    found_for_category = Product.for_category(categories(:F1C1))
    assert_equal 1, found_for_category.count
    assert found_for_category.include?(products(:ProdF1C1_C1L1))
    assert_not found_for_category.include?(products(:ProdF1C2_C1L2))

    assert_equal 1, Product.count_active_filtered_for_category(categories(:F1C1), cycles(:C1), nil)
    assert_equal 1, Product.count_active_filtered_for_category(categories(:F1C1), cycles(:C1), levels(:C1L1))
    assert_equal 0, Product.count_active_filtered_for_category(categories(:F1C1), cycles(:C2), nil)
    assert_equal 0, Product.count_active_filtered_for_category(categories(:F1C1), cycles(:C1), levels(:C2L1))
    assert_equal 0, Product.count_active_filtered_for_category(categories(:F1C1), nil, levels(:C2L1))
  end

  test 'should be associated to orders' do
    assert_not_empty Product.find_ordered_by_customer(customers(:one).id)
    #@TODO verify the status
  end

  test 'should be associated to accepted order' do
    assert_not_empty Product.find_bought_by_customer(customers(:one).id)
    #@TODO verify the status
  end

  test 'should be confirm owned product' do
    # product
    product = products(:free_from_seller_one)
    customer = customers(:buyer_one)
    assert product.is_bought_by_customer(customer.id)

    # negative
    product = products(:two_from_seller_one)
    assert !product.is_bought_by_customer(customer.id)
  end


end
