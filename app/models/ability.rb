class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :search, to: :read
    alias_action :search_form, to: :read
    alias_action :by_lid, to: :read

    @user = user
    if @user.nil?
      can :read, [Location, OrgUnit]
      can :navigate, :org_units

    elsif @user.is_admin?
      can :manage, :all
      cannot [:update, :destroy], :roles, :ro => :true

    # -- with at least one role including :reader
    elsif @user.authorities.any? || @user.group_authorities.any?
      # -- reader
      can :navigate, [:org_units, :configuration]
      can :read, :all
      can [:eol_summary, :vuln_risk_matrix], Host
      cannot :read, Vulnerability
      cannot :read, NessusScan
      can [:usage, :usage_form], Network

      if @user.role?(:network_manager)
	can :manage, [ Network, Line] 
	can [:read, :update], [Host, HostCategory]
      end

      if @user.role?(:host_reader)
	can [:read, :csv], [Host, Vulnerability]
      end

      if @user.role?(:host_manager)
	can [:csv, :create, :update, :destroy], [Host, NetworkInterface] 
        can [:read, :csv], [Vulnerability, VulnerabilityDetail]
      end

      if @user.role?(:host_admin)
	can :manage, [Host, HostCategory, NetworkInterface,
                     Vulnerability, VulnerabilityDetail,
                     OperatingSystem, OperatingSystemMapping]
      end

    else  # -- logged in, but without role
      can :navigate, [:org_units, :configuration]
      can :read, [Location, OrgUnit, Network]
      can [:usage, :usage_form], Network
    end
  end
end
