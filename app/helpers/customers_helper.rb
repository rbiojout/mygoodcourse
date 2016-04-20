module CustomersHelper

  def customer_picture(customer)
    begin
      customer.picture.url
    rescue Exception => exc
      logger.error("Message for the log file #{exc.message}")
      "empty_preview.png"
    end
  end
end
