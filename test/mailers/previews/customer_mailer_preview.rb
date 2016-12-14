# Preview all emails at http://localhost:3000/rails/mailers/customer_mailer
class CustomerMailerPreview < ActionMailer::Preview
  def confirmation_instructions
    customer = Customer.first
    Devise::Mailer.confirmation_instructions(customer, 'token')
  end

  def reset_password_instructions
    customer = Customer.first
    Devise::Mailer.reset_password_instructions(customer, 'token')
  end

  # def unlock_instructions
  #  customer = Customer.first
  #  Devise::Mailer.unlock_instructions(customer, 'token')
  # end

  def password_change
    customer = Customer.first
    Devise::Mailer.password_change(customer)
  end
end
