require "active_record"

module CursorPagination
  module ActiveRecord
    module RelationMethods
      attr_accessor :cursor_key

      def before(options)
        options = HashWithIndifferentAccess.new(options)

        rel = if ::ActiveRecord::Relation === self
                self
              else
                all
              end

        rel.cursor_key = rel.model.columns.map(&:name).find { |column| options.key? column }
        raise unless rel.cursor_key

        cursor = options[rel.cursor_key]

        rel.where(cursor ? arel_table[rel.cursor_key].lteq(cursor) : nil).reorder(arel_table[rel.cursor_key].desc)
      end

      def after(options)
        options = HashWithIndifferentAccess.new(options)

        rel = if ::ActiveRecord::Relation === self
                self
              else
                all
              end

        rel.cursor_key = rel.model.columns.map(&:name).find { |column| options.key? column }
        raise unless rel.cursor_key

        cursor = options[rel.cursor_key]

        rel.where(cursor ? arel_table[rel.cursor_key].gteq(cursor) : nil).reorder(arel_table[rel.cursor_key].asc)
      end

      def has_next?
        set_next if @has_next.nil?
        @has_next
      end

      def next_cursor
        set_next if @has_next.nil?
        @next_cursor
      end

      # Override ActiveRecord::Relation#load
      def load
        return super unless cursor_key

        rel = super
        rel.set_next
        rel
      end

      protected

      def set_cursor_key(options)
        options = HashWithIndifferentAccess.new(options)

        rel = if ::ActiveRecord::Relation === self
                self
              else
                all
              end

        rel.cursor_key = rel.model.columns.map(&:name).find { |column| options.key? column }
        raise unless rel.cursor_key

        rel
      end

      def set_next
        rel = self
        raise if rel.limit_value.nil?

        excess = rel.dup.tap { |r| r.limit_value = r.limit_value + 1 }

        if excess.size > rel.size
          @has_next = true
          @next_cursor = excess.last[cursor_key]
        else
          @has_next = false
          @next_cursor = nil
        end
      end

      ::ActiveRecord::Base.extend RelationMethods

      klasses = [::ActiveRecord::Relation]
      if defined? ::ActiveRecord::Associations::CollectionProxy
        klasses << ::ActiveRecord::Associations::CollectionProxy
      else
        klasses << ::ActiveRecord::Associations::AssociationCollection
      end

      # # support pagination on associations and scopes
      klasses.each do |klass|
        klass.send(:include, RelationMethods)
      end
    end
  end
end
