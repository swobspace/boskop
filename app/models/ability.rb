class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :search, :to => :read

    @user = user
    if @user.nil?
      can :read, [Location, OrgUnit]
      can :navigate, :org_units

    elsif @user.is_admin?
      can :manage, :all
      cannot [:update, :destroy], :roles, :ro => :true

    elsif @user.role?(:network_manager)
      can :navigate, [:org_units, :configuration]
      can :read, :all
      can [:usage, :usage_form], Network

    else
      can :navigate, [:org_units, :configuration]
      can :read, [Location, OrgUnit, Network]
      can [:usage, :usage_form], Network
    end
  end

end
