class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?


  before_action :set_i18n_locale_from_params

  before_filter :reload_rails_admin, if: :rails_admin_path?

  # ...
  protected
  def set_i18n_locale_from_params
    if params[:locale]
      if I18n.available_locales.map(&:to_s).include?(params[:locale])
        I18n.locale = params[:locale]
      else
        flash.now[:notice] =
            "#{params[:locale]} translation not available"
        logger.error flash.now[:notice]
      end
    else
      I18n.locale = I18n.default_locale
    end
  end


  # needed this form of set-up for devise
  # instead of
  # def default_url_options
  #  { locale: I18n.locale }
  # end
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  # needed this form of set-up for devise
  def self.default_url_options(options={})
    options.merge({ :locale => I18n.locale })
  end


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


  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, :keys => [:email, :password, :password_confirmation, :language, :country_id, :name, :first_name, :mobile, :birthdate, :picture, :picture_cache, :formatted_address, :street_address, :administrative_area_level_1,  :administrative_area_level_2, :postal_code, :locality, :lat, :lng, :description])
  end

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

  def reload_rails_admin
    models = %W(Article, Category, Country, Customer, Comment, Cycle, Employee, Family, Level, Product, Topic)
    models.each do |m|
      RailsAdmin::Config.reset_model(m)
    end
    RailsAdmin::Config::Actions.reset

    load("#{Rails.root}/config/initializers/rails_admin.rb")
  end

  def rails_admin_path?
    controller_path =~ /rails_admin/ && Rails.env.development?
  end

end
