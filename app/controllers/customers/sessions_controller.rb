class Customers::SessionsController < Devise::SessionsController
# before_filter :configure_sign_in_params, only: [:create]

  # force the redirect to html form even with js by changing the view
  # add a way to specify the redirect with the parameter redirect_to
  def new
    logger.debug('hho')
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    yield resource if block_given?
    if params[:redirect_to].present?
      store_location_for(resource, params[:redirect_to])
    end
    respond_with(resource, serialize_options(resource))
  end

  # redirect to the



  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    # set the locale
    I18n.locale = resource.language
    # set the country
    session[:current_country_id] = resource.country_id
    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource), locale: I18n.locale, country_id: resource.country_id
  end

    # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end
end
