# From https://learnitnow.medium.com/bridging-the-gap-connecting-python-ai-agents-to-ruby-apps-with-mcp-614977012399

# app/tools/create_user.rb
class CreateUser < ApplicationTool
  description 'Creats a new user'

  arguments do
    required(:name).filled(:string).description('name of a user')
    optional(:email).filled(:string).description('email of the user')
  end

  def call(name:, email:)
      user = User.new(name: name, email: email)

      if user.save
          "User #{user.name} created successfully"
      else
          user.errors.full_messages.join(', ')
      end
  end
end
