module Camaraderie
  module User
    extend ActiveSupport::Concern

    included do
      # Associations
      has_many :memberships, dependent: :destroy
      has_many :organizations, through: :memberships, class_name: Camaraderie.organization_class

      Camaraderie.membership_types.each do |type|
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{type}_of?(organization)
            !!memberships.#{type.pluralize}.where(organization: organization).exists?
          end
        RUBY
      end
    end
  end
end
