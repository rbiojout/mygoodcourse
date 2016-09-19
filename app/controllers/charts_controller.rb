class ChartsController < ApplicationController
  before_action :authenticate_customer!, only: [:accepted_orders, :created_products, :amount_orders]
  before_action :authenticate_employee!, only: [:created_customers, :sign_in_customers, :created_comments]

  ###################
  # stats for current customer
  ###################
  def accepted_orders
    render json: OrderItem.find_sold_by_customer(current_customer, Order::STATE_ACCEPTED).where(:created_at => (Time.now - 6.month)..Time.now).unscope(:order).group_by_day("order_items.created_at").sum(:price)
  end

  def created_products
    sum = current_customer.products.where(:created_at => (Time.now-100.year)..(Time.now - 6.month)).count
    render json: current_customer.products.where(:created_at => (Time.now - 6.month)..Time.now).group(:price).group_by_day(:created_at).count.map { |x,y| { x => (sum += y)} }.reduce({}, :merge).chart_json
  end

  def visited_products
    #User.group_by_week(:created_at).order("week asc").count.map { |x,y| { x => (sum += y)} }.reduce({}, :merge)

    free_products = current_customer.free_products
    paid_products = current_customer.paid_products

    # this method don't take advantage of history
    # we need to use the impression data as the counter_cache don't have history
    #start_free = current_customer.products.where(:price => '0.0').where(:created_at => (Time.now-100.year)..(Time.now - 6.month)).sum(:counter_cache)
    #for_free = current_customer.products.where(:price => '0.0').where(:created_at => (Time.now - 6.month)..Time.now).group_by_day(:created_at).sum(:counter_cache).map { |x,y| { x => (start_free += y)} }.reduce({}, :merge)


    start_free = Impression.where(:impressionable_type => 'Product', :impressionable_id => free_products).where.not(:created_at => (Time.now - 6.month)..Time.now).count
    # be carefull to have .sum(1) in order to be able to map results
    for_free = Impression.where(:impressionable_type => 'Product', :impressionable_id => free_products).where(:created_at => (Time.now - 6.month)..Time.now).group_by_day("impressions.created_at").sum(1).map { |x,y| { x => (start_free += y)} }.reduce({}, :merge)



    #start_paid = current_customer.products.where.not(:price => '0.0').where(:created_at => (Time.now-100.year)..(Time.now - 6.month)).sum(:counter_cache)
    #for_paid = current_customer.products.where.not(:price => '0.0').where(:created_at => (Time.now - 6.month)..Time.now).group_by_day(:created_at).sum(:counter_cache).map { |x,y| { x => (start_paid += y)} }.reduce({}, :merge)
    start_paid = Impression.where(:impressionable_type => 'Product', :impressionable_id => paid_products).where.not(:created_at => (Time.now - 6.month)..Time.now).count
    for_paid = Impression.where(:impressionable_type => 'Product', :impressionable_id => paid_products).where(:created_at => (Time.now - 6.month)..Time.now).group_by_day("impressions.created_at").sum(1).map { |x,y| { x => (start_paid += y)} }.reduce({}, :merge)

    render json: [{name: I18n.translate('dialog.free'), data: for_free},{name: I18n.translate('dialog.not_free'), data: for_paid}]
    #render json: current_customer.products.where(:created_at => (Time.now - 6.month)..Time.now).group_by_day(:created_at).sum(:counter_cache).chart_json
  end

  def amount_orders


    render json: OrderItem.find_sold_by_customer(current_customer, Order::STATE_ACCEPTED).where(:created_at => (Time.now - 6.month)..Time.now).unscope(:order).group_by_day("order_items.created_at").sum(:price)
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
