Models for boskop
=================

Merkmalklasse:
--------------

    bin/rails g scaffold Merkmalklasse name:string:index description:text \
              format:string possible_values:text \
              mandantory:boolean position:integer for_object:string:index

    # bin/rails g migration AddObjectToMerkmalklasse \
    #           mandantory:boolean position:integer for_object:string:index
