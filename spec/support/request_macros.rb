# -*- encoding : utf-8 -*-
module RequestMacros
  include Warden::Test::Helpers
  Warden.test_mode!

  # for use in request specs
  def login_user
    @user = FactoryGirl.create(:user)
    login_as @user
  end

  # for use in request specs
  def login_admin
    @admin      = FactoryGirl.create(:user)
    @admin_role = FactoryGirl.create(:role, name: 'Admin')
    FactoryGirl.create(:authority, :authorizable => @admin, :role => @admin_role)
    login_as @admin
  end
end
