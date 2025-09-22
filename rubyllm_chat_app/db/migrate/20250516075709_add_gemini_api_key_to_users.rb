class AddGeminiApiKeyToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :gemini_api_key, :string
  end
end
