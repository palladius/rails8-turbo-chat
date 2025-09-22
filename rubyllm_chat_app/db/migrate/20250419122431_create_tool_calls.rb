class CreateToolCalls < ActiveRecord::Migration[8.0]
  def change
    create_table :tool_calls do |t|
      # t.references :message, null: false, foreign_key: true
      # t.string :tool_call_id
      # t.string :name, null: false
      # t.jsonb :arguments
      t.references :message, null: false, foreign_key: true # Assistant message making the call
      t.string :tool_call_id, null: false, index: { unique: true } # Provider's ID for the call
      t.string :name, null: false
      t.jsonb :arguments, default: {} # Use jsonb for PostgreSQL

      t.timestamps
    end
  end
end
