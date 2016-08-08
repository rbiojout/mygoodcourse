class ChartsController < ApplicationController
  before_action :authenticate_customer!

  def accepted_orders
    render json: OrderItem.find_sold_by_customer(current_customer, 'accepted').unscope(:order).group_by_day("order_items.created_at").count
  end

  def created_products
    render json: current_customer.products.group_by_day(:created_at).count
  end


end
