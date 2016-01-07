class ChangeDetailsAvailableHostRange < ActiveRecord::Migration
  def change
    rename_column :available_host_ranges, :host_id, :hosting_id
  end
end
