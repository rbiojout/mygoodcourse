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

  # add the possibility to have a custom redirect after sign in with devise
  # add in the session controller
  # if params[:redirect_to].present?
  #   store_location_for(resource, params[:redirect_to])
  # end
  def after_sign_in_path_for(resource)
    sign_in_url = new_customer_session_url
    if request.referer == sign_in_url
      super
    else
      stored_location_for(resource) || request.referer || root_path
    end
  end


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
