class AddMissingFields < ActiveRecord::Migration[6.1]
    def change
      change_table :app_notifications do |t|
				t.boolean :is_tmp, default: false
				t.integer :days
      end
    end
end
