module ControllerMacros
  def login_employee
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:employee]
      sign_in employees(:one)
    end
  end

  def login_customer
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:customer]
      sign_in customers(:one)
    end
  end
end
