module CursorPagination
end

if defined?(Rails::Railtie)
  require "cursor-paginate/railtie"
else
  raise "cursor-paginate is not available with your Rails version."
end
