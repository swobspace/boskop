require 'rails_helper'
require "cancan/matchers"

RSpec.shared_examples "a Reader" do
  # -- readable, ...
  [ Network, Line, Host, HostCategory, NetworkInterface,
    Merkmal, Merkmalklasse, Address, LineState, AccessType,
    Location, OrgUnit, FrameworkContract,
    VulnerabilityDetail,
    OperatingSystem, OperatingSystemMapping ].each do |model|
    it { is_expected.to be_able_to(:read, model.new) }
  end
  it { is_expected.to be_able_to(:eol_summary, Host) }
  it { is_expected.to be_able_to(:vuln_risk_matrix, Host) }

  it { is_expected.not_to be_able_to(:read, Vulnerability.new) }
  it { is_expected.not_to be_able_to(:read, NessusScan.new) }

  # -- ... but not writeable
  [ Network, Line, Host, HostCategory, NetworkInterface,
    Merkmal, Merkmalklasse, Address, LineState, AccessType,
    Location, OrgUnit, FrameworkContract,
    Vulnerability, VulnerabilityDetail,
    OperatingSystem, OperatingSystemMapping ].each do |model|
    it { is_expected.not_to be_able_to(:create, model.new) }
    it { is_expected.not_to be_able_to(:update, model.new) }
    it { is_expected.not_to be_able_to(:destroy, model.new) }
    it { is_expected.not_to be_able_to(:manage, model.new) }
  end
end

RSpec.shared_examples "a NetworkManager" do
  # -- readable, ...
  [ Network, Line, Host, HostCategory, NetworkInterface,
    Merkmal, Merkmalklasse, Address, LineState, AccessType,
    Location, OrgUnit, FrameworkContract,
    VulnerabilityDetail,
    OperatingSystem, OperatingSystemMapping ].each do |model|
    it { is_expected.to be_able_to(:read, model.new) }
  end

  it { is_expected.not_to be_able_to(:read, Vulnerability.new) }
  it { is_expected.not_to be_able_to(:read, NessusScan.new) }

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
    Location, OrgUnit, FrameworkContract, NetworkInterface,
    Vulnerability, VulnerabilityDetail,
    OperatingSystem, OperatingSystemMapping ].each do |model|
    it { is_expected.not_to be_able_to(:create, model.new) }
    it { is_expected.not_to be_able_to(:update, model.new) }
    it { is_expected.not_to be_able_to(:destroy, model.new) }
    it { is_expected.not_to be_able_to(:manage, model.new) }
  end
end

RSpec.shared_examples "a HostReader" do
  # -- readable, ...
  [ Network, Line, Host, HostCategory, NetworkInterface,
    Merkmal, Merkmalklasse, Address, LineState, AccessType,
    Location, OrgUnit, FrameworkContract,
    Vulnerability, VulnerabilityDetail,
    OperatingSystem, OperatingSystemMapping ].each do |model|
    it { is_expected.to be_able_to(:read, model.new) }
  end

  # -- writeable
  # nothing

    it { is_expected.to be_able_to(:csv, Host) }
    it { is_expected.to be_able_to(:csv, Vulnerability) }
  # -- no import
    it { is_expected.not_to be_able_to(:new_import, Host) }
    it { is_expected.not_to be_able_to(:import, Host) }
    it { is_expected.not_to be_able_to(:new_import, Vulnerability) }
    it { is_expected.not_to be_able_to(:import, Vulnerability) }
    it { is_expected.not_to be_able_to(:read, NessusScan) }

  # -- not writeable
  [ Network, Line, Merkmal, Merkmalklasse, Address, LineState, AccessType,
    Location, OrgUnit, FrameworkContract, Host, HostCategory, NetworkInterface,
    Vulnerability, VulnerabilityDetail,
    OperatingSystem, OperatingSystemMapping ].each do |model|
    it { is_expected.not_to be_able_to(:create, model.new) }
    it { is_expected.not_to be_able_to(:update, model.new) }
    it { is_expected.not_to be_able_to(:destroy, model.new) }
    it { is_expected.not_to be_able_to(:manage, model.new) }
  end
end

RSpec.shared_examples "a HostManager" do
  # -- readable, ...
  [ Network, Line, Host, HostCategory, NetworkInterface,
    Merkmal, Merkmalklasse, Address, LineState, AccessType,
    Location, OrgUnit, FrameworkContract,
    Vulnerability, VulnerabilityDetail,
    OperatingSystem, OperatingSystemMapping ].each do |model|
    it { is_expected.to be_able_to(:read, model.new) }
  end

  # -- writeable
  [ Host, NetworkInterface ].each do |model|
    it { is_expected.to be_able_to(:create, model.new) }
    it { is_expected.to be_able_to(:update, model.new) }
    it { is_expected.to be_able_to(:destroy, model.new) }
    it { is_expected.not_to be_able_to(:manage, model.new) }
  end

    it { is_expected.to be_able_to(:csv, Host) }
  # -- no import
    it { is_expected.not_to be_able_to(:new_import, Host) }
    it { is_expected.not_to be_able_to(:import, Host) }
    it { is_expected.not_to be_able_to(:new_import, Vulnerability) }
    it { is_expected.not_to be_able_to(:import, Vulnerability) }
    it { is_expected.not_to be_able_to(:read, NessusScan) }

  # -- not writeable
  [ Network, Line, Merkmal, Merkmalklasse, Address, LineState, AccessType,
    Location, OrgUnit, FrameworkContract, HostCategory,
    Vulnerability, VulnerabilityDetail,
    OperatingSystem, OperatingSystemMapping ].each do |model|
    it { is_expected.not_to be_able_to(:create, model.new) }
    it { is_expected.not_to be_able_to(:update, model.new) }
    it { is_expected.not_to be_able_to(:destroy, model.new) }
    it { is_expected.not_to be_able_to(:manage, model.new) }
  end
end

RSpec.shared_examples "a HostAdmin" do
  it { is_expected.not_to be_able_to(:read, NessusScan) }

  # -- readable, ...
  [ Network, Line, Host, HostCategory, NetworkInterface,
    Merkmal, Merkmalklasse, Address, LineState, AccessType,
    Location, OrgUnit, FrameworkContract,
    Vulnerability, VulnerabilityDetail,
    OperatingSystem, OperatingSystemMapping ].each do |model|
    it { is_expected.to be_able_to(:read, model.new) }
  end

  # -- writeable
  [ Host, HostCategory, NetworkInterface,
    Vulnerability, VulnerabilityDetail,
    OperatingSystem, OperatingSystemMapping ].each do |model|
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

RSpec.shared_examples "an Admin" do
  [ Network, Line, Host, HostCategory, NetworkInterface,
    Merkmal, Merkmalklasse, Address, LineState, AccessType,
    Location, OrgUnit, FrameworkContract,
    Vulnerability, VulnerabilityDetail, NessusScan,
    OperatingSystem, OperatingSystemMapping ].each do |model|
    it { is_expected.to be_able_to(:manage, model.new) }
  end
end

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
      Vulnerability, VulnerabilityDetail,
      OperatingSystem, OperatingSystemMapping ].each do |model|
      it { is_expected.not_to be_able_to(:read, model.new) }
      it { is_expected.not_to be_able_to(:create, model.new) }
      it { is_expected.not_to be_able_to(:update, model.new) }
      it { is_expected.not_to be_able_to(:destroy, model.new) }
      it { is_expected.not_to be_able_to(:manage, model.new) }
    end

  end

  context "logged in without any role" do
    let(:user) { FactoryBot.create(:user) }

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
      Vulnerability, VulnerabilityDetail,
      OperatingSystem, OperatingSystemMapping ].each do |model|
      it { is_expected.not_to be_able_to(:read, model.new) }
      it { is_expected.not_to be_able_to(:create, model.new) }
      it { is_expected.not_to be_able_to(:update, model.new) }
      it { is_expected.not_to be_able_to(:destroy, model.new) }
      it { is_expected.not_to be_able_to(:manage, model.new) }
    end
  end

  context "with role Reader assigned to user" do
    let(:user) { FactoryBot.create(:user) }
    let!(:authority) { 
      FactoryBot.create(:authority, 
	authorizable: user, 
	role: wobauth_roles(:reader))
    }
    it_behaves_like "a Reader"
  end

  context "with role Reader assigned to group" do
    let(:user) { FactoryBot.create(:user) }
    let(:group) { FactoryBot.create(:group) }
    let!(:membership) { FactoryBot.create(:membership, user: user, group: group) }
    let!(:authority) { 
      FactoryBot.create(:authority, 
	authorizable: group, 
	role: wobauth_roles(:reader))
    }
    it_behaves_like "a Reader"
  end

  context "with role NetworkManager assigned to user" do
    let(:user) { FactoryBot.create(:user) }
    let!(:authority) { 
      FactoryBot.create(:authority, 
	authorizable: user, 
	role: wobauth_roles(:network_manager))
    }
    it_behaves_like "a NetworkManager"
  end

  context "with role NetworkManager assigned to group" do
    let(:user) { FactoryBot.create(:user) }
    let(:group) { FactoryBot.create(:group) }
    let!(:membership) { FactoryBot.create(:membership, user: user, group: group) }
    let!(:authority) { 
      FactoryBot.create(:authority, 
	authorizable: group, 
	role: wobauth_roles(:network_manager))
    }
    it_behaves_like "a NetworkManager"
  end

  context "with role HostReader assigned to user" do
    let(:user) { FactoryBot.create(:user) }
    let!(:authority) { 
      FactoryBot.create(:authority, 
	authorizable: user, 
	role: wobauth_roles(:host_reader))
    }
    it_behaves_like "a HostReader"
  end

  context "with role HostReader assigned to group" do
    let(:user) { FactoryBot.create(:user) }
    let(:group) { FactoryBot.create(:group) }
    let!(:membership) { FactoryBot.create(:membership, user: user, group: group) }
    let!(:authority) { 
      FactoryBot.create(:authority, 
	authorizable: group, 
	role: wobauth_roles(:host_reader))
    }
    it_behaves_like "a HostReader"
  end

  context "with role HostManager assigned to user" do
    let(:user) { FactoryBot.create(:user) }
    let!(:authority) { 
      FactoryBot.create(:authority, 
	authorizable: user, 
	role: wobauth_roles(:host_manager))
    }
    it_behaves_like "a HostManager"
  end

  context "with role HostManager assigned to group" do
    let(:user) { FactoryBot.create(:user) }
    let(:group) { FactoryBot.create(:group) }
    let!(:membership) { FactoryBot.create(:membership, user: user, group: group) }
    let!(:authority) { 
      FactoryBot.create(:authority, 
	authorizable: group, 
	role: wobauth_roles(:host_manager))
    }
    it_behaves_like "a HostManager"
  end

  context "with role HostAdmin assigned to user" do
    let(:user) { FactoryBot.create(:user) }
    let!(:authority) { 
      FactoryBot.create(:authority, 
	authorizable: user, 
	role: wobauth_roles(:host_admin))
    }
    it_behaves_like "a HostAdmin"
  end

  context "with role HostAdmin assigned to group" do
    let(:user) { FactoryBot.create(:user) }
    let(:group) { FactoryBot.create(:group) }
    let!(:membership) { FactoryBot.create(:membership, user: user, group: group) }
    let!(:authority) { 
      FactoryBot.create(:authority, 
	authorizable: group, 
	role: wobauth_roles(:host_admin))
    }
    it_behaves_like "a HostAdmin"
  end

  context "with role Admin assigned to user" do
    let(:user) { FactoryBot.create(:user) }
    let!(:authority) { 
      FactoryBot.create(:authority, 
	authorizable: user, 
	role: wobauth_roles(:admin))
      }
    it_behaves_like "an Admin"
  end

  context "with role Admin assigned to group" do
    let(:user) { FactoryBot.create(:user) }
    let(:group) { FactoryBot.create(:group) }
    let!(:membership) { FactoryBot.create(:membership, user: user, group: group) }
    let!(:authority) { 
      FactoryBot.create(:authority, 
	authorizable: group, 
	role: wobauth_roles(:admin))
      }
    it_behaves_like "an Admin"
  end
end
