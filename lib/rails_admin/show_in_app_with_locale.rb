module RailsAdmin
  module Config
    module Actions
      class ShowInAppWithLocale < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)


        register_instance_option :member do
          true
        end

        register_instance_option :visible? do
          calculated_path = "/#{bindings[:object].class.name.underscore}s"
          authorized? && (bindings[:controller].main_app.url_for(controller: calculated_path,
                                                                 action: 'show',
                                                                 id: bindings[:object].id,
                                                                 locale: I18n.locale) rescue false)
        end

        register_instance_option :controller do
          proc do
            calculated_path = "/#{@object.class.name.underscore}s"
            redirect_to main_app.url_for(controller: calculated_path,
                                         action: 'show',
                                         id: @object.id,
                                         locale: I18n.locale)
          end
        end

        register_instance_option :link_icon do
          'icon-eye-open'
        end

        register_instance_option :pjax? do
          false
        end
      end
    end
  end
end
