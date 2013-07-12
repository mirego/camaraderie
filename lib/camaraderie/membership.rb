module Camaraderie
  module Membership
    extend ActiveSupport::Concern
    included do
      # Associations
      belongs_to :user, validate: true
      belongs_to :organization

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
