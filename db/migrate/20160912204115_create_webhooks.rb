class CreateWebhooks < ActiveRecord::Migration
  def change
    create_table :webhooks do |t|

    	t.text :body

	  	t.string :hook_id

      t.timestamps null: false
    end
  end
end
