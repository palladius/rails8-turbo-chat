# typed: false
class Message < ApplicationRecord
  # For dom_id helper
  include ActionView::RecordIdentifier
  # For broadcasting
  include Turbo::Streams::Broadcasts

  # RubyLLM Integration
  acts_as_message # Assumes Chat and ToolCall model names

  # Standard Rails Model Logic
  belongs_to :chat
  belongs_to :tool_call, optional: true # Link tool result back to call

  # Validations
  validates :role, presence: true, inclusion: { in: %w[system user assistant tool] }
  # Content can be nil for assistant messages initially during streaming
  # validates :content, presence: true # Might interfere with streaming

  # Enum for role for cleaner handling (Rails 7+)
  #enum role: { system: "system", user: "user", assistant: "assistant", tool: "tool" }

  # --- Streaming Support ---

  # Broadcast updates to self (specifically for streaming content into the message frame)
  # broadcasts_to ->(message) { [message.chat, "messages"] } # Covered by Chat's broadcast

  # Manually broadcast chunks during streaming to update the content div
  # Uses ActionCable's broadcast_append_to
  def broadcast_append_chunk(chunk_content)
    # Ensure we target the specific message's content area within the chat's stream
    broadcast_append_to(
      [chat, "messages"], # The stream name derived from the chat
      target: dom_id(self, :content), # Target the content div: "message_123_content"
      html: chunk_content # Append the raw chunk (consider sanitization/markdown later)
    )
  end

  # After a message is created (esp. user messages), ensure it's visible
  after_create_commit -> { broadcast_append_to [chat, "messages"], target: "messages", partial: "messages/message", locals: { message: self } }
  # When streaming is done, the final update might need a broadcast replace to clean up
  # Let's rely on the initial render and streaming appends for now.
end
