module Wizbang
  module ActsAsWizbang
    extend ActiveSupport::Concern
    attr_accessor :wizbang_wizard

    included do


      def wizbang_wizard
        self.class.wizbang_wizard
      end

      def wizbang_steps
        self.class.wizbang_wizard.steps
      end

      def redirect_to_next_action
        res = self.instance_variable_get("@#{wizbang_wizard.resource_name}")

        next_action = wizbang_wizard.next_action(action_name, res)

        if next_action
          redirect_to action: next_action.action, id: res.id
        else
          redirect_to res
        end

      end

    end
    # controller extension

    module ClassMethods

      def acts_as_wizbang(options = {})
        # add a before
        cattr_accessor :wizbang_wizard
        
        self.wizbang_wizard = Wizbang.wizards[options[:wizard_name]]
        raise "can't find wizard #{@wizard_name}" unless self.wizbang_wizard

      end
      

    end
  

  end

end

ActionController::Base.send :include, Wizbang::ActsAsWizbang
