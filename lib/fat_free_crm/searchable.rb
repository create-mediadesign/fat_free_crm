# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
module FatFreeCRM
  module Searchable

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      # Options:
      #   :primary_field .. a proc, that returns a string representation to display in the result.
      def searchable(options = {})
        unless included_modules.include?(InstanceMethods)
          include Tire::Model::Search
          include Tire::Model::Callbacks
          
          include InstanceMethods
          extend SingletonMethods

          define_method :searchable_constraints do
            ((options[:constraints] || []) + [:searchable_shared_user_ids]).map do |constraint|
              self.send(constraint)
            end.flatten.delete_if(&:nil?).map(&:to_s)
          end

          yield if block_given?
          mapping do
            indexes :_constraints, :as => "searchable_constraints", :analyzer => 'keyword'
          end
        end
      end

      def searchable_reindex!
        self.tire.index.delete
        self.all.map {|e| e.tire.update_index}
      end
    end

    module InstanceMethods
      def searchable_shared_user_ids
        if self.respond_to?(:access)
          case access
          when "Public" then ["public"]
          when "Shared" then user_ids + group_ids.map {|g| Group.find(g).users.map(&:id) }.flatten
          else []
          end
        else
          []
        end
      end
    end

    module SingletonMethods
    end

  end # Searchable
end # FatFreeCRM

ActiveRecord::Base.send(:include, FatFreeCRM::Searchable)
