module CursorPagination
  class Railtie < ::Rails::Railtie
    initializer "cursor_pagination" do |app|
      ActiveSupport.on_load :active_record do
        require "cursor_pagination/active_record"
      end
    end
  end
end
