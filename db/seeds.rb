# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# -- load YAML config data
config = YAML::load_file(File.join(Rails.root, 'db', 'seeds.yml'))

# -- Roles from yaml(:uniqueness => true)
Wobauth::Role.create(config['roles'])

# -- start with Admin
admin_role = Wobauth::Role.find_by_name("Admin")

Wobauth::User.transaction do
  admin = Wobauth::User.find_or_create_by(username: 'admin') do |adm|
	    adm.sn = 'Admin'
	    adm.givenname = 'Meister'
	    adm.password = 'admin9999'
	    adm.password_confirmation = 'admin9999'
	  end

  Wobauth::Authority.transaction do
    a = Wobauth::Authority.find_or_create_by(authorizable: admin, role: admin_role)
    raise ActiveRecord::Rollback if a.nil?
  end
end


