# frozen_string_literal: true

class ChatList < ApplicationTool
  description 'Get List of Chat titles'

  def call
      Chat.all.map do |chat|
          {
            id: chat.id,
            title: chat.title,
            model_id: chat.model_id
          }
      end.to_json
  end
end
