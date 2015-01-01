module ActionDispatch::Routing
  class WizardStepProxy
    def initialize
      @steps = []
    end

    def steps
      @steps
    end

    def step(action, options = {})
      new_step = {
        action: action
      }

      if options[:create]
        new_step[:create] = true
      end

      @steps << new_step
    end

  end

  class WizardStep
    attr_accessor :action
    attr_accessor :update_action

    def initialize(action, update_action)
      self.action = action
      self.update_action = update_action
    end

  end

  class Wizard
    attr_reader :steps, :name, :resource_name
    def initialize(wizard_name, resource_name)
      @name = wizard_name
      @resource_name = resource_name
      @steps = []
    end

    def next_action(current_action, instance)
      # go through the steps
      # if a current_step is given, start there
      # if not, start at the beginning

      next_action = nil
      # if no block is given, just pick the next step

      step = @steps.select{|s|s.action == current_action || s.update_action == current_action}.first

      index = 0
      if step
        index = @steps.index(step) + 1
      end
      return @steps.drop(index).first
      # if a block is given, evaluate that until it returns true

    end

  end

  class Mapper
    def wizard(wizard_name, resource_name, &block)
      proxy = WizardStepProxy.new
      if block_given?
        proxy.instance_eval(&block)
      end

      wiz = Wizard.new(wizard_name, resource_name)

      proxy.steps.each do |s|
        # create the routes for each step
        if s[:create]
          update_action  = "#{s[:action].to_s}_create"
          self.collection do
            get s[:action].to_s
            post s[:action].to_s, action: update_action
          end
        else
          update_action  = "#{s[:action].to_s}_update"
          self.member do 
            get s[:action].to_s
            patch s[:action].to_s, action: update_action
          end
        end
        wiz.steps << WizardStep.new(s[:action].to_s, update_action)
      end
      Wizbang.wizards[wizard_name] = wiz

    end 
  end


end
