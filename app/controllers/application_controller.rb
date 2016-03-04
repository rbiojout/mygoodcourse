class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  # Returns the active order for this session
  #def current_order
  #  if !session[:order_id].nil?
  #    Order.find(session[:order_id])
  #  else
  #    Order.new
  #  end
  #end

  private

  # Returns the active order for this session
  def current_order
    @current_order ||= begin
      if has_order?
        @current_order
      else
        # @TODO add country for order
        #order = Order.create(:ip_address => request.ip, :billing_country => Shoppe::Country.where(:name => "United Kingdom").first)
        order = Order.create(:ip_address => request.ip)
        session[:order_id] = order.id
        order
      end
    end
  end


  # Has an active order?
  def has_order?
    session[:order_id] && @current_order = Order.includes(:order_items).find_by_id(session[:order_id])
  end

  helper_method :current_order, :has_order?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :name, :first_name, :mobile, :picture, :street_address, :administrative_area_level_1,  :administrative_area_level_2, :postal_code, :locality, :lat, :lng) }

  end

end
