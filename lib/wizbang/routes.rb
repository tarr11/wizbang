module ActionDispatch::Routing
  class WizardStepProxy
    def initialize
      @steps = []
    end

    def steps
      @steps
    end

    def step(step_name)
      @steps << step_name
    end

  end

  class Wizard
    attr_reader :steps, :name, :resource_name
    def initialize(wizard_name, resource_name)
      @name = wizard_name
      @resource_name = resource_name
      @steps = []
    end

    def next_action(current_step, instance)
      # go through the steps
      # if a current_step is given, start there
      # if not, start at the beginning

      next_action = nil
      # if no block is given, just pick the next step

      index = steps.index(current_step)||0 

      return @steps.select_with_index{|s,i| i > index}.first

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
        self.match s.to_s, via: :get
        self.match s.to_s, via: :patch, to: "#{s.to_s}_update"
        wiz.steps << s
      end
      Wizbang.wizards[wizard_name] = wiz

    end 
  end


end
