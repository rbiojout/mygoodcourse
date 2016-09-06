# Preview all emails at http://localhost:3000/rails/mailers/order_mailer
class OrderMailerPreview < ActionMailer::Preview

  def received_en
    order = Order.first
    I18n.locale = 'en'
    OrderMailer.received(order)
  end

  def received_fr
    order = Order.first
    I18n.locale = 'fr'
    OrderMailer.received(order)
  end

  def accepted_en
    order = Order.first
    I18n.locale = 'en'
    OrderMailer.accepted(order)
  end

  def accepted_fr
    order = Order.first
    I18n.locale = 'fr'
    OrderMailer.accepted(order)
  end

  def rejected_en
    order = Order.first
    I18n.locale = 'en'
    OrderMailer.rejected(order)
  end

  def rejected_fr
    order = Order.first
    I18n.locale = 'fr'
    OrderMailer.rejected(order)
  end

end
