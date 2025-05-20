# From https://learnitnow.medium.com/bridging-the-gap-connecting-python-ai-agents-to-ruby-apps-with-mcp-614977012399

# app/tools/create_user.rb

# For some reason, it seems to CACHE the previous version of the file where password was NOT available.
class CreateUser < ApplicationTool
  description 'Creates a new user'

  arguments do
    optional(:name).filled(:string).description('name of a user')
    required(:email).filled(:string).description('email of the user')
    required(:password).filled(:string).description('password of the user')
  end

  def call(name:, email:, password:)
      puts("[🛠️ MCP 🛠️] CreateUser: name: #{name}, email: #{email}, password: XXXX")
      user = User.new(name: name, email: email, password: password)

      if user.save
          "User #{user.name} created successfully"
      else
          user.errors.full_messages.join(', ')
      end
  end
end
