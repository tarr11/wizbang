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
    attr_reader :steps, :name
    def initialize(wizard_name)
      @name = wizard_name
      @steps = []
    end

    def steps
      @steps
    end

  end

  class Mapper
    def wizard(wizard_name, &block)
      proxy = WizardStepProxy.new
      if block_given?
        proxy.instance_eval(&block)
      end

      wiz = Wizard.new(wizard_name)

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
