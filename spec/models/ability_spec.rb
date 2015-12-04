require 'rails_helper'
require "cancan/matchers"

RSpec.describe "User", :type => :model do
  fixtures 'wobauth/roles'

  subject(:ability) { Ability.new(user) }

  context "not logged in" do
    let(:user) { nil }

    it { is_expected.to be_able_to(:read, OrgUnit.new) }
    it { is_expected.to be_able_to(:read, Location.new) }

    [ Network, Merkmal, Merkmalklasse, Address, LineState, AccessType,
      FrameworkContract, Line, Ipaddress, Host, OperatingSystem ].each do |model|
      it { is_expected.not_to be_able_to(:read, model.new) }
    end

  end

  context "logged in without any role" do
    let(:user) { FactoryGirl.create(:user) }

    [ Location, OrgUnit, Network ].each do |model|
      it { is_expected.to be_able_to(:read, model.new) }
    end

    [ Location, OrgUnit, Network ].each do |model|
      it { is_expected.not_to be_able_to(:create, model.new) }
      it { is_expected.not_to be_able_to(:update, model.new) }
      it { is_expected.not_to be_able_to(:destroy, model.new) }
      it { is_expected.not_to be_able_to(:manage, model.new) }
    end

    [ Merkmal, Merkmalklasse, Address, LineState, AccessType,
      FrameworkContract, Line, Ipaddress, Host, OperatingSystem ].each do |model|
      it { is_expected.not_to be_able_to(:read, model.new) }
    end

  end

  context "with role NetworkManager" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:authority) { 
      FactoryGirl.create(:authority, 
	authorizable: user, 
	role: wobauth_roles(:network_manager))
      }

  end

  context "with role Admin" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:authority) { 
      FactoryGirl.create(:authority, 
	authorizable: user, 
	role: wobauth_roles(:admin))
      }

    it { is_expected.to be_able_to(:manage, OrgUnit.new) }

  end
end
