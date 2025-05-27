# From https://learnitnow.medium.com/bridging-the-gap-connecting-python-ai-agents-to-ruby-apps-with-mcp-614977012399

# app/tools/list_users.rb
class ListUsers < ApplicationTool
  description 'It list of users'

  def call
      User.all.map do |user|
          { id: user.id, name: user.name, email: user.email }
      end.to_json
  end
end
