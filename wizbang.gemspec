$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "wizbang/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "wizbang"
  s.version     = Wizbang::VERSION
  s.authors     = ["Douglas Tarr"]
  s.email       = ["douglas.tarr@gmail.com"]
  s.homepage    = "https://githumb.com/tarr11/wizbang"
  s.summary     = "DSL for Rails Wizard"
  s.description = "Clean up your wizard code by using an integrated DSL with your routes and controllers"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4"

  s.add_development_dependency "sqlite3"
end
