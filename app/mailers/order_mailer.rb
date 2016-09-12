class OrderMailer < ApplicationMailer
  def received(order)
    @order = order
    mail to: order.customer.email, subject: I18n.t('order_mailer.received.subject', default: 'Order Confirmation')
  end

  def accepted(order)
    @order = order
    mail to: order.customer.email, subject: I18n.t('order_mailer.accepted.subject', default: 'Order Accepted')
  end

  def rejected(order)
    @order = order
    mail to: order.customer.email, subject: I18n.t('order_mailer.rejected.subject', default: 'Order Rejected')
  end

end
