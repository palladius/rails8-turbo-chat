
# app/models/message.rb
class Message < ApplicationRecord
  acts_as_message

  include ActionView::RecordIdentifier

  # Content can be blank for assistant messages initially, e.g., during streaming.
  validates :content, presence: true, unless: -> { role == 'assistant' }

  # Broadcast updates to self (for streaming into the message frame)
  broadcasts_to ->(message) { [message.chat, "messages"] }

  # Helper to broadcast chunks during streaming
  def broadcast_append_chunk(chunk_content)
    broadcast_append_to [ chat, "messages" ], # Target the stream
      target: dom_id(self, "content"), # Target the content div inside the message frame
      html: chunk_content # Append the raw chunk
  end

  def system?
    role == 'system'
  end

  def to_s
    self.inspect
  end
end
