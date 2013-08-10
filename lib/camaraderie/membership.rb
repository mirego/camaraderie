module Camaraderie
  module Membership
    extend ActiveSupport::Concern
    included do
      # Associations
      belongs_to :user, validate: true, class_name: Camaraderie.user_class
      belongs_to :organization, class_name: Camaraderie.organization_class

      # Validations
      validates :user, presence: true
      validates :organization, presence: true
      validates :membership_type, presence: true, inclusion: { in: Camaraderie.membership_types }, uniqueness: { scope: [:user_id, :organization_id] }

      # Scopes
      Camaraderie.membership_types.each do |type|
        scope type.pluralize, lambda { where(membership_type: type) }
      end

      # Nested attributes
      accepts_nested_attributes_for :user
      accepts_nested_attributes_for :organization
    end
  end
end
