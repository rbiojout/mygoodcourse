module CustomersHelper
  def customer_picture(customer)
    customer.picture.url
  rescue Exception => exc
    logger.error("Message for the log file #{exc.message}")
    'empty_preview.png'
  end
end
