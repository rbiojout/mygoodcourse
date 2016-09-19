module ProductsHelper

  # helper to look if the product belongs to current_customer
  # based on a previously made order
  # @param product[Product]
  # @param current_customer[Customer]
  # @return [Boolean]
  def already_bought(product, current_customer)
    if current_customer.nil?
      return false
    else
      return product.in?Product.find_bought_by_customer(current_customer.id)
    end
  end

  # helper to get the list of impressions
  # associated to a collection of products
  # @param products[Product collaction]
  # @return [@Collection]
  def impressions_list(products)
    Impression.where(:impressionable_type => 'Product', :impressionable_id => products)
  end

end
