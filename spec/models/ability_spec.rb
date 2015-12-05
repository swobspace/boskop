require 'rails_helper'
require "cancan/matchers"

RSpec.describe "User", :type => :model do
  fixtures 'wobauth/roles'

  subject(:ability) { Ability.new(user) }

  context "not logged in" do
    let(:user) { nil }

    # -- readable, ...
    [ Location, OrgUnit ].each do |model|
      it { is_expected.to be_able_to(:read, model.new) }
    end

    # -- but not writeable
    [ Location, OrgUnit ].each do |model|
      it { is_expected.not_to be_able_to(:create, model.new) }
      it { is_expected.not_to be_able_to(:update, model.new) }
      it { is_expected.not_to be_able_to(:destroy, model.new) }
      it { is_expected.not_to be_able_to(:manage, model.new) }
    end

    # -- nor readable, not writeable
    [ Network, Merkmal, Merkmalklasse, Address, LineState, AccessType,
      FrameworkContract, Line, Ipaddress, Host, OperatingSystem ].each do |model|
      it { is_expected.not_to be_able_to(:read, model.new) }
      it { is_expected.not_to be_able_to(:create, model.new) }
      it { is_expected.not_to be_able_to(:update, model.new) }
      it { is_expected.not_to be_able_to(:destroy, model.new) }
      it { is_expected.not_to be_able_to(:manage, model.new) }
    end

  end

  context "logged in without any role" do
    let(:user) { FactoryGirl.create(:user) }

    # -- readable, ...
    [ Location, OrgUnit, Network ].each do |model|
      it { is_expected.to be_able_to(:read, model.new) }
    end

    # -- but not writeable
    [ Location, OrgUnit, Network ].each do |model|
      it { is_expected.not_to be_able_to(:create, model.new) }
      it { is_expected.not_to be_able_to(:update, model.new) }
      it { is_expected.not_to be_able_to(:destroy, model.new) }
      it { is_expected.not_to be_able_to(:manage, model.new) }
    end

    # -- nor readable, not writeable
    [ Merkmal, Merkmalklasse, Address, LineState, AccessType,
      FrameworkContract, Line, Ipaddress, Host, OperatingSystem ].each do |model|
      it { is_expected.not_to be_able_to(:read, model.new) }
      it { is_expected.not_to be_able_to(:create, model.new) }
      it { is_expected.not_to be_able_to(:update, model.new) }
      it { is_expected.not_to be_able_to(:destroy, model.new) }
      it { is_expected.not_to be_able_to(:manage, model.new) }
    end
  end

  context "with role Reader" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:authority) { 
      FactoryGirl.create(:authority, 
	authorizable: user, 
	role: wobauth_roles(:reader))
    }
    # -- readable, ...
    [ Network, Line, Ipaddress, Host, 
      Merkmal, Merkmalklasse, Address, LineState, AccessType,
      Location, OrgUnit, FrameworkContract, OperatingSystem ].each do |model|
      it { is_expected.to be_able_to(:read, model.new) }
    end

    # -- ... but not writeable
    [ Network, Line, Ipaddress, Host, 
      Merkmal, Merkmalklasse, Address, LineState, AccessType,
      Location, OrgUnit, FrameworkContract, OperatingSystem ].each do |model|
      it { is_expected.not_to be_able_to(:create, model.new) }
      it { is_expected.not_to be_able_to(:update, model.new) }
      it { is_expected.not_to be_able_to(:destroy, model.new) }
      it { is_expected.not_to be_able_to(:manage, model.new) }
    end
  end

  context "with role NetworkManager" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:authority) { 
      FactoryGirl.create(:authority, 
	authorizable: user, 
	role: wobauth_roles(:network_manager))
    }
    # -- readable, ...
    [ Network, Line, Ipaddress, Host, 
      Merkmal, Merkmalklasse, Address, LineState, AccessType,
      Location, OrgUnit, FrameworkContract, OperatingSystem ].each do |model|
      it { is_expected.to be_able_to(:read, model.new) }
    end

    # -- writeable
    [ Network, Line, Ipaddress, Host ].each do |model|
      it { is_expected.to be_able_to(:create, model.new) }
      it { is_expected.to be_able_to(:update, model.new) }
      it { is_expected.to be_able_to(:destroy, model.new) }
      it { is_expected.to be_able_to(:manage, model.new) }
    end

    # -- not writeable
    [ Merkmal, Merkmalklasse, Address, LineState, AccessType,
      Location, OrgUnit, FrameworkContract, OperatingSystem ].each do |model|
      it { is_expected.not_to be_able_to(:create, model.new) }
      it { is_expected.not_to be_able_to(:update, model.new) }
      it { is_expected.not_to be_able_to(:destroy, model.new) }
      it { is_expected.not_to be_able_to(:manage, model.new) }
    end
  end

  context "with role Admin" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:authority) { 
      FactoryGirl.create(:authority, 
	authorizable: user, 
	role: wobauth_roles(:admin))
      }
    [ Network, Line, Ipaddress, Host, 
      Merkmal, Merkmalklasse, Address, LineState, AccessType,
      Location, OrgUnit, FrameworkContract, OperatingSystem ].each do |model|
      it { is_expected.to be_able_to(:manage, model.new) }
    end
  end
end
