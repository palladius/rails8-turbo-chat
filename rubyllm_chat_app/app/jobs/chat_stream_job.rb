# typed: false
class ChatStreamJob < ApplicationJob
  queue_as :default

  # Set default model if not provided by chat (fallback)
  DEFAULT_MODEL = DEFAULT_LLM_MODEL # ENV.fetch('DEFAULT_LLM_MODEL', 'gpt-4o-mini') # Or your preferred default

  # Define a simple error class for chat issues
  class ChatError < StandardError; end

  # Rescue from errors and potentially notify or log
  rescue_from StandardError do |exception|
    Rails.logger.error "🔥 ChatStreamJob Error: #{exception.message}"
    Rails.logger.error exception.backtrace.join("\n")
    # TODO: Maybe update the chat UI to show an error?
    # Find the chat and broadcast an error message?
    # chat_id = arguments.first # Risky assumption
    # Chat.find(chat_id).broadcast_append_to(...)
  end

  def perform(chat_id, user_content)
    chat = Chat.find_by(id: chat_id)
    raise ChatError, "Chat not found with ID: #{chat_id}" unless chat

    Rails.logger.info "🤖 Starting ChatStreamJob for Chat ##{chat.id}"

    # Determine the model to use
    model_to_use = chat.model_id.presence || DEFAULT_MODEL
    Rails.logger.info "🧠 Using model: #{model_to_use}"
    Rails.logger.info "🧠 user_content: #{user_content}"
    if user_content.to_s == ''
      Rails.logger.info "🧠 EMPTY user_content: #{user_content} => exiting"
      return
    end

    # Use a temporary assistant message record for streaming updates
    # `acts_as_chat` handles creating the user message automatically when `ask` is called.
    # `ask` also creates the *initial* assistant message record before the API call.
    assistant_message = nil # Will be set inside the `ask` process

    # The `ask` method handles:
    # 1. Persisting the `user_content` as a user message associated with `chat`.
    # 2. Fetching history (including the new user message).
    # 3. Creating an *empty* assistant message record.
    # 4. Making the API call with streaming enabled (due to the block).
    # 5. Yielding chunks to the block.
    # 6. Persisting the final assistant message content and token counts on completion.
    print("👀👀👀 Riccardo qui fallisce  chat.ask(user_content='#{user_content}', model: #{model_to_use})  👀👀👀")
    #chat.ask(user_content, model: model_to_use) do |chunk|
    chat.ask(user_content) do |chunk|
        # The assistant message record is created by `acts_as_chat` before this block runs.
      # Fetch it reliably (it should be the last message in the chat).
      #assistant_message ||= chat.messages.assistant.last
      assistant_message ||= chat.messages.where(role: 'assistant').last
      raise ChatError, "Could not find assistant message to stream into for Chat ##{chat.id}" unless assistant_message

      if chunk&.content.present?
        # Append the streamed chunk content to the message's target div via Turbo Streams
        # Using the helper method defined in the Message model
        assistant_message.broadcast_append_chunk(chunk.content)
        # Optional: Add a small delay if streaming feels *too* fast locally
        # sleep 0.01
      elsif chunk&.tool_calls.present?
         Rails.logger.info "🛠️ Tool call received (handling not implemented in this job): #{chunk.tool_calls}"
         # In a real app, you'd trigger tool execution here and send back a 'tool' role message.
         # For now, we'll just log it. The tool call itself is persisted by acts_as_chat.
         assistant_message.broadcast_append_chunk("\n*Received tool call (processing not implemented)*")
      end
    end

    Rails.logger.info "✅ ChatStreamJob finished for Chat ##{chat.id}"
    # The final assistant message content/tokens are automatically saved by `acts_as_chat` after the block.
    # Optional: broadcast a final "replace" to clean up the message div if needed,
    # e.g., to render markdown properly after streaming is complete.
    # assistant_message&.broadcast_replace_to([chat, "messages"], target: dom_id(assistant_message), partial: "messages/message", locals: { message: assistant_message })

  rescue => e
      Rails.logger.error "🔥 FAILED ChatStreamJob for Chat ##{chat_id}: #{e.message}"
      # Potentially update the UI to show an error message
      if assistant_message
        # Append error info to the message stream
         error_html = "<strong class='text-red-600'>Error processing request: #{e.message}</strong>"
         assistant_message.broadcast_append_chunk(error_html)
         # Update the persisted message content too
         assistant_message.update(content: (assistant_message.content || "") + "\nError: #{e.message}")
      else
         # Maybe broadcast a general error to the chat?
         chat&.broadcast_append_to([chat, "messages"], target: "messages", html: "<div class='text-red-600 p-4'>An error occurred: #{e.message}</div>")
      end
      raise # Re-raise for job runner (e.g., Sidekiq) to handle retries/failures
  end
end
