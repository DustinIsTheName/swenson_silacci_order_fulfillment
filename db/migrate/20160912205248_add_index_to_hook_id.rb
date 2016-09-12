class AddIndexToHookId < ActiveRecord::Migration
  def change
  	add_index :webhooks, :hook_id, :unique => true
  end
end
