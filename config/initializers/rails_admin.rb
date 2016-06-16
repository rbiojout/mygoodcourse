RailsAdmin.config do |config|

  config.main_app_name = ["ForMyCourse", "BackOffice"]

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
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.model "Cycle" do
    edit do
      field :description do
        partial 'form_summernote'
      end
    end
  end

  # make sure that we have all models loaded
  Rails.application.eager_load!

  ActiveRecord::Base.descendants.each do |imodel|
    config.model "#{imodel.name}" do
      edit do
        field :description do
          partial 'form_summernote'
        end
      end
    end
  end

end
