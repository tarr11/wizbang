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
        resource_instances = []
        params = []
        wizbang_wizard.resources.each do |r|
          res = self.instance_variable_get("@#{r}")
          if res
            resource_instances << res
            params << {:key => "#{r}_id", :value => res.id}
          end
        end

        next_action = wizbang_wizard.next_action(action_name, *resource_instances)
        next_url = "/#{wizbang_wizard.name}/#{next_action.action}"
        if params.length > 0
          next_url += "?"
          params.each_with_index do |p,index|
            if index > 0
              next_url += "&"
            end
            next_url += "#{p[:key]}=#{p[:value]}"
          end
        end

        if next_action
          redirect_to next_url
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

        wizard_name = options[:wizard]
        self.wizbang_wizard = Wizbang.wizards[options[:wizard]]
        raise "can't find wizard #{@wizard_name}" unless self.wizbang_wizard

      end
      

    end

  end

end

ActionController::Base.send :include, Wizbang::ActsAsWizbang
