class AddArticleNews < ActiveRecord::Migration
    def up
      change_table :app_notifications do |t|
        t.references :news, index: true
        t.references :article, index: true
      end
    end

    def down
    end
end
