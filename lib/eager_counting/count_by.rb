require 'active_support/concern'

module EagerCounting
  ##
  # This module contains the ::count_by method.
  # Include it to enable ::count_by on your model class
  module CountBy
    extend ActiveSupport::Concern

    module ClassMethods

      ##
      # Performs a count grouped by the given association.
      # This means it will return a hash mapping the ids of the associated objects
      # to the number of rows this class has for each of them.
      #
      # Example:
      #
      #   class Comment < ActiveRecord::Base
      #     include EagerCounting::CountBy
      #     belongs_to :author
      #     belongs_to :commentable, polymorphic: true
      #   end
      #
      #   Comment.count_by(:author) # => hash with author id mapped to number of comments this user made
      #
      # You can call this method on any relation object of the class you included it on
      #
      #   Comment.where(spam: false).count_by(:author) # => will only count non spam comments
      #
      # With the second argument you can also limit the scope of the association by which to count
      #
      #   Comment.count_by(:author, User.where(admin: false)) # => only count comments by non admin users
      #
      # By passing an hash as the association you can count by joined associations
      #
      #   Comment.count_by(author: { city: :country }) # => count comments by the country their from
      #
      # You can also use it on polymoprhic associations.
      # For that the second parameter is necessary to select the type of things to count by.
      #
      #   Comment.count_by(:commentable, Picture.all) # => how many comments does each picture have?
      #
      def count_by(association_target, scope = nil)
        association = deepest_value(association_target).to_s
        scope ||= association.camelize.constantize.all
        join = without_deepest_value(association_target)
        target_model = self

        if association_target.is_a? Hash
          target_model = deepest_value(join).to_s.singularize.camelize.constantize
        end

        query = joins(join)
          .merge(target_model.where(association => scope))
          .group(association_column_name(target_model, association))
          .count

        Hash.new(0).merge query
      end

      private

      def association_column_name(klass, association)
        "#{klass.table_name}.#{klass.reflections[association].foreign_key}"
      end

      def without_deepest_value(map)
        return {} unless map.is_a? Hash
        key, value = map.to_a.first
        if value.is_a? Hash
          { key => without_deepest_value(value) }
        else
          key
        end
      end

      def deepest_value(value)
        if value.is_a? Hash
          deepest_value(value.values.first)
        else
          value
        end
      end
    end
  end
end
