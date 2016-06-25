Preparing PostgresQL
====================

Fedora
-------

Install server package from distribution. Then initialize and start the daemon,
i.e. for Fedora 20:

    postgresql-setup initdb
    systemctl start postgresql.service

To enable postgresql daemon permanently:

    systemctl enable postgresql.service

To upgrade postgresql:

    dnf install postgresql-update
    postgresql-setup --upgrade

Check output and /var/lib/pgsql/upgrade_postgresql.log for details.

Ubuntu
------
Install server package from distribution. Then initialize and start the daemon,
i.e. for Ubuntu 14.04:

    sudo apt-get install postgresql

Setup user and database
------------------------

Set password for user postgres:

    sudo -u postgres psql postgres
    \password postgres

Create role boskop:

    createuser -D -E -S -R -W boskop

Create databases:

    sudo -u postgres createdb -O boskop boskop_production

For boskop development, you may create the following databases:

    sudo -u postgres createdb -O boskop boskop_development
    sudo -u postgres createdb -O boskop boskop_test

