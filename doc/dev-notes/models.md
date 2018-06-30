Models for boskop
=================

Merkmalklasse:
--------------

    bin/rails g scaffold Merkmalklasse name:string:index description:text \
              format:string possible_values:text unique:boolean \
              mandantory:boolean position:integer for_object:string:index \
              visible:string baselink:string tag:string

    # bin/rails g migration AddObjectToMerkmalklasse \
    #           mandantory:boolean position:integer for_object:string:index
    # bin/rails g migration AddVisibleToMerkmalklasse \
    #           visible:string
    # bin/rails g migration AddBaselinkToMerkmalklasse \
    #           baselink:string
    # bin/rails g migration AddTagToMerkmalklasse tag:string

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
              position:integer lid:string:index disabled:boolean:index

    # bin/rails g migration AddLidToLocation \
    #           lid:string:index
    # bin/rails g migration AddDisabledToLocation \
    #           disabled:boolean:index

OrgUnit:
---------

    bin/rails g scaffold OrgUnit name:string:index description:string \
              ancestry:string:index ancestry_depth:integer \
              position:integer

Network:
--------

    bin/rails g scaffold Network location:references netzwerk:cidr \
              name:string description:text


Line:
-----

    bin/rails g scaffold Line \
              name:string description:text \
              provider_id:string \
              'location_a_id:integer:index:null{false}' \
              'location_b_id:integer:index:null{true}' \
              access_type:references:index \
              'bw_upstream:decimal{10,1}' \
              'bw_downstream:decimal{10,1}' \
              'bw2_upstream:decimal{10,1}' \
              'bw2_downstream:decimal{10,1}' \
              framework_contract:references:index \
              contract_start:date contract_end:date contract_period:string \
              period_of_notice:integer period_of_notice_unit:string \
              renewal_period:integer renewal_unit:string \
              'line_state:references:index:null{false}'

#  bin/rails g migration ChangeContractPeriod
#  bin/rails g migration AddBw2ToLine \
#              'bw2_upstream:decimal{10,1}' \
#              'bw2_downstream:decimal{10,1}'
#  bin/rails g migration AddCommentToLine \
#             notes:text


AccessType:
----------- 

    bin/rails g scaffold AccessType \
              name:string description:text

LineState:
---------- 

    bin/rails g scaffold LineState \
              name:string description:text \
              active:boolean

FrameworkContract:
------------------

    bin/rails g scaffold FrameworkContract \
              name:string "description:text:default{''}" \
              contract_start:date contract_end:date contract_period:string \
              period_of_notice:integer period_of_notice_unit:string \
              renewal_period:integer renewal_unit:string \
              active:boolean

Host:
-----

    bin/rails g scaffold Host \
              name:string description:text \
              ip:inet cpe:string:index raw_os:string:index \
              operating_system:references:index \
              lastseen:date mac:string vendor:string \
              fqdn:string workgroup:string domain_dns:string \
              host_category:references:index \
	      location:references:index

#    bin/rails g migration AddWorkgroupDomainDnsFqdnToHost \
#               fqdn:string workgroup:string domain_dns:string

#    bin/rails g migration AddVendorToHost vendor:string
#    bin/rails g migration ChangeIpToInet

HostCategory:
-------------

    bin/rails g scaffold HostCategory \
              name:string description:text tag:string

#    bin/rails g migration AddTagToHostCategory tag:string

OperatingSystem:
----------------

    bin/rails g scaffold OperatingSystem \
              name:string matching_pattern:text eol:date
#    bin/rails g migration AddEolToOperatingSystem eol:date

OperatingSystemMapping:
-----------------------

    bin/rails g scaffold OperatingSystemMapping \
              field:string:index value:string:index \
              operating_system:references

Vulnerability
-------------

    bin/rails g scaffold Vulnerability \
              host:references vulnerability_detail:references lastseen:date

VulnerabilityDetail
-------------------

    bin/rails g scaffold VulnerabilityDetail \
              name:string nvt:string:index \
              family:string:index threat:string:index severity:decimal \
              cves:string bids:string xrefs:string \
              notes:json certs:json

