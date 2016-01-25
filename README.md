boskop
======

boskop is a rails web application to manage ip network 
information depended on locations (sites, buildings, ...). If you want to
define a new private ipv4 network for a location which should be uniq within
your widely distributed company network, you need a very good documentation
if you have hundreds or thousands of subnets. boskop helps you to document
and lookup for existing networks. I.e. you would use 192.168.6.0/23 as a uniq
network, boskop returns not only exact matching, but also conflicting networks
such as 192.168.0.0/21, 192.168.4.0/22 and 192.168.7.0/24 if any of these
is already defined.

boskop makes heavy usage of cidr and inet types of postgresql for searching
and matching ip addresses and ip networks. It does not work with any other
database yet.

**THIS APPLICATION IS WORK IN PROGRESS AND NOT FUNCTIONAL YET!**
You will loose all your hair and teeth if you use this application ;-)

Requirements
------------

* ruby >= 2.0
* postgresql database
* postgresql development files (i.e. fedora: package postgresql-devel) for 
compiling ruby pg gem

System dependencies
-------------------
TBD

Installation
------------
TBD

Configuration
-------------
TBD

Deployment
----------
TBD

Licence
-------

boskop Copyright (C) 2014-2016  Wolfgang Barth

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License along
with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

