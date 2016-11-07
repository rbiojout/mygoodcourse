# cf http://dmitrypol.github.io/2016/01/01/rails-admin-state-machine.html
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
          [Abuse, Post]
        end
        register_instance_option :visible? do
          authorized? # combine with Devise/CanCanCan or alternative auth tools
        end
      end

      class ReceiveState < StateEngineActions
        RailsAdmin::Config::Actions.register(self)
        register_instance_option :visible? do
          begin
                ((bindings[:object].is_a? Post) || (bindings[:object].is_a? Abuse)) &&
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
            @object.receive
            @object.save!
            flash[:notice] = "Received #{@object.id}"
            redirect_to show_path
          end
        end
      end
      class AcceptState < StateEngineActions
        RailsAdmin::Config::Actions.register(self)
        register_instance_option :visible? do
          begin
                ((bindings[:object].is_a? Post) || (bindings[:object].is_a? Abuse)) &&
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
            @object.accept
            @object.save
            flash[:notice] = "Accepted #{@object.id}"
            redirect_to show_path
          end
        end
      end
      class RejectState < StateEngineActions
        RailsAdmin::Config::Actions.register(self)
        register_instance_option :visible? do
          begin
                ((bindings[:object].is_a? Post) || (bindings[:object].is_a? Abuse)) &&
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
            @object.reject
            @object.save
            flash[:notice] = "Rejected #{@object.id}"
            redirect_to show_path
          end
        end
      end
      class CancelState < StateEngineActions

        RailsAdmin::Config::Actions.register(self)
        register_instance_option :visible? do
          begin
                ((bindings[:object].is_a? Post) || (bindings[:object].is_a? Abuse)) &&
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
            @object.cancel
            @object.save
            flash[:notice] = "Canceled #{@object.id}"
            redirect_to show_path
          end
        end
      end


    end
  end
end