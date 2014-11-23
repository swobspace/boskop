module ControllerMacros
  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      @admin      = FactoryGirl.create(:user)
      @admin_role = FactoryGirl.create(:role, name: 'Admin')
      @admin_auth ||= Wobauth::Authority.create(:authorizable => @admin, :role => @admin_role)
      sign_in @admin
    end
  end

  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user      = FactoryGirl.create(:user)
      sign_in @user
    end
  end
end
