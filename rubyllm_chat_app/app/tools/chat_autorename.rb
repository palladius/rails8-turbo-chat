# Chat.autotitle_if_needed
# frozen_string_literal: true

class ChatAutorename < ApplicationTool
  description 'Updates Chat titles with a default name by invoking Gemini'

  def call
    # TODO - do a turbo propagation to all chats to refresh in UI
    # could be AS SIMPLE as uncommenting this line in Chat model:
    #   # broadcasts_to ->(chat) { [chat.user, "chats"] } # Broadcast to the user's chat stream
      ret = Chat.autotitle_if_needed
      ret.to_json
  end
end
