class SetDefaultSoftwareRawData < ActiveRecord::Migration[6.0]
  def up
    SoftwareRawDatum.where(version: nil).update_all(version: "")
    SoftwareRawDatum.where(vendor: nil).update_all(vendor: "")
    SoftwareRawDatum.where(operating_system: nil).update_all(operating_system: "")
  end

  def down
  end
end
