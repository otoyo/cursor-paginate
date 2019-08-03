module CursorPagination
  class Railtie < ::Rails::Railtie
    initializer "cursor-paginate" do |app|
      ActiveSupport.on_load :active_record do
        require "cursor-paginate/active_record"
      end
    end
  end
end
