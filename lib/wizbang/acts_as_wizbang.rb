module Wizbang
  module ActsAsWizbang
    extend ActiveSupport::Concern
    attr_accessor :wizbang_wizard

    included do
      around_action :find_next_step

      def find_next_step
        yield

        wizbang_step = wizbang_steps.select{|s| s[:step] == action_name.to_sym}.first
        if wizbang_step && request.method != :get
            # redirect to the next step
          redirect_to wizbang_wizard.next_step_path wizbang_step, attributes[wizbang_wizard.resource_name]
        end
      end

      def wizbang_wizard
        self.class.wizbang_wizard
      end

      def wizbang_steps
        self.class.wizbang_wizard.steps
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
