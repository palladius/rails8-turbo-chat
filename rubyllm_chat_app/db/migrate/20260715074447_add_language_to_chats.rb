class AddLanguageToChats < ActiveRecord::Migration[8.0]
  def change
    add_column :chats, :language, :string
  end
end
