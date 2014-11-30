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

Ubuntu
------
Install server package from distribution. Then initialize and start the daemon,
i.e. for Ubuntu 14.04:

    sudo apt-get install postgresql

Set password for user postgres:

    sudo -u postgres psql postgres
    \password postgres

Create database boskop_production:

    sudo -u postgres createdb boskop_production

Setup a login role for user boskop with pgadmin3 and change ownership 
of boskop_production to role boskop.
