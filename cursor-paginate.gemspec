$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "cursor-paginate/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "cursor-paginate"
  spec.version     = CursorPagination::VERSION
  spec.authors     = ["otoyo"]
  spec.email       = ["hiroki.t.1988@gmail.com"]
  spec.homepage    = "https://github.com/otoyo/cursor-paginate"
  spec.summary     = "Cursor based pagination library for Rails."
  spec.description = "cursor-paginate is a cursor based pagination library for Ruby on Rails."
  spec.license     = "MIT"

  spec.files = Dir["{lib,spec}/**/*", "MIT-LICENSE", "README.md"]

  spec.add_dependency "rails", ">= 5.2.3"

  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "rspec-rails"
end
