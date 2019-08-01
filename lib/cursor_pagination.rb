module CursorPagination
end

if defined?(Rails::Railtie)
  require "cursor_pagination/railtie"
else
  raise "cursor_pagination is not available with your Rails version."
end
