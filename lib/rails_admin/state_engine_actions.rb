module RailsAdmin
  module Config
    module Actions
      # common config for custom actions
      class StateEngineActions < RailsAdmin::Config::Actions::Base
        register_instance_option :member do
          true
        end
        # disable double call
        register_instance_option :pjax? do
          false
        end
        register_instance_option :only do
          Abuse
        end
        register_instance_option :visible? do
          authorized? # combine with Devise/CanCanCan or alternative auth tools
        end
        register_instance_option :controller do
          object = bindings[:object]
        end
      end

      class ReceiveAbuse < StateEngineActions
        RailsAdmin::Config::Actions.register(self)
        register_instance_option :only do
          Abuse
        end
        register_instance_option :visible? do
          begin
            bindings[:object].may_receive?
          rescue
            false
          end
        end
        register_instance_option :link_icon do
          'fa fa-flag'
        end
        register_instance_option :controller do
          Proc.new do
            object.receive!
            flash[:notice] = "Received #{@object.id}"
            redirect_to show_path
          end
        end
      end
      class AcceptAbuse < StateEngineActions
        RailsAdmin::Config::Actions.register(self)
        register_instance_option :only do
          Abuse
        end
        register_instance_option :visible? do
          begin
            bindings[:object].may_accept?
          rescue
            false
          end
        end
        register_instance_option :link_icon do
          'fa fa-thumbs-up'
        end
        register_instance_option :controller do
          Proc.new do
            object.accept!
            flash[:notice] = "Accepted #{@object.id}"
            redirect_to show_path
          end
        end
      end
      class RejectAbuse < StateEngineActions
        register_instance_option :only do
          Abuse
        end
        RailsAdmin::Config::Actions.register(self)
        register_instance_option :visible? do
          begin
            bindings[:object].may_reject?
          rescue
            false
          end
        end
        register_instance_option :link_icon do
          'fa fa-thumbs-down'
        end
        register_instance_option :controller do
          Proc.new do
            object.reject!
            flash[:notice] = "Rejected #{@object.id}"
            redirect_to show_path
          end
        end
      end
      class CancelAbuse < StateEngineActions
        register_instance_option :only do
          Abuse
        end
        RailsAdmin::Config::Actions.register(self)
        register_instance_option :visible? do
          begin
            bindings[:object].may_cancel?
          rescue
            false
          end
        end
        register_instance_option :link_icon do
          'fa fa-undo'
        end
        register_instance_option :controller do
          Proc.new do
            object.cancel!
            flash[:notice] = "Canceled #{@object.id}"
            redirect_to show_path
          end
        end
      end
    end

  end
end