require 'spec_helper'

describe Camaraderie do
  describe 'Custom model classes' do
    before do
      Camaraderie.configure do |config|
        config.organization_class = 'Company'
        config.user_class = 'Employee'
        config.membership_types = %w(admin member)
      end

      spawn_organization_model 'Company'
      spawn_user_model 'Employee'
      spawn_membership_model

      run_migration do
        create_table(:employees, force: true)
        create_table(:companies, force: true)
      end
    end

    let(:user) { Employee.create }
    let(:organization) { Company.create }

    before do
      # FIXME Why doesn't this work?
      # It bypasses `class_name: 'Employee'` and tries to use 'User'
      #
      # organization.admins.create(user: user)

      # We'll have to use this for now
      Membership.create(membership_type: 'admin', user: user, organization: organization)
    end

    it { expect(user).to be_admin_of(organization) }
    it { expect(organization.admin_users).to include(user) }
  end
end
