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
      except [File, StripeAccount, Peer]
    end
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.model "Cycle" do
    parent Country
    list do
      sort_by :country_id
      field :id
      field :name
      field :position
      field :country_id
      field :created_at
      field :updated_at
    end
    edit do
      field :country
      field :name
      field :description do
        partial 'form_summernote'
      end
    end
  end

  config.model "Comment" do
    parent Product
    edit do
      field :title
      field :description
    end
  end

  config.model "Customer" do
    edit do
      field :name
      field :first_name
      field :mobile
      field :email
      field :password
      field :password_confirmation
      field :street_address
      field :administrative_area_level_1
      field :administrative_area_level_2
      field :postal_code
      field :locality
      field :birthdate do
        date_format :default
      end
      field :confirmed_at do
        strftime_format "%Y-%m-%d"
      end
      field :language
      field :country
      field :description
    end
  end

  config.model "Employee" do
    edit do
      field :name
      field :first_name
      field :entry_date do
        date_format :default
      end
      field :mobile
      field :role
      field :active
      field :email
      field :password
      field :password_confirmation
    end

  end

  config.model "Level" do
    parent Cycle
    list do
      sort_by :cycle_id
      field :id
      field :name
      field :position
      field :cycle_id
      field :created_at
      field :updated_at
    end
    edit do
      field :cycle
      field :name
      field :description do
        partial 'form_summernote'
      end
    end
  end

  config.model "Family" do
    parent Country
    list do
      sort_by :country_id
      field :id
      field :name
      field :position
      field :country_id
      field :created_at
      field :updated_at
    end
    edit do
      field :country
      field :name
      field :description do
        partial 'form_summernote'
      end
    end
  end

  config.model "Category" do
    parent Family
    list do
      sort_by :family_id
      field :id
      field :name
      field :position
      field :family_id
      field :created_at
      field :updated_at
    end
    edit do
      field :family
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
