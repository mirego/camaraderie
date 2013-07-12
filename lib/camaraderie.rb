require 'camaraderie/version'

require 'camaraderie/user'
require 'camaraderie/organization'
require 'camaraderie/membership'

module Camaraderie
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
        self.send :include, Camaraderie::User
      end

      def self.acts_as_organization
        self.send :include, Camaraderie::Organization
      end

      def self.acts_as_membership
        self.send :include, Camaraderie::Membership
      end
    end
  end
end

require 'camaraderie/railtie' if defined?(Rails) && Rails::VERSION::MAJOR >= 3
