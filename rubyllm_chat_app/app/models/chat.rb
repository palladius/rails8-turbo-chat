# typed: false
class Chat < ApplicationRecord
  # RubyLLM Integration
  acts_as_chat # Assumes Message and ToolCall model names

  # Standard Rails Model Logic
  belongs_to :user
  has_many :messages, -> { order(created_at: :asc) }, dependent: :destroy # Ensure messages are ordered

  # Validations
  validates :model_id, presence: true # Ensure a model is selected
  validates :title, presence: true, length: { minimum: 3 }

  # Set a default title if none provided before validation
  before_validation :set_default_title, on: :create

  # Turbo Stream Broadcasting for the chat list (when a chat is created/deleted)
  # broadcasts_to ->(chat) { [chat.user, "chats"] } # Broadcast to the user's chat stream
  # Let's simplify for now and handle updates via controller Turbo responses maybe

  # Broadcast message creations/updates within *this* chat to the chat channel
  # This is used by the chat view to append new messages.
  broadcasts_to ->(chat) { [chat, "messages"] }, inserts_by: :append, target: "messages"

  private

  def set_default_title
    self.title ||= "New Chat #{Time.now.strftime('%Y-%m-%d %H:%M')}"
    # A better default might be set after the first message.
  end

  # Convenience method to get the system prompt, if any
  def system_message
    messages.find_by(role: :system)
  end
end
