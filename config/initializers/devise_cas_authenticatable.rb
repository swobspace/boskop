if Boskop.devise_modules.include?(:cas_authenticatable)
  if Settings.authentication.nil? or Settings.authentication.cas_base_url.nil?
    raise "cas_authenticatable not configured!"
  else
    Devise.setup do |config|
      # -- CAS Configuration
      cas_base_url = Settings.authentication.cas_base_url
      config.cas_base_url     = cas_base_url
      config.cas_login_url    = Settings.authentication.fetch('cas_login_url',    cas_base_url + '/login')
      config.cas_logout_url   = Settings.authentication.fetch('cas_logout',       cas_base_url + '/logout')
      config.cas_validate_url = Settings.authentication.fetch('cas_validate_url', cas_base_url + '/serviceValidate')
    end
  end
end
