class CreateAvailableHostRanges < ActiveRecord::Migration
  def change
    create_table :available_host_ranges do |t|
      t.integer :host_id, null: false, index: true

      t.datetime :start_date, null: false
      t.datetime :end_date, null: false

      t.timestamps null: false
    end
  end
end
