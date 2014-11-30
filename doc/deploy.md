Capistrano deployment
=====================

Preparations
------------

1. Create user deploy
2. Create the ${deploy_to} directory
3. You should be able to ssh as user deploy with pubkey authorization
4. Check permissions:

    bundle exec cap production deploy:check_write_permissions

5. Check git:

    cap production git:check

Database setup
--------------
see postgres.md

Configuration files
-------------------

Create the following files in ${deploy_to}/shared/config:

1. application.yml (unused for now, empty file)
2. database.yml
3. secrets.yml

Create a boskop.conf in your apache2 conf.d directory

Deploy
------

    bundle exec cap production deploy

