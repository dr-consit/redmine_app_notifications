class UpdateInAppNotifi < ActiveRecord::Migration
    def self.up
        change_column_default :users, :app_notification, true
        
        User.find_each do |user|
            user.app_notification = true
            user.save!
        end
    end

    def self.down
    end
end
