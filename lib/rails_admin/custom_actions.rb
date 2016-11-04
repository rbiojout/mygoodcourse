# Custom actions for Rails Admin
# cf http://dmitrypol.github.io/2015/09/10/rails_admin.html

require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'


module RailsAdmin
  module Config
    module Actions
      # common config for custom actions
      class Customaction < RailsAdmin::Config::Actions::Base
        register_instance_option :member do  #	this is for specific record
          true
        end
        register_instance_option :pjax? do
          false
        end
        register_instance_option :visible? do
          authorized? 		# This ensures the action only shows up for the right class
        end
      end
      class Foo < Customaction
        RailsAdmin::Config::Actions.register(self)
        register_instance_option :only do
          # model name here
        end
        register_instance_option :link_icon do
          'fa fa-paper-plane' # use any of font-awesome icons
        end
        register_instance_option :http_methods do
          [:get, :post]
        end
        register_instance_option :controller do
          Proc.new do
            # call model.method here
            flash[:notice] = "Did custom action on #{@object.name}"
            redirect_to back_or_index
          end
        end
      end

      # order the childs for Country
      class SortForCountry < Customaction
        RailsAdmin::Config::Actions.register(self)
        register_instance_option :only do
          Country
        end
        register_instance_option :link_icon do
          'fa fa-sort' # use any of font-awesome icons
        end
        register_instance_option :http_methods do
          [:get, :post]
        end
        # By default, Rails Admin will render a view with the same name as our action
        # else we can define a controller
      end
      # order the childs for Cycle
      class SortForCycle < Customaction
        RailsAdmin::Config::Actions.register(self)
        register_instance_option :only do
          Cycle
        end
        register_instance_option :link_icon do
          'fa fa-sort' # use any of font-awesome icons
        end
        register_instance_option :http_methods do
          [:get, :post]
        end
        # By default, Rails Admin will render a view with the same name as our action
        # else we can define a controller
      end
      # order the childs for Family
      class SortForFamily < Customaction
        RailsAdmin::Config::Actions.register(self)
        register_instance_option :only do
          Family
        end
        register_instance_option :link_icon do
          'fa fa-sort' # use any of font-awesome icons
        end
        register_instance_option :http_methods do
          [:get, :post]
        end
        # By default, Rails Admin will render a view with the same name as our action
        # else we can define a controller
      end
      # order the childs for Topic
      class SortForTopic < Customaction
        RailsAdmin::Config::Actions.register(self)
        register_instance_option :only do
          Topic
        end
        register_instance_option :link_icon do
          'fa fa-sort' # use any of font-awesome icons
        end
        register_instance_option :http_methods do
          [:get, :post]
        end
        # By default, Rails Admin will render a view with the same name as our action
        # else we can define a controller
      end

      # order the childs for ForumFamily
      class SortForForumFamily < Customaction
        RailsAdmin::Config::Actions.register(self)
        register_instance_option :only do
          ForumFamily
        end
        register_instance_option :link_icon do
          'fa fa-sort' # use any of font-awesome icons
        end
        register_instance_option :http_methods do
          [:get, :post]
        end
        # By default, Rails Admin will render a view with the same name as our action
        # else we can define a controller
      end

      class Collection < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)
        register_instance_option :collection do
          true	#	this is for all records in specific model
        end
      end

      class Root < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)
        register_instance_option :root do
          true	#	this is for all records in all models
        end
      end


    end
  end
end