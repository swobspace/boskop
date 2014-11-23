class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user
    if @user.nil?
      can :read, Location
    elsif @user.is_admin?
      can :manage, :all
      cannot [:update, :destroy], :roles, :ro => :true
    else
      can :read, :all
    end
  end

end
