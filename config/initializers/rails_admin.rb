RailsAdmin.config do |config|

  config.main_app_name = ["MyGoodCourse", "BackOffice"]

  require 'i18n'
  I18n.default_locale = :en

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
     warden.authenticate! scope: :employee
   end
  config.current_user_method(&:current_employee)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new do
      only [Category, Country, Customer, Comment, Cycle, Employee, Family, Level, Product] # no other model will have the `new` action visible. Note the extra brackets '[]' when there is more than one model.
    end
    export
    bulk_delete
    show
    edit do
      except [StripeAccount, Peer]
    end
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.model "Cycle" do
    parent Country
    edit do
      field :name
      field :description do
        partial 'form_summernote'
      end
    end
  end

  config.model "Level" do
    parent Cycle
    edit do
      field :name
      field :description do
        partial 'form_summernote'
      end
    end
  end

  config.model "Family" do
    parent Country
    edit do
      field :name
      field :description do
        partial 'form_summernote'
      end
    end
  end

  config.model "Category" do
    parent Family
    edit do
      field :name
      field :description do
        partial 'form_summernote'
      end
    end
  end

  config.model "OrderItem" do
    parent Order
  end

  config.model "Payment" do
    parent Order
    edit do
      field :order do
        read_only true
      end
      field :amount do
        read_only true
      end
      field :reference do
        read_only true
      end
      field :confirmed
      field :refundable
      field :amount_refunded
    end
  end

  config.model "StripeAccount" do
    parent Customer
  end

end
