$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "cursor_pagination/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "cursor_pagination"
  spec.version     = CursorPagination::VERSION
  spec.authors     = ["otoyo"]
  spec.email       = ["hiroki.t.1988@gmail.com"]
  spec.homepage    = "https://github.com/otoyo/cursor_pagination"
  spec.summary     = "Cursor based pagination library for Rails."
  spec.description = "cursor_pagination is a cursor based pagination library for Ruby on Rails."
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 5.2.3"

  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "rspec-rails"
end
