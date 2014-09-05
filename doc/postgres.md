Preparing PostgresQL
====================

Install server package from distribution. Then initialize and start the daemon,
i.e. for Fedora 20:

    postgresql-setup initdb
    systemctl start postgresql.service

To enable postgresql daemon permanently:

    systemctl enable postgresql.service


