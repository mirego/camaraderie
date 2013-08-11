require 'spec_helper'

describe Camaraderie::User do
  before do
    Camaraderie.configure { |config| config.membership_types = %w(admin member) }
    spawn_membership_model
    spawn_organization_model
    spawn_user_model

    run_migration do
      create_table(:users, force: true)
      create_table(:organizations, force: true)
    end
  end

  describe :InstanceMethods do
    subject do
      User.create.tap do |user|
        organization1.admins.create(user: user)
        organization2.members.create(user: user)
      end
    end

    let(:organization1) { Organization.create }
    let(:organization2) { Organization.create }
    let(:organization3) { Organization.create }

    describe :admin_of? do
      it{ should be_admin_of(organization1) }
      it{ should_not be_admin_of(organization2) }
      it{ should_not be_admin_of(organization3) }
    end

    describe :member_of? do
      it{ should be_member_of(organization2) }
      it{ should_not be_member_of(organization1) }
      it{ should_not be_member_of(organization3) }
    end
  end

  describe :Associations do
    subject { user }
    let(:user) { User.create }

    before do
      Organization.create.admins.create(user: user)
      Organization.create.members.create(user: user)
    end

    describe :organizations do
      its(:organizations) { should have(2).items }

      describe :DestroyDependent do
        specify do
          expect { user.destroy }.to change { Membership.count }.from(2).to(0)
        end
      end
    end
  end
end
