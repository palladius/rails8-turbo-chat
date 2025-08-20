# typed: false
class Chat < ApplicationRecord
  # Constant for the default title prefix
  DEFAULT_TITLE_PREFIX = "New Chat ".freeze

  # RubyLLM Integration
  acts_as_chat # Assumes Message and ToolCall model names

  # Standard Rails Model Logic
  has_one_attached :generated_image # , prefix: 'chats/generated_images' # not implemented see https://github.com/rails/rails/issues/32790
  has_many :messages, -> { order(created_at: :asc) }, dependent: :destroy # Ensure messages are ordered

  scope :with_attached_generated_image, -> { joins(:generated_image_attachment) }

  # Riccaredo this WONT work as its in PostgreS vincolo.
  #belongs_to :user, optional: true # Example

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


  def short_model_id = model_id.sub(/\Agemini-/, '')
  #end

  # Text persistence of them.
  def fancy_chat_messages =  messages.map{|m| "#{created_at} [#{m.role}]: #{m.content.chomp}"}.join("\n")
  #end

  def ugly_title?
    title.start_with?(DEFAULT_TITLE_PREFIX)
  end


  # Generates a title for the chat using an LLM if the current title is a default one
  # and the chat has more than 3 messages.
  def autotitle_if_needed
    # Condition 1: Title is still the default one (e.g., "New Chat ...")
    # Condition 2: Chat has enough history (more than 3 messages implies at least two turns)
    return unless title.start_with?(DEFAULT_TITLE_PREFIX) && messages.count >= 2

    Rails.logger.info "Attempting to auto-title chat #{id} (current title: '#{title}')..."

    # `chat_messages` (from acts_as_chat) provides the history in LLM-ready format
    current_chat_history = self.fancy_chat_messages

    title_generation_prompt = <<~PROMPT.strip
      Based on our conversation so far (the preceding messages), please suggest a concise and descriptive title for this chat.
      The title should be brief, ideally 5-7 words long.
      Output ONLY the title itself. Do not include any prefixes like "Title:", quotation marks, or any other explanatory text.
    PROMPT



    # Append the title generation request as a new "user" message
    #messages_for_llm = current_chat_history + [{ role: "user", content: title_generation_prompt }]

    begin
      #llm_client = self.to_llm # Get the LLM client configured for this chat's model
      #response = llm_client.chat(messages: messages_for_llm)

      titling_chat = RubyLLM.chat
      response = titling_chat.ask(title_generation_prompt + "\n\n" + current_chat_history)
      # DEBUG
      puts response.content
      suggested_title = response.content&.strip

      if suggested_title.present? && suggested_title.length > 2 && suggested_title.length <= 150 # Basic validation
        # Clean the title: remove potential "Title: " prefix and surrounding quotes
        cleaned_title = suggested_title.gsub(/^Title:\s*/i, '').gsub(/^["']+|["']+$/, '').strip

        if cleaned_title.present? && cleaned_title != self.title
          self.update(title: cleaned_title)
          Rails.logger.info "Chat #{self.id} successfully auto-titled to: '#{cleaned_title}'"
        else
          Rails.logger.info "Chat #{self.id} auto-titling: new title is blank, same as old, or invalid after cleaning. Original: '#{suggested_title}', Cleaned: '#{cleaned_title}'"
        end
      else
        Rails.logger.warn "Chat #{self.id} auto-titling: LLM returned empty, too short, or too long title. Raw response: '#{suggested_title}'"
      end
    rescue StandardError => e
      Rails.logger.error "Chat #{self.id} auto-titling failed due to LLM error: #{e.class.name} - #{e.message}"
      # Depending on your application's needs, you might want to re-raise or notify an error service.
    end
  end


  def self.autotitle_if_needed
    self.all.each do |chat|
      chat.autotitle_if_needed
    end
  end

  def attach_image(image_path)
    generated_image.attach(
      io: File.open(Rails.root.join(image_path)),
      filename: File.basename(image_path)
    )
  end

  private

  def set_default_title
    # Use the constant for consistency
    self.title ||= "#{DEFAULT_TITLE_PREFIX}#{Time.now.strftime('%Y-%m-%d %H:%M')}"
  end

  def set_gemini_model
    self.model_id ||= DEFAULT_LLM_MODEL
  end

  # Convenience method to get the system prompt, if any
  def system_message
    messages.find_by(role: :system)
  end



end
