# production.rb
config = YAML.load_file('config/deploy-config.yml') || {}

set :rails_env, 'production'

role :app, config['hosts']['app']
role :web, config['hosts']['web']
role :db,  config['hosts']['db']


# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult[net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start).
#
# Global options
# --------------
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# And/or per server (overrides global)
# ------------------------------------
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
set :ssh_options, {
    forward_agent: false,
    auth_methods: %w(publickey),
    host_key: config.fetch('host_key') { %w(ecdsa-sha2-nistp256 ssh-rsa) },
    user: config['user'],
}
