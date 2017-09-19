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
      FrameworkContract, Line, Host, HostCategory,
      OperatingSystem, OperatingSystemMapping ].each do |model|
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
      FrameworkContract, Line, Host, HostCategory,
      OperatingSystem, OperatingSystemMapping ].each do |model|
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
    [ Network, Line, Host, HostCategory,
      Merkmal, Merkmalklasse, Address, LineState, AccessType,
      Location, OrgUnit, FrameworkContract,
      OperatingSystem, OperatingSystemMapping ].each do |model|
      it { is_expected.to be_able_to(:read, model.new) }
    end

    # -- ... but not writeable
    [ Network, Line, Host, HostCategory,
      Merkmal, Merkmalklasse, Address, LineState, AccessType,
      Location, OrgUnit, FrameworkContract,
      OperatingSystem, OperatingSystemMapping ].each do |model|
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
    [ Network, Line, Host, HostCategory,
      Merkmal, Merkmalklasse, Address, LineState, AccessType,
      Location, OrgUnit, FrameworkContract,
      OperatingSystem, OperatingSystemMapping ].each do |model|
      it { is_expected.to be_able_to(:read, model.new) }
    end

    # -- writeable
    [ Network, Line ].each do |model|
      it { is_expected.to be_able_to(:create, model.new) }
      it { is_expected.to be_able_to(:update, model.new) }
      it { is_expected.to be_able_to(:destroy, model.new) }
      it { is_expected.to be_able_to(:manage, model.new) }
    end
    # -- update
    [ Host, HostCategory ].each do |model|
      it { is_expected.not_to be_able_to(:create, model.new) }
      it { is_expected.to be_able_to(:update, model.new) }
      it { is_expected.not_to be_able_to(:destroy, model.new) }
      it { is_expected.not_to be_able_to(:manage, model.new) }
    end


    # -- not writeable
    [ Merkmal, Merkmalklasse, Address, LineState, AccessType,
      Location, OrgUnit, FrameworkContract,
      OperatingSystem, OperatingSystemMapping ].each do |model|
      it { is_expected.not_to be_able_to(:create, model.new) }
      it { is_expected.not_to be_able_to(:update, model.new) }
      it { is_expected.not_to be_able_to(:destroy, model.new) }
      it { is_expected.not_to be_able_to(:manage, model.new) }
    end
  end

  context "with role HostManager" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:authority) { 
      FactoryGirl.create(:authority, 
	authorizable: user, 
	role: wobauth_roles(:host_manager))
    }
    # -- readable, ...
    [ Network, Line, Host, HostCategory,
      Merkmal, Merkmalklasse, Address, LineState, AccessType,
      Location, OrgUnit, FrameworkContract,
      OperatingSystem, OperatingSystemMapping ].each do |model|
      it { is_expected.to be_able_to(:read, model.new) }
    end

    # -- writeable
    [ Host ].each do |model|
      it { is_expected.to be_able_to(:create, model.new) }
      it { is_expected.to be_able_to(:update, model.new) }
      it { is_expected.to be_able_to(:destroy, model.new) }
      it { is_expected.not_to be_able_to(:manage, model.new) }
    end

    # -- no import
      it { is_expected.not_to be_able_to(:new_import, Host) }
      it { is_expected.not_to be_able_to(:import, Host) }

    # -- not writeable
    [ Network, Line, Merkmal, Merkmalklasse, Address, LineState, AccessType,
      Location, OrgUnit, FrameworkContract, HostCategory,
      OperatingSystem, OperatingSystemMapping ].each do |model|
      it { is_expected.not_to be_able_to(:create, model.new) }
      it { is_expected.not_to be_able_to(:update, model.new) }
      it { is_expected.not_to be_able_to(:destroy, model.new) }
      it { is_expected.not_to be_able_to(:manage, model.new) }
    end
  end

  context "with role HostAdmin" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:authority) { 
      FactoryGirl.create(:authority, 
	authorizable: user, 
	role: wobauth_roles(:host_admin))
    }
    # -- readable, ...
    [ Network, Line, Host, HostCategory,
      Merkmal, Merkmalklasse, Address, LineState, AccessType,
      Location, OrgUnit, FrameworkContract,
      OperatingSystem, OperatingSystemMapping ].each do |model|
      it { is_expected.to be_able_to(:read, model.new) }
    end

    # -- writeable
    [ Host, HostCategory, OperatingSystem, OperatingSystemMapping ].each do |model|
      it { is_expected.to be_able_to(:create, model.new) }
      it { is_expected.to be_able_to(:update, model.new) }
      it { is_expected.to be_able_to(:destroy, model.new) }
      it { is_expected.to be_able_to(:manage, model.new) }
      it { is_expected.to be_able_to(:import, model.new) }
      it { is_expected.to be_able_to(:new_import, model.new) }
    end

    # -- not writeable
    [ Network, Line, Merkmal, Merkmalklasse, Address, LineState, AccessType,
      Location, OrgUnit, FrameworkContract ].each do |model|
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
    [ Network, Line, Host, HostCategory,
      Merkmal, Merkmalklasse, Address, LineState, AccessType,
      Location, OrgUnit, FrameworkContract,
      OperatingSystem, OperatingSystemMapping ].each do |model|
      it { is_expected.to be_able_to(:manage, model.new) }
    end
  end
end
