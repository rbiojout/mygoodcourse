class OrderMailer < ApplicationMailer
  def received(order)
    @order = order
    mail to: order.customer.email, subject: I18n.t('order_mailer.received.subject', default: 'Order Confirmation')
  end

  def accepted(order)
    @order = order
    mail to: order.customer.email, subject: I18n.t('order_mailer.received.accepted', default: 'Order Accepted')
  end

  def rejected(order)
    @order = order
    mail to: order.customer.email, subject: I18n.t('order_mailer.received.rejected', default: 'Order Rejected')
  end

end
