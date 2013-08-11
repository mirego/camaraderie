require 'spec_helper'

describe Camaraderie::Membership do
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

  describe :Scopes do
    let(:user1) { User.create }
    let(:user2) { User.create }

    let(:organization1) { Organization.create }
    let(:organization2) { Organization.create }

    before do
      Membership.create(user: user1, organization: organization1, membership_type: 'admin')
      Membership.create(user: user2, organization: organization2, membership_type: 'admin')
      Membership.create(user: user1, organization: organization2, membership_type: 'member')
    end

    describe :admins do
      subject { Membership.admins }

      it { should be_an_instance_of(relation_class(Membership)) }
      it { should have(2).items }
    end

    describe :members do
      subject { Membership.members }

      it { should be_an_instance_of(relation_class(Membership)) }
      it { should have(1).item }
    end
  end

  describe :Validations do
    let(:membership) { Membership.create(attributes) }
    subject { membership }

    context 'with missing user' do
      let(:attributes) { { organization: Organization.create, membership_type: 'admin' } }
      it { should_not be_valid }

      describe :errors do
        subject { membership.errors }
        it { should have(1).item }
        its(:full_messages) { should include "User can't be blank" }
      end
    end

    context 'with missing organization' do
      let(:attributes) { { user: User.create, membership_type: 'admin' } }
      it { should_not be_valid }

      describe :errors do
        subject { membership.errors }
        it { should have(1).item }
        its(:full_messages) { should include "Organization can't be blank" }
      end
    end

    context 'with missing membership type' do
      let(:attributes) { { user: User.create, organization: Organization.create } }
      it { should_not be_valid }

      describe :errors do
        subject { membership.errors }
        it { should have(2).item }
        its(:full_messages) { should include "Membership type can't be blank" }
        its(:full_messages) { should include "Membership type is not included in the list" }
      end
    end

    context 'with wrong membership type' do
      let(:attributes) { { membership_type: 'super_admin', user: User.create, organization: Organization.create } }
      it { should_not be_valid }

      describe :errors do
        subject { membership.errors }
        it { should have(1).item }
        its(:full_messages) { should include "Membership type is not included in the list" }
      end
    end
  end
end
