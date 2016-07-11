class Customers::RegistrationsController < Devise::RegistrationsController

  def create
    #build_resource

    @customer = Customer.new(customer_params)


    respond_to do |format|
      format.html {
        super
      }
      format.json {
        #@user_mailer = User.create(user_params)
        #@user_mailer.save ? (render :json => {:state => {:code => 0}, :data => @user_mailer }) :
            #(render :json => {:state => {:code => 1, :messages => @user_mailer.errors.full_messages} })
        if @customer.save
          if @customer.active_for_authentication?
            set_flash_message :notice, :signed_up if is_navigational_format?
            sign_up("Customers", @customer)
            return render :json => {:success => true}
          else
            set_flash_message :notice, :"signed_up_but_#{@customer.inactive_message}" if is_navigational_format?
            expire_session_data_after_sign_in!
            return render :json => {:success => true}
          end
        else
          clean_up_passwords @customer
          return render :json => {:success => false}
        end
      }
    end


  end

  # redirect to a specific page
  def after_sign_up_path_for(customers)
    catalog_products_path
    #'/an/example/path' # Or :prefix_to_your_route
  end




# GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  def destroy
    begin
      resource.destroy
    rescue
      #@TODO check if customer if prevented from being deleted
    end
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message! :notice, :destroyed
    yield resource if block_given?
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user_mailer wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.for(:sign_up) << :attribute
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.for(:account_update) << :attribute
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  private


  # Never trust parameters from the scary internet, only allow the white list through.
  def customer_params
    params.require(:customer).permit(:name, :first_name, :email, :password, :password_confirmation, :language, :country_id, :mobile, :picture, :picture_cache, :formatted_address, :street_address, :administrative_area_level_1,  :administrative_area_level_2, :postal_code, :locality, :lat, :lng, :description)
  end


end
