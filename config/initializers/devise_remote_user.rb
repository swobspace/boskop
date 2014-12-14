if Boskop.devise_modules.include?(:remote_user_authenticatable)
  require 'devise_remote_user'

  DeviseRemoteUser.configure do |config|
    config.env_key = 'REMOTE_USER'
    config.auto_create = true
    config.auto_update = true
    config.attribute_map = {email: 'mail'}
    config.logout_url = "http://my.host/path.to.remote.logout"
    config.user_model = 'Wobauth::User'
  end

end
