json.extract! contact, :id, :sn, :givenname, :displayname, :title, :anrede, :position, :streetaddress, :plz, :ort, :postfach, :postfachplz, :care_of, :telephone, :telefax, :mobile, :mail, :internet, :created_at, :updated_at
json.url contact_url(contact, format: :json)
