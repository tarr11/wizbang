module Wizbang
  module ActsAsWizbang
    extend ActiveSupport::Concern

    included do

    end
    # controller extension

    module ClassMethods
      def acts_as_wizbang(options = {})
        # add a before

      end
    end

  end

end

ActionController::Base.send :include, Wizbang::ActsAsWizbang
