# -*- encoding : utf-8 -*-
module Wob
  module Support
    module WatchDependencies
      def self.included(base)
        base.extend ClassMethods
      end

      # -- CLASS
      module ClassMethods
	def watch_for_dependencies(options = {})
          unless is_already_watching?
            cattr_accessor :check_dependencies
	    self.check_dependencies = options[:on]
          end
          include InstanceMethods
	end

        def is_already_watching?
          self.included_modules.include?(InstanceMethods)
        end
      end

      # -- INSTANCE
      module InstanceMethods #:nodoc:
        def self.included(base) # :nodoc:
          base.extend ClassMethods
        end

	def ensure_has_no_dependencies
	  result = true
	  return true if self.class.check_dependencies.nil?
	  self.class.check_dependencies.each do |assoc|
	    unless self.send(assoc).blank?
	      result = false
	      errors.add(:base, "one or more #{assoc.to_s} present, could not delete #{self.class.name.downcase}")
	    end
	  end
	  return result
	end
      end
    end
  end
end

ActiveRecord::Base.send :extend, Wob::Support::WatchDependencies::ClassMethods
