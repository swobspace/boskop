Models for boskop
=================

Merkmalklasse:
--------------

    bin/rails g scaffold Merkmalklasse name:string:index description:text \
              format:string possible_values:text unique:boolean \
              mandantory:boolean position:integer for_object:string:index \
              visible:string baselink:string

    # bin/rails g migration AddObjectToMerkmalklasse \
    #           mandantory:boolean position:integer for_object:string:index
    # bin/rails g migration AddVisibleToMerkmalklasse \
    #           visible:string
    # bin/rails g migration AddBaselinkToMerkmalklasse \
    #           baselink:string

Merkmal:
--------

    bin/rails g scaffold Merkmal 'merkmalfor:references{polymorphic}' \
              merkmalklasse:references value:string

Address:
--------

    bin/rails g scaffold Address 'addressfor:references{polymorphic}' \
              streetaddress:string plz:string ort:string care_of:string \
              postfach:string postfachplz:string

Location:
---------

    bin/rails g scaffold Location name:string:index description:string \
              ancestry:string:index ancestry_depth:integer \
              position:integer

OrgUnit:
---------

    bin/rails g scaffold OrgUnit name:string:index description:string \
              ancestry:string:index ancestry_depth:integer \
              position:integer

Network:
--------

    bin/rails g scaffold Network location:references netzwerk:cidr \
              name:string description:text

