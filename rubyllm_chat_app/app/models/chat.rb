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
  before_validation :set_gemini_model, on: :create

  # Turbo Stream Broadcasting for the chat list (when a chat is created/deleted)
  # broadcasts_to ->(chat) { [chat.user, "chats"] } # Broadcast to the user's chat stream
  # Let's simplify for now and handle updates via controller Turbo responses maybe

  # Broadcast message creations/updates within *this* chat to the chat channel
  # This is used by the chat view to append new messages.
  broadcasts_to ->(chat) { [chat, "messages"] }, inserts_by: :append, target: "messages"

  # fix this code
  # def ask(message, &)
  #   puts("🐒🔧 Riccardo monkeypatching ask() - TODO for now its the same code")
  #   message = { role: :user, content: message }
  #   messages.create!(**message)
  #   to_llm.complete(&)
  # end

    def ask2(message='How are you, Douglas?', &)
    puts("🐒🔧 Riccardo monkeypatching Chat.. TODO ask2(msg='#{message}')")
    begin
      ask(message, &)
    rescue  RubyLLM::BadRequestError => e
      if e =~ /Unable to submit request because it has an empty text parameter. Add a value to the parameter and try again/
        pry
        puts("Smells like Gemini error.")
      else
        puts("RubyLLM::BadRequestError but not my Gemini known error..")
      end
    rescue Exception => e
      puts("[ask2] Some error (#{e}) (class = #{e.class}) with ask: #{$!}")

    ensure
      puts('Qui magari faccio pulizia..')
    end
  end

  # CITIN propoosal: https://github.com/crmne/ruby_llm/issues/118
  # on_new_message { build_new_message }

  # def build_new_message
  #   @message = messages.build(
  #     role: :assistant,
  #     content: String.new
  #   )
  # end
  # /CITIN propoosal: https://github.com/crmne/ruby_llm/issues/118



  private

  def set_default_title
    self.title ||= "New Chat #{Time.now.strftime('%Y-%m-%d %H:%M')}"
    # A better default might be set after the first message.
  end

  def set_gemini_model
    self.model_id ||= DEFAULT_LLM_MODEL
  end

  # Convenience method to get the system prompt, if any
  def system_message
    messages.find_by(role: :system)
  end



end
