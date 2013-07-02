require "macedoine/version"

require "macedoine/user"
require "macedoine/organization"
require "macedoine/membership"

module Macedoine
  # Yield a block to edit the @configuration variable
  def self.configure
    @configuration = OpenStruct.new
    yield(@configuration)
  end

  # Return the allowed membership types
  def self.membership_types
    @configuration.membership_types
  end

  # Return a block that can be injected into a class
  def self.inject_into_active_record
    @inject_into_active_record ||= Proc.new do
      def self.acts_as_user
        self.send :include, Macedoine::User
      end

      def self.acts_as_organization
        self.send :include, Macedoine::Organization
      end

      def self.acts_as_membership
        self.send :include, Macedoine::Membership
      end
    end
  end
end

require 'macedoine/railtie' if defined?(Rails) && Rails::VERSION::MAJOR >= 3
