class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user
    if @user.nil?
      can :read, [Location, OrgUnit]
      can :navigate, :org_units
      
    elsif @user.is_admin?
      can :manage, :all
      cannot [:update, :destroy], :roles, :ro => :true
    else
      can :read, :all
    end
  end

end
