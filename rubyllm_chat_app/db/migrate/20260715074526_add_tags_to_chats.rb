class AddTagsToChats < ActiveRecord::Migration[8.0]
  def change
    add_column :chats, :tags, :string
  end
end
