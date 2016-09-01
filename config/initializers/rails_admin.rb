require Rails.root.join('lib','rails_admin','custom_actions.rb')
require Rails.root.join('lib','rails_admin','custom_dashboards.rb')


RailsAdmin.config do |config|

  config.main_app_name = ["MyGoodCourse", "BackOffice"]

  require 'i18n'
  I18n.default_locale = :fr

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

  config.browser_validations = false # Default is true

  config.actions do
    stats_users
    dashboard                     # mandatory
    index                         # mandatory
    new do
      only [Article, Category, Country, Customer, Cycle, Employee, Family, Level, Topic] # no other model will have the `new` action visible. Note the extra brackets '[]' when there is more than one model.
    end
    export
    bulk_delete
    show
    edit do
      except [File, StripeAccount, Peer]
    end
    delete
    # Set the custom action here
    sort_for_country
    sort_for_topic
    sort_for_cycle
    sort_for_family


    show_in_app


    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.model "Article" do
    parent Topic
    list do
      sort_by :topic_id
      field :id
      field :name
      field :topic
      field :visits
      field :created_at
      field :updated_at
    end
    edit do
      field :topic
      field :name
      field :description do
        partial 'form_summernote'
      end
    end
    show do
      field :name
      field :description do
        formatted_value do
          value.html_safe
        end
      end
      field :topic
    end

  end

  config.model "Country" do
    list do
      field :id
      field :name
      field :created_at
      field :updated_at
    end
    edit do
      field :name
      field :continent
      field :currency
      field :eu_member
      field :code2
      field :code3
      field :tld
      field :cycles
      field :families
      field :topics do
        #orderable false
        #removable false
        #inline_add false
        #help 'Topic association is disabled in this screen. Only the sort is possible'
      end
    end
  end

  config.model "Cycle" do
    parent Country
    list do
      sort_by :country_id
      field :id
      field :name
      field :country
      field :created_at
      field :updated_at
    end
    edit do
      field :country
      field :name
      field :description do
        partial 'form_summernote'
      end
      field :levels
    end
    show do
      field :name
      field :description do
        formatted_value do
          value.html_safe
        end
      end
      field :country
      field :levels
    end

  end

  config.model "Comment" do
    parent Product
    list do
      sort_by :updated_at
      field :id
      field :title
      field :updated_at
      field :customer
      field :product
    end
    edit do
      field :product do
        inline_add false
        inline_edit false
        read_only true
      end
      field :customer do
        inline_add false
        inline_edit false
        read_only true
      end
      field :title
      field :description do
        partial 'form_summernote'
      end
    end
  end

  config.model "Customer" do
    list do
      field :id
      field :first_name
      field :name
      field :email
      field :sign_in_count
      field :created_at
      field :postal_code
      field :locality
      field :country
      field :language
    end
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
      field :picture
      field :description do
        partial 'form_summernote'
      end
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
      field :name do
        required(true)
      end
      field :cycle
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
    show do
      field :name
      field :description do
        formatted_value do
          value.html_safe
        end
      end
      field :cycle
    end
  end

  config.model "Family" do
    parent Country
    list do
      sort_by :country_id
      field :id
      field :name
      field :country
      field :created_at
      field :updated_at
    end
    edit do
      field :country
      field :name
      field :description do
        partial 'form_summernote'
      end
      field :categories
    end
    show do
      field :name
      field :description do
        formatted_value do
          value.html_safe
        end
      end
      field :country
      field :categories
    end
  end

  config.model "Category" do
    parent Family
    list do
      sort_by :family_id
      field :id
      field :name
      field :family
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
    show do
      field :name
      field :description do
        formatted_value do
          value.html_safe
        end
      end
      field :family
    end

  end

  config.model "Order" do
    edit do
      field :customer do
        inline_add false
        inline_edit false
        read_only true
      end
      field :products do
        read_only true
      end
      field :status
      field :received_at do
        strftime_format "%Y-%m-%d"
      end
      field :accepted_at do
        strftime_format "%Y-%m-%d"
      end
      field :rejected_at do
        strftime_format "%Y-%m-%d"
      end
      field :rejecter do
        read_only true
      end
      field :amount_paid
      field :invoice_number
      field :payments do
        read_only true
      end
      field :order_items do
        read_only true
      end
    end
  end

  config.model "OrderItem" do
    parent Order
  end

  config.model "Product" do
    list do
      scopes [nil, :featured]
      sort_by :updated_at
      field :id
      field :name
      field :price
      field :active
      field :featured
      field :customer
      field :updated_at
    end
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

  config.model "Topic" do
    parent Country
    list do
      sort_by :country_id
      field :id
      field :name
      field :country
      field :created_at
      field :updated_at
    end
    edit do
      field :country
      field :name
      field :description do
        partial 'form_summernote'
      end
      field :articles
    end
  end

end
