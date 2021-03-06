# rubocop:disable Metrics/AbcSize

require 'bigdecimal'

class ChartsController < ApplicationController
  before_action :authenticate_customer!, only: [:accepted_orders, :created_products, :amount_orders]
  before_action :authenticate_employee!, only: [:created_customers, :sign_in_customers, :created_reviews]

  before_action :adjust_time

  ###################
  # stats for current customer
  ###################
  def accepted_orders
    render json: OrderItem.find_sold_by_customer(current_customer, Order::STATE_ACCEPTED).where(created_at: @range_time).unscope(:order).group_by_day('order_items.created_at').sum(:price)
  end

  def created_products
    sum = current_customer.products.where(created_at: (@present_time - 100.years)..(@past_time)).count
    render json: current_customer.products.where(created_at: @range_time).group(:price).group_by_day(:created_at).count.map { |day, value| {day => (sum += value)} }.reduce({}, :merge).chart_json
  end

  def visited_products
    # User.group_by_week(:created_at).order("week asc").count.map { |x,y| { x => (sum += y)} }.reduce({}, :merge)

    free_products = current_customer.free_products
    paid_products = current_customer.paid_products

    # this method don't take advantage of history
    # we need to use the impression data as the counter_cache don't have history
    # start_free = current_customer.products.where(:price => '0.0').where(:created_at => (@present_time-100.year)..(@past_time)).sum(:counter_cache)
    # for_free = current_customer.products.where(:price => '0.0').where(:created_at => @range_time).group_by_day(:created_at).sum(:counter_cache).map { |x,y| { x => (start_free += y)} }.reduce({}, :merge)

    start_free = Impression.where(impressionable_type: 'Product', impressionable_id: free_products).where.not(created_at: @range_time).count
    # be carefull to have .sum(1) in order to be able to map results
    for_free = Impression.where(impressionable_type: 'Product', impressionable_id: free_products).where(created_at: @range_time).group_by_day('impressions.created_at').sum(1).map { |day, value| {day => (start_free += value)} }.reduce({}, :merge)

    # start_paid = current_customer.products.where.not(:price => '0.0').where(:created_at => (@present_time-100.year)..(@past_time)).sum(:counter_cache)
    # for_paid = current_customer.products.where.not(:price => '0.0').where(:created_at => @range_time).group_by_day(:created_at).sum(:counter_cache).map { |x,y| { x => (start_paid += y)} }.reduce({}, :merge)
    start_paid = Impression.where(impressionable_type: 'Product', impressionable_id: paid_products).where.not(created_at: @range_time).count
    for_paid = Impression.where(impressionable_type: 'Product', impressionable_id: paid_products).where(created_at: @range_time).group_by_day('impressions.created_at').sum(1).map { |day, value| {day => (start_paid += value)} }.reduce({}, :merge)

    render json: [{name: I18n.translate('dialog.free'), data: for_free}, {name: I18n.translate('dialog.not_free'), data: for_paid}]
    # render json: current_customer.products.where(:created_at => @range_time).group_by_day(:created_at).sum(:counter_cache).chart_json
  end

  def amount_orders
    render json: OrderItem.find_sold_by_customer(current_customer, Order::STATE_ACCEPTED).where(created_at: @range_time).unscope(:order).group_by_day('order_items.created_at').sum(:price)
  end

  ###################
  # stats for current employee
  ###################
  def created_customers
    sum = Customer.all.where.not(created_at: @range_time).unscope(:order).count
    render json: Customer.all.where(created_at: @range_time).unscope(:order).group_by_day('created_at').count.map { |x, y| {x => (sum += y)} }.reduce({}, :merge).chart_json
  end

  def sign_in_customers
    render json: Customer.all.where(created_at: @range_time).unscope(:order).group_by_day('updated_at').sum(:sign_in_count)
  end

  def created_reviews
    sum = Review.all.where(created_at: @range_time).unscope(:order).count
    render json: Review.all.where(created_at: @range_time).unscope(:order).group_by_day('created_at').count.map { |day, value| {day => (sum += value)} }.reduce({}, :merge).chart_json
  end

  def catalog_products
    start_free = Product.where.not(created_at: @range_time).where(price: 0.0).count
    start_paid = Product.where.not(created_at: @range_time).where.not(price: 0.0).count

    for_free = Product.where(created_at: @range_time).where(price: 0.0).group_by_day(:created_at).count.map { |day, value| {day => (start_free += value)} }.reduce({}, :merge)
    for_paid = Product.where(created_at: @range_time).where.not(price: 0.0).group_by_day(:created_at).count.map { |day, value| {day => (start_paid += value)} }.reduce({}, :merge)

    render json: [{name: I18n.translate('dialog.free'), data: for_free}, {name: I18n.translate('dialog.not_free'), data: for_paid}]
  end

  def catalog_visits
    # User.group_by_week(:created_at).order("week asc").count.map { |x,y| { x => (sum += y)} }.reduce({}, :merge)

    free_products = Product.where(price: 0.0)
    paid_products = Product.where.not(price: 0.0)

    # this method don't take advantage of history
    # we need to use the impression data as the counter_cache don't have history
    # start_free = current_customer.products.where(:price => '0.0').where(:created_at => (@present_time-100.years)..(@past_time)).sum(:counter_cache)
    # for_free = current_customer.products.where(:price => '0.0').where(:created_at => @range_time).group_by_day(:created_at).sum(:counter_cache).map { |x,y| { x => (start_free += y)} }.reduce({}, :merge)

    start_free = Impression.where(impressionable_type: 'Product', impressionable_id: free_products).where.not(created_at: @range_time).count
    # be carefull to have .sum(1) in order to be able to map results
    for_free = Impression.where(impressionable_type: 'Product', impressionable_id: free_products).where(created_at: @range_time).group_by_day('impressions.created_at').sum(1).map { |day, value| {day => (start_free += value)} }.reduce({}, :merge)

    # start_paid = current_customer.products.where.not(:price => '0.0').where(:created_at => (@present_time-100.year)..(@past_time)).sum(:counter_cache)
    # for_paid = current_customer.products.where.not(:price => '0.0').where(:created_at => @range_time).group_by_day(:created_at).sum(:counter_cache).map { |x,y| { x => (start_paid += y)} }.reduce({}, :merge)
    start_paid = Impression.where(impressionable_type: 'Product', impressionable_id: paid_products).where.not(created_at: @range_time).count
    for_paid = Impression.where(impressionable_type: 'Product', impressionable_id: paid_products).where(created_at: @range_time).group_by_day('impressions.created_at').sum(1).map { |day, value| {day => (start_paid += value)} }.reduce({}, :merge)

    render json: [{name: I18n.translate('dialog.free'), data: for_free}, {name: I18n.translate('dialog.not_free'), data: for_paid}]
    # render json: current_customer.products.where(:created_at => @range_time).group_by_day(:created_at).sum(:counter_cache).chart_json
  end

  private

  def adjust_time
    @present_time = Time.now.in_time_zone
    @past_time = @present_time - 6.months
    @range_time = @past_time..@present_time
  end

end
