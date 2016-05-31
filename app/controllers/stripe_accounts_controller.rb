class StripeAccountsController < ApplicationController

  before_action :authenticate_customer!, only: [:managed, :standalone, :oauth, :confirm, :deauthorize]

  # Create a manage StripeAccount account for yourself.
  # Only works on the currently logged in user.
  # See app/services/stripe_managed.rb for details.
  def managed
    connector = StripeManaged.new( current_customer )
    account = connector.create_account!(
      params[:country], params[:tos] == 'on', request.remote_ip
    )

    if account
      flash[:notice] = "Managed StripeAccount account created! <a target='_blank' rel='platform-account' href='https://dashboard.stripe.com/test/applications/users/#{account.id}'>View in dashboard &raquo;</a>"
    else
      flash[:error] = "Unable to create StripeAccount account!"
    end
    redirect_to customer_path( current_customer )
  end

  # Create a standalone StripeAccount account for yourself.
  # Only works on the currently logged in user.
  # See app/services/stripe_unmanaged.rb for details.
  def standalone
    connector = StripeStandalone.new( current_customer )
    account = connector.create_account!( params[:country] )

    if account
      flash[:notice] = "Standalone StripeAccount account created! <a target='_blank' rel='platform-account' href='https://dashboard.stripe.com/test/applications/users/#{account.id}'>View in dashboard &raquo;</a>"
    else
      flash[:error] = "Unable to create StripeAccount account!"
    end
    redirect_to customer_path(current_customer)
  end

  # Connect yourself to a StripeAccount account.
  # Only works on the currently logged in user.
  # See app/services/stripe_oauth.rb for #oauth_url details.
  def oauth
    connector = StripeOauth.new( current_customer )

    logger.debug(connector);

    #logger.debug("===> #{stripe_confirm_url}")

    url, error = connector.oauth_url( redirect_uri: stripe_confirm_url )

    if url.nil?
      flash[:error] = error
      redirect_to customer_path( current_customer )
    else
      redirect_to url
    end
  end

  # Confirm a connection to a StripeAccount account.
  # Only works on the currently logged in user.
  # See app/services/stripe_connect.rb for #verify! details.
  def confirm
    connector = StripeOauth.new( current_customer )
    if params[:code]
      # If we got a 'code' parameter. Then the
      # connection was completed by the user.
      connector.verify!( params[:code] )

    elsif params[:error]
      # If we have an 'error' parameter, it's because the
      # user denied the connection request. Other errors
      # are handled at #oauth_url generation time.
      flash[:error] = "Authorization request denied."
    end

    redirect_to customer_path( current_customer )
  end

  # Deauthorize the application from accessing
  # the connected StripeAccount account.
  # Only works on the currently logged in user.
  def deauthorize
    connector = StripeOauth.new( current_customer )
    connector.deauthorize!
    flash[:notice] = "Account disconnected from StripeAccount."
    redirect_to customer_path( current_customer )
  end
end

