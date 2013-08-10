require 'spec_helper'

describe Camaraderie::Organization do
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

  describe :ClassMethods do
    let(:organization) { Organization.create }
    let(:user1) { User.create }
    let(:user2) { User.create }
    let(:user3) { User.create }

    before do
      organization.admins.create(user: user1)
      organization.members.create(user: user2)
      organization.members.create(user: user3)
    end

    describe :admins do
      subject { organization.admins }
      it { should be_an_instance_of(relation_class(Membership)) }
      it { should have(1).item }
    end

    describe :members do
      subject { organization.members }
      it { should be_an_instance_of(relation_class(Membership)) }
      it { should have(2).items }
    end

    describe :admin_users do
      subject { organization.admin_users }
      it { should be_an_instance_of(relation_class(User)) }
      it { should have(1).item }
      it { should include user1 }
    end

    describe :member_users do
      subject { organization.member_users }
      it { should be_an_instance_of(relation_class(User)) }
      it { should have(2).items }
      it { should include user2, user3 }
    end
  end

  describe :Associations do
    let(:organization) { Organization.create }
    let(:user1) { User.create }
    let(:user2) { User.create }
    let(:user3) { User.create }

    before do
      organization.admins.create(user: user1)
      organization.members.create(user: user2)
      organization.members.create(user: user3)
    end

    describe :users do
      subject { organization.users }
      it { should have(3).items }

      describe :DestroyDependent do
        specify do
          expect { organization.destroy }.to change { Membership.count }.from(3).to(0)
        end
      end
    end
  end
end
