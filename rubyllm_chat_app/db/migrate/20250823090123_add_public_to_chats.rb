class AddPublicToChats < ActiveRecord::Migration[8.0]
  def change
    add_column :chats, :public, :boolean, default: false, null: false
  end
end
