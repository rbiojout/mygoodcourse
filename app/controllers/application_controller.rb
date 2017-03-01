class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  # saves the location before loading each page so we can return to the
  # right page. If we're on a devise page, we don't want to store that as the
  # place to return to (for example, we don't want to return to the sign in page
  # after signing in), which is what the :unless prevents
  before_action :store_current_location, unless: :devise_controller?

  before_action :set_i18n_locale_from_params

  before_action :current_country

  before_action :reload_rails_admin, if: :rails_admin_path?

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

  # We need to have a filter when listing.
  def current_country_2
    if params[:country_id]
      country_id = params[:country_id]
      # validate if the Country exist
      @current_country = Country.find(country_id)
      session[:current_country_id] = @current_country.id
      @current_country
    else
      country_id = session[:current_country_id]
      @current_country ||= begin Country.find(country_id)
                                 session[:current_country_id] = Country.find(country_id).id
      rescue
        Country.first
        session[:current_country_id] = Country.first.id
      end
      @current_country
    end
  end

  def current_country
    if params[:country_id]
      logger.debug(' got a country change')
      begin
        @current_country = Country.find(params[:country_id])
        logger.debug(@current_country.name)
        session[:current_country_id] = @current_country.id
        @current_country
      rescue ActiveRecord::RecordNotFound
        @current_country = Country.first
        session[:current_country_id] = @current_country.id
        @current_country
      end
    else
      if session[:current_country_id]
        @current_country ||= Country.find(session[:current_country_id])
      else
        @current_country ||= @current_country = Country.first
        session[:current_country_id] = @current_country.id
        @current_country
      end
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
  def self.default_url_options(options = {})
    options.merge(locale: I18n.locale)
  end

  # Returns the active order for this session
  # def current_order
  #  if !session[:order_id].nil?
  #    Order.find(session[:order_id])
  #  else
  #    Order.new
  #  end
  # end

  # add the possibility to have a custom redirect after sign in with devise
  # add in the session controller
  # if params[:redirect_to].present?
  #   store_location_for(resource, params[:redirect_to])
  # end
  def after_sign_in_path_for(resource)
    sign_in_url = new_customer_session_url
    if request.referer == sign_in_url
      logger.debug('%%%%')
      super
    else
      logger.debug('ffff')
      stored_location_for(resource) || request.referer || root_path
    end
  end

private

  # override the devise helper to store the current location so we can
  # redirect to it after loggin in or out. This override makes signing in
  # and signing up work automatically.
  def store_current_location
    store_location_for(:customer, request.url)
  end

  # override the devise method for where to go after signing out because theirs
  # always goes to the root path. Because devise uses a session variable and
  # the session is destroyed on log out, we need to use request.referrer
  # root_path is there as a backup
  def after_sign_out_path_for(_resource)
    request.referrer || root_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :language, :country_id, :name, :first_name, :mobile, :birthdate, :picture, :picture_cache, :formatted_address, :street_address, :administrative_area_level_1, :administrative_area_level_2, :postal_code, :locality, :lat, :lng, :description, :terms_of_service])
  end

  # Returns the active order for this session
  def current_order
    @current_order ||= begin
      if has_order?
        @current_order
      else
        # @TODO add country for order
        # order = Order.create(:ip_address => request.ip, :billing_country => Shoppe::Country.where(:name => "United Kingdom").first)
        order = Order.create(ip_address: request.ip)
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
    models = %w(Article Category Country Customer Cycle Employee Family ForumFamily ForumCategory ForumSubject ForumAnswer Impression Level Post Product Review Topic Update)
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
