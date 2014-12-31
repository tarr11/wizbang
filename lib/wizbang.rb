module Wizbang

  @wizards = {}

  def self.wizards
    @wizards
  end
end
require 'wizbang/routes'
require 'wizbang/acts_as_wizbang'

