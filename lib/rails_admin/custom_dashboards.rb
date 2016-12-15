# Custom actions for Rails Admin
# cf http://dmitrypol.github.io/2015/09/10/rails_admin.html

require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdmin
  module Config
    module Actions
      class StatsUsers < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)
        register_instance_option :root do
          true	#	this is for all records in all models
        end
        register_instance_option :pjax? do
          false
        end
        register_instance_option :visible? do
          authorized? 		# This ensures the action only shows up for the right class
        end
        register_instance_option :link_icon do
          'fa fa-plane' # use any of font-awesome icons
        end
      end
    end
  end
end
