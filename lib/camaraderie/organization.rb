module Camaraderie
  module Organization
    extend ActiveSupport::Concern

    included do
      # Associations
      has_many :memberships, dependent: :destroy
      has_many :users, through: :memberships, class_name: Camaraderie.user_class

      # Define a method for each type of membership
      #
      # @example
      #   user = User.new(email: 'foo@example.com')
      #   Organization.first.admins.create(user: user)
      Camaraderie.membership_types.each do |type|
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{type.pluralize}
            memberships.#{type.pluralize}
          end
        RUBY
      end
    end
  end
end
