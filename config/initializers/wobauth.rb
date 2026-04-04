Wobauth.setup do |config|
  #
  # Configuration for Authorization
  # 1. Subject: Authorizable
  # do not change it unless you know exactly what you are doing
  #
  # config.authorizable_types = [ "Wobauth::User", "Wobauth::Group" ]
  #
  # 2. Object: Authorized_for
  # depends on your application ...
  # default: []
  #
  # config.authorized_for_types = [ "MyClass", ...]
  #
  config.ldap_config = File.join( Rails.root, 'config', 'boskop.yml')
  #
  config.custom_stream_actions = true

  config.enable_ldap_authenticatable = Boskop.enable_ldap_authentication
end
