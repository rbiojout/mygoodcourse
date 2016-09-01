class ChartsController < ApplicationController
  before_action :authenticate_customer!, only: [:accepted_orders, :created_products, :amount_orders]
  before_action :authenticate_employee!, only: [:created_customers, :sign_in_customers, :created_comments]

  ###################
  # stats for current customer
  ###################
  def accepted_orders
    render json: OrderItem.find_sold_by_customer(current_customer, 'accepted').where(:created_at => (Time.now - 6.month)..Time.now).unscope(:order).group_by_day("order_items.created_at").sum(:price)
  end

  def created_products
    render json: current_customer.products.where(:created_at => (Time.now - 6.month)..Time.now).group(:price).group_by_day(:created_at).count.chart_json
  end

  def amount_orders
    render json: OrderItem.find_sold_by_customer(current_customer, 'accepted').where(:created_at => (Time.now - 6.month)..Time.now).unscope(:order).group_by_day("order_items.created_at").count
  end

  ###################
  # stats for current employee
  ###################
  def created_customers
    render json: Customer.all.where(:created_at => (Time.now - 6.month)..Time.now).unscope(:order).group_by_day("created_at").count
  end

  def sign_in_customers
    render json: Customer.all.where(:created_at => (Time.now - 6.month)..Time.now).unscope(:order).group_by_day("updated_at").sum(:sign_in_count)
  end

  def created_comments
    render json: Comment.all.where(:created_at => (Time.now - 6.month)..Time.now).unscope(:order).group_by_day("created_at").count
  end

end
