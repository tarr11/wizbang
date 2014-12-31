require 'wizbang/routes'
require 'wizbang/acts_as_wizbang'
module Wizbang
  @wizards = {}
  def self.wizards
    @wizards
  end

end
