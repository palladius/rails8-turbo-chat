class CreateChats < ActiveRecord::Migration[8.0]
  def change
    create_table :chats do |t|
      t.references :user, null: false, foreign_key: true
      t.string :model_id
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
