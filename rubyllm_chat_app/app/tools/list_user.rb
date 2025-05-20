# From https://learnitnow.medium.com/bridging-the-gap-connecting-python-ai-agents-to-ruby-apps-with-mcp-614977012399

# app/tools/list_user.rb
class ListUser < ApplicationTool
  description 'It list of users'

  def call
      User.all.map do |user|
          { name: user.name, email: user.email }
      end.to_json
  end
end
