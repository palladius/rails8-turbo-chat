#!/bin/bash

# sbrodola.sh - Generates the initial Rails 8 RubyLLM Chat App structure
# (v3 - Fixed cd logic, removed inline comments, removed colors lib)

PROJECT_NAME="rubyllm_chat_app"

echo "🚀 Creating Rails 8 project: $PROJECT_NAME"
echo "🔧 Using PostgreSQL and Tailwind CSS"

# Ensure Rails 8+ is installed (you might need to 'gem install rails' first)
rails new "$PROJECT_NAME" -d postgresql -c tailwind

# --- FIX: More robust cd into the project directory ---
echo "📂 Changing into project directory: $PROJECT_NAME"
cd "$PROJECT_NAME" || { echo "❌ ERROR: Failed to cd into project directory '$PROJECT_NAME'. Aborting."; exit 1; }
echo "✅ Successfully entered directory: $(pwd)"

echo "📦 Adding required gems..."
# --- FIX: Removed inline comment ---
bundle add devise ruby_llm dotenv-rails

echo "⚙️ Installing Devise..."
bundle exec rails generate devise:install

echo "👤 Generating Devise User model..."
bundle exec rails generate devise User

echo "➕ Adding custom fields and models via migrations..."
bundle exec rails generate migration AddNameToUsers name:text
bundle exec rails generate migration CreateChats user:references model_id:string title:string description:text
bundle exec rails generate migration CreateMessages chat:references{null:false,foreign_key:true} role:string content:text model_id:string input_tokens:integer output_tokens:integer tool_call:references
# Note: Using jsonb for arguments as requested and suggested by RubyLLM docs for PG
bundle exec rails generate migration CreateToolCalls message:references{null:false,foreign_key:true} tool_call_id:string{null:false,index: { unique: true }} name:string{null:false} arguments:jsonb

echo "🛠️ Modifying migrations..."
# Add default: {} to arguments in CreateToolCalls migration
# Use a loop to handle potential timing issues with file availability
TOOL_CALL_MIGRATION=""
for i in {1..5}; do
  TOOL_CALL_MIGRATION=$(ls db/migrate/*_create_tool_calls.rb 2>/dev/null)
  if [[ -n "$TOOL_CALL_MIGRATION" ]]; then
    echo "   Found migration: $TOOL_CALL_MIGRATION"
    break
  fi
  echo "   Waiting for migration file... ($i/5)"
  sleep 0.5
done

if [[ -z "$TOOL_CALL_MIGRATION" || ! -f "$TOOL_CALL_MIGRATION" ]]; then
   echo "⚠️ WARNING: Could not find CreateToolCalls migration file to modify."
else
   # Using simpler sed, hoping it works across platforms. Keep backup file (.bak) for safety.
   sed -i.bak '/t.jsonb :arguments/ s/$/, default: {}/' "$TOOL_CALL_MIGRATION"
   if [[ $? -eq 0 ]]; then
      echo "   Added default: {} to arguments:jsonb in $TOOL_CALL_MIGRATION"
      rm -f "${TOOL_CALL_MIGRATION}.bak" # Remove backup if sed succeeded
   else
      echo "⚠️ WARNING: Failed to automatically add default: {} to migration. Please check manually: $TOOL_CALL_MIGRATION"
   fi
fi


echo "🗄️ Setting up initial database..."
bundle exec rails db:create

echo "🏗️ Running initial migrations..."
bundle exec rails db:migrate

echo "🎨 Generating Devise views..."
bundle exec rails generate devise:views

echo "✨ Creating RubyLLM Initializer..."
mkdir -p config/initializers
# Use 'EOF' to prevent shell interpretation
cat <<'EOF' > config/initializers/ruby_llm.rb
# config/initializers/ruby_llm.rb
# Load ENV variables from .env file in development/test
Dotenv.load('.env') if defined?(Dotenv) && (Rails.env.development? || Rails.env.test?)

RubyLLM.configure do |config|
  # Configure your preferred LLM provider here
  # Example for OpenAI:
  config.provider = :openai
  config.api_key = ENV.fetch('OPENAI_API_KEY', 'YOUR_API_KEY_HERE') # Use ENV!

  # Example for Google GenAI (Vertex AI or AI Platform):
  # config.provider = :google_genai
  # config.api_key = ENV.fetch('GOOGLE_API_KEY', 'YOUR_API_KEY_HERE')
  # config.google_project_id = ENV.fetch('GOOGLE_PROJECT_ID', nil) # Optional but recommended for Vertex
  # config.google_region = ENV.fetch('GOOGLE_REGION', nil)       # Optional but recommended for Vertex

  # Set a default model (optional, but nice!)
  # config.default_model_id = 'gpt-4o-mini' # or 'gemini-1.5-flash-latest'
  # config.default_model_id = ENV.fetch('DEFAULT_LLM_MODEL', 'gpt-4o-mini')

  # Add other configurations as needed
  Rails.logger.info "✅ RubyLLM Initialized with provider: #{config.provider}"
end

# Quick check to ensure API key is somewhat loaded (don't log the key itself!)
if RubyLLM.config.api_key.nil? || RubyLLM.config.api_key == 'YOUR_API_KEY_HERE'
  Rails.logger.warn "⚠️ RubyLLM Warning: API Key is not set properly in ENV variables. Please check your .env file or environment configuration."
end
EOF

echo "🔑 Creating .env file for API keys (add your keys here!)..."
# Use 'EOF'
cat <<'EOF' > .env
# .env - Environment variables for development
# Add your actual API keys here!
# DO NOT COMMIT THIS FILE TO GIT! Add it to .gitignore

# Example for OpenAI
OPENAI_API_KEY=your_openai_api_key_goes_here

# Example for Google GenAI / Vertex AI
# GOOGLE_API_KEY=your_google_api_key_goes_here
# GOOGLE_PROJECT_ID=your-gcp-project-id
# GOOGLE_REGION=us-central1 # e.g., us-central1

# Optional: Default Model
# DEFAULT_LLM_MODEL=gpt-4o-mini # or gemini-1.5-flash-latest
EOF

echo "🔒 Adding .env to .gitignore..."
# Check if .gitignore exists, create if not, then append
if [[ ! -f .gitignore ]]; then
  touch .gitignore
fi
# Append only if not already present
grep -qxF '.env' .gitignore || echo ".env" >> .gitignore

echo "✍️ Configuring Models..."
# --- User Model ---
# Use 'EOF'
cat <<'EOF' > app/models/user.rb
# typed: false - Sorbet, if you use it later
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :chats, dependent: :destroy

  # Validations (Devise handles email/password, add one for name)
  validates :name, presence: true, length: { minimum: 2 }
end
EOF

# --- Chat Model ---
# Use 'EOF'
cat <<'EOF' > app/models/chat.rb
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
EOF

# --- Message Model ---
# Use 'EOF'
cat <<'EOF' > app/models/message.rb
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
  enum role: { system: "system", user: "user", assistant: "assistant", tool: "tool" }

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
EOF

# --- ToolCall Model ---
# Use 'EOF'
cat <<'EOF' > app/models/tool_call.rb
# typed: false
class ToolCall < ApplicationRecord
  # RubyLLM Integration
  acts_as_tool_call # Assumes Message model name

  # Standard Rails Model Logic
  belongs_to :message # The assistant message that initiated the call
  # Optional: Add association for the 'tool' role message containing the result
  # has_one :result_message, class_name: 'Message', foreign_key: 'tool_call_id', primary_key: 'id'

  # Validations
  validates :tool_call_id, presence: true, uniqueness: true
  validates :name, presence: true
  # arguments are jsonb, Rails handles validation implicitly to some extent
end
EOF

echo "🛠️ Generating Chat Stream Job..."
mkdir -p app/jobs
# Use 'EOF'
cat <<'EOF' > app/jobs/chat_stream_job.rb
# typed: false
class ChatStreamJob < ApplicationJob
  queue_as :default

  # Set default model if not provided by chat (fallback)
  DEFAULT_MODEL = ENV.fetch('DEFAULT_LLM_MODEL', 'gpt-4o-mini') # Or your preferred default

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
    chat.ask(user_content, model: model_to_use) do |chunk|
      # The assistant message record is created by `acts_as_chat` before this block runs.
      # Fetch it reliably (it should be the last message in the chat).
      assistant_message ||= chat.messages.assistant.last
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
EOF

echo "🧭 Defining Routes..."
# Use 'EOF'
cat <<'EOF' > config/routes.rb
# typed: false
Rails.application.routes.draw do
  # Devise routes for authentication
  devise_for :users

  # Root path - directs to the main chat interface
  root "chats#index"

  # Chat resources - index shows list, show displays a chat, create starts a new one
  resources :chats, only: [:index, :show, :create, :destroy] do
    # Nested resource for messages within a specific chat
    # Only need 'create' as messages are added to an existing chat context
    resources :messages, only: [:create], shallow: true # shallow makes message paths like /messages/:id instead of /chats/:chat_id/messages/:id
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
EOF

echo "🕹️ Creating Controllers..."
mkdir -p app/controllers
# --- Application Controller ---
# Use 'EOF'
cat <<'EOF' > app/controllers/application_controller.rb
# typed: false
class ApplicationController < ActionController::Base
  # Ensure user is logged in for all actions (except Devise controllers)
  before_action :authenticate_user!
  # Add 'name' to permitted Devise parameters
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # Allow 'name' parameter during sign_up and account_update
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
EOF

# --- Chats Controller ---
# Use 'EOF'
cat <<'EOF' > app/controllers/chats_controller.rb
# typed: false
class ChatsController < ApplicationController
  before_action :set_chats, only: [:index, :show] # Load chats list for sidebar
  before_action :set_chat, only: [:show, :destroy] # Load specific chat for actions

  # GET /chats or root_path
  # Displays the list of chats and potentially the first/last active chat
  def index
    # @chats is set by before_action
    # Optionally select the first chat to display, or handle empty state
    @chat = @chats.last # Show the most recent chat by default
    if @chat
      @messages = @chat.messages.order(created_at: :asc)
    else
      @messages = [] # No messages if no chat selected
    end
    # Render 'show' template which includes the layout with sidebar and chat window
    render :show
  end

  # GET /chats/:id
  # Displays a specific chat
  def show
    # @chat and @chats are set by before_action
    @messages = @chat.messages.order(created_at: :asc)
    # Render the 'show' view, which handles displaying @chat and @messages
  end

  # POST /chats
  # Creates a new chat session
  def create
    # Use a default model from config or allow selection via params later
    default_model = RubyLLM.config.default_model_id || 'gpt-4o-mini' # Fallback needed
    @chat = current_user.chats.build(
      title: params.dig(:chat, :title) || "New Chat #{Time.now.to_i}", # Simple default title
      description: params.dig(:chat, :description),
      model_id: params.dig(:chat, :model_id) || default_model # Use default/param
    )

    if @chat.save
      # Maybe add an initial system message if provided?
      # if params.dig(:chat, :system_prompt).present?
      #   @chat.with_instructions(params[:chat][:system_prompt])
      # end
      redirect_to @chat, notice: "✨ Chat session created!"
    else
      # If save fails, re-render index/show with errors
      set_chats # Reload chats for the sidebar
      @messages = [] # Ensure messages is empty array for render
      flash.now[:alert] = "🚨 Couldn't create chat: #{@chat.errors.full_messages.join(', ')}"
      render :show, status: :unprocessable_entity # Render the main view with errors
    end
  end

  # DELETE /chats/:id
  # Deletes a chat session
  def destroy
    # @chat is set by before_action
    @chat.destroy
    redirect_to chats_url, status: :see_other, notice: "🗑️ Chat session deleted."
  end

  private

  # Load the current user's chats for the sidebar list
  def set_chats
    @chats = current_user.chats.order(updated_at: :desc)
  end

  # Find the specific chat belonging to the current user
  def set_chat
    @chat = current_user.chats.find_by(id: params[:id])
    unless @chat
       redirect_to chats_path, alert: "🚫 Chat not found or you don't have access."
    end
  end

  # Strong parameters for creating/updating chats (if needed later)
  # def chat_params
  #   params.require(:chat).permit(:title, :description, :model_id)
  # end
end
EOF

# --- Messages Controller ---
# Use 'EOF'
cat <<'EOF' > app/controllers/messages_controller.rb
# typed: false
class MessagesController < ApplicationController
  before_action :set_chat

  # POST /chats/:chat_id/messages
  def create
    user_content = params.dig(:message, :content)

    if user_content.blank?
      # Respond with Turbo Stream to show an error, or just ignore?
      respond_to do |format|
        format.turbo_stream {
          render turbo_stream: turbo_stream.append("messages", html: "<div class='text-red-500 p-2'>Message content cannot be blank!</div>")
        }
        format.html { redirect_to @chat, alert: "Message content cannot be blank!" }
      end
      return
    end

    # Enqueue the background job to handle the LLM interaction and streaming
    # We pass the chat ID and the user's message content.
    # The job will handle creating the user message and the assistant's response.
    ChatStreamJob.perform_later(@chat.id, user_content)

    # Respond immediately to the user. The UI will update via Turbo Streams
    # broadcast from the job/model.
    respond_to do |format|
      # Sending :ok is fine, but redirecting back ensures the URL is clean if JS is off.
      # Turbo handles this gracefully. The form might clear itself via JS stimulus controller later.
      # format.html { redirect_to @chat } # Redirect back to the chat view
      # We can just render an empty stream response or head :ok as the form submission
      # will be followed by Turbo Stream updates broadcast from the model/job.
      format.turbo_stream { head :ok } # Acknowledge receipt, streams will update UI
      format.html { redirect_to @chat } # Fallback for non-turbo
    end

  rescue ActiveRecord::RecordNotFound
     redirect_to chats_path, alert: "🚫 Chat not found."
  rescue => e
     Rails.logger.error "🔥 Message creation failed: #{e.message}"
     redirect_to @chat || chats_path, alert: "🚨 Failed to send message: #{e.message}"
  end

  private

  def set_chat
    # Messages are nested under chats, so :chat_id should be present
    @chat = current_user.chats.find(params[:chat_id])
  end

  # Strong parameters for message (we only really need content from the form)
  # def message_params
  #   params.require(:message).permit(:content)
  # end
end
EOF

echo "🖼️ Creating Views..."
mkdir -p app/views/chats app/views/messages app/views/layouts

# --- Layout: application.html.erb ---
# Use 'EOF'
cat <<'EOF' > app/views/layouts/application.html.erb
<!DOCTYPE html>
<html>
<head>
  <title>RubyLLM Chat ✨</title>
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <%= csrf_meta_tags %>
  <%= csp_meta_tag %>
  <%= action_cable_meta_tag %> <%# Required for Turbo Streams over Action Cable %>

  <%= stylesheet_link_tag "tailwind", "inter-font", "data-turbo-track": "reload" %>
  <%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
  <%= javascript_importmap_tags %>
</head>
<body class="bg-gray-100 font-sans">
  <main class="container mx-auto mt-4 px-4">
    <%# Flash Messages - Tailored for Tailwind %>
    <% if notice %>
      <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative mb-4" role="alert">
        <span class="block sm:inline"><%= notice %></span>
      </div>
    <% end %>
    <% if alert %>
      <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4" role="alert">
        <span class="block sm:inline"><%= alert %></span>
      </div>
    <% end %>

    <%# Render Devise links if needed %>
    <div class="flex justify-end space-x-4 mb-4">
      <% if user_signed_in? %>
        <span class="text-gray-700">👋 Hello, <%= current_user.name %>!</span>
        <%= link_to "Edit Profile", edit_user_registration_path, class: "text-blue-600 hover:underline" %>
        <%= button_to "Sign Out", destroy_user_session_path, method: :delete, class: "bg-red-500 hover:bg-red-600 text-white font-bold py-1 px-3 rounded text-sm" %>
      <% else %>
        <%= link_to "Sign Up", new_user_registration_path, class: "text-blue-600 hover:underline" %>
        <%= link_to "Sign In", new_user_session_path, class: "text-blue-600 hover:underline" %>
      <% end %>
    </div>

    <%# Main content yield %>
    <%= yield %>
  </main>
</body>
</html>
EOF

# --- View: chats/show.html.erb (Main Interface) ---
# Use 'EOF'
cat <<'EOF' > app/views/chats/show.html.erb
<%# Main container using Flexbox for two columns %>
<div class="flex h-[calc(100vh-150px)] border border-gray-300 rounded-lg bg-white shadow-md overflow-hidden">

  <%# Left Pane: Chat List Sidebar %>
  <div id="chats-list" class="w-1/4 border-r border-gray-300 overflow-y-auto p-4 bg-gray-50">
    <h2 class="text-lg font-semibold mb-4 text-gray-700">My Chats 💬</h2>

    <%# Button/Form to create a new chat %>
    <%= form_with(model: Chat.new, url: chats_path, method: :post, class: "mb-4") do |f| %>
      <%# You could add fields for title/description/model here if desired %>
      <%# Example: f.text_field :title, placeholder: "Optional Title", class: "..." %>
      <%= f.submit "✨ Start New Chat", class: "w-full bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 px-4 rounded cursor-pointer" %>
    <% end %>


    <%# List of existing chats - Render the partial for each chat %>
    <div id="user-chats"> <%# A target for potential Turbo Stream updates to the list %>
      <% if @chats.any? %>
        <% @chats.each do |chat_item| %>
          <%= render partial: "chats/chat_link", locals: { chat_item: chat_item, current_chat: @chat } %>
        <% end %>
      <% else %>
        <p class="text-gray-500 italic">No chats yet. Start a new one!</p>
      <% end %>
    </div>
  </div>

  <%# Right Pane: Chat Window %>
  <div class="w-3/4 flex flex-col">
    <% if @chat %>
      <%# Connect to Turbo Stream for this specific chat's messages %>
      <%= turbo_stream_from [@chat, "messages"] %>

      <%# Chat Header (Title/Description/Actions) %>
      <div class="p-4 border-b border-gray-300 bg-white flex justify-between items-center">
        <div>
          <h1 class="text-xl font-semibold text-gray-800"><%= @chat.title %></h1>
          <% if @chat.description.present? %>
            <p class="text-sm text-gray-500"><%= @chat.description %></p>
          <% end %>
           <p class="text-xs text-gray-400">Model: <%= @chat.model_id %></p>
        </div>
        <div>
            <%= button_to "Delete Chat", chat_path(@chat), method: :delete, form: { data: { turbo_confirm: "Are you sure you want to delete this chat?" } }, class: "text-red-500 hover:text-red-700 text-sm font-medium" %>
        </div>
      </div>

      <%# Messages Area - Use flex-grow to take available space, overflow-y-auto for scrolling %>
      <div id="messages" class="flex-grow overflow-y-auto p-4 space-y-4 bg-gray-50">
        <%# Render existing messages using the message partial %>
        <%= render @messages %>
        <%# New messages will be appended here by Turbo Streams %>
      </div>

      <%# Input Area Form %>
      <div class="p-4 border-t border-gray-300 bg-white">
        <%= form_with(model: [@chat, Message.new], url: chat_messages_path(@chat), method: :post, class: "flex items-center space-x-2") do |f| %>
          <%= f.text_area :content,
                placeholder: "Ask anything...",
                class: "flex-grow border border-gray-300 rounded-md p-2 focus:outline-none focus:ring-2 focus:ring-blue-500 resize-none",
                rows: 2,
                data: { controller: 'textarea-autogrow' } %> <%# Optional: Stimulus for auto-resizing %>
          <%= f.submit "Send 🚀", class: "bg-green-500 hover:bg-green-600 text-white font-bold py-2 px-4 rounded cursor-pointer" %>
        <% end %>
      </div>

    <% else %>
      <%# Placeholder when no chat is selected %>
      <div class="flex-grow flex items-center justify-center p-4 text-gray-500">
        <p>Select a chat from the left or start a new one! 🎉</p>
      </div>
    <% end %>
  </div>

</div>
EOF

# --- Partial: chats/_chat_link.html.erb (for sidebar) ---
# Use 'EOF'
cat <<'EOF' > app/views/chats/_chat_link.html.erb
<%# Link to a chat in the sidebar list %>
<%# Use chat_item for the chat in the loop, current_chat for the currently displayed chat %>
<% is_current = current_chat && chat_item.id == current_chat.id %>
<%= link_to chat_path(chat_item), class: "block p-3 rounded-md hover:bg-gray-200 #{is_current ? 'bg-blue-100 font-semibold text-blue-800' : 'text-gray-700'}", data: { turbo_frame: "_top" } do %>
  <div class="truncate font-medium"><%= chat_item.title %></div>
  <div class="text-xs text-gray-500 truncate"><%= chat_item.description.presence || "No description" %></div>
  <div class="text-xs text-gray-400">Updated: <%= time_ago_in_words(chat_item.updated_at) %> ago</div>
<% end %>

<%# We can wrap this in a turbo_frame_tag if we want to update links individually %>
<%# turbo_frame_tag dom_id(chat_item) do ... end %>
EOF


# --- Partial: messages/_message.html.erb ---
# Use 'EOF'
cat <<'EOF' > app/views/messages/_message.html.erb
<%# Renders a single message, used for both initial load and Turbo Streams %>
<%# Use Turbo Frame for potential targeted updates later, and required by streaming approach %>
<%= turbo_frame_tag message do %>
  <%# Basic styling based on role %>
  <% role_class = case message.role
                  when "user"
                    "bg-blue-100 text-blue-900 self-end ml-10" # User messages on the right
                  when "assistant"
                    "bg-green-100 text-green-900 self-start mr-10" # Assistant messages on the left
                  when "system"
                    "bg-gray-200 text-gray-600 text-xs italic mx-auto my-2" # System messages centered/subtle
                  when "tool"
                     "bg-yellow-100 text-yellow-800 text-xs italic self-start mr-10" # Tool results distinct
                  else
                    "bg-gray-100 text-gray-800 self-start mr-10"
                  end
  %>
  <div class="message <%= message.role %> <%= role_class %> rounded-lg p-3 shadow-sm max-w-xl">
    <% unless message.system? %> <%# Don't show role label for system messages %>
       <strong class="block text-sm capitalize mb-1">
        <%= message.role == 'assistant' ? '🤖 Assistant' : (message.role == 'user' ? '👤 You' : message.role.capitalize) %>:
      </strong>
    <% end %>

    <%# The crucial div for streaming content. ID MUST match the broadcast target %>
    <%# Use simple_format for basic line breaks, or consider a Markdown renderer gem %>
    <div id="<%= dom_id(message, :content) %>" class="prose prose-sm max-w-none break-words">
       <%# Render initial content. Streaming will append here. %>
       <%= simple_format(message.content) %>
    </div>
  </div>
<% end %>

<%# Ensure the message partial itself doesn't add extra outer divs if already inside #messages container %>
EOF

echo "💅 Adding basic CSS for messages layout..."
# Add some CSS to application.tailwind.css if needed, though Tailwind classes handle most of it.
# Let's ensure the messages div allows flex layout for alignment.
mkdir -p app/assets/stylesheets
# Use 'EOF'
cat <<'EOF' >> app/assets/stylesheets/application.tailwind.css

/* Add custom styles or Tailwind @apply directives here */
#messages {
  display: flex;
  flex-direction: column;
  gap: 0.75rem; /* Add space between messages */
}

/* Ensure prose styles work well within message bubbles */
.message .prose {
  /* Customize prose styles if needed, e.g., smaller font */
}
EOF

# --- REMOVED Color Library and Autoloading ---

echo "✅ All files created successfully inside '$PROJECT_NAME'!"
echo "➡️ Next Steps:"
echo "1.  Ensure you are inside the '$PROJECT_NAME' directory. If not: cd $PROJECT_NAME"
echo "2.  Review the generated files, especially:"
echo "    - '.env' (Add your ACTUAL API keys!)"
echo "    - 'config/initializers/ruby_llm.rb' (Verify provider/key loading)"
echo "    - 'app/models/*' (Check associations, acts_as helpers)"
echo "    - 'app/jobs/chat_stream_job.rb' (Review the streaming logic)"
echo "    - 'app/views/' (Check Tailwind classes and Turbo setup)"
echo "3.  Ensure PostgreSQL is running."
echo "4.  Run 'bundle install' (maybe not needed if 'bundle add' succeeded, but good practice)."
echo "5.  Run 'rails db:migrate' (if you haven't already or made changes)."
echo "6.  Start your background job processor (Rails default is async inline, ok for dev. For production use Sidekiq/GoodJob etc.)."
echo "    If using async (default): Just run the rails server."
echo "    If using Sidekiq (example): bundle exec sidekiq -q default"
echo "7.  Start the Rails server: 'bin/rails server'"
echo "8.  Open your browser to http://localhost:3000"
echo "9.  Sign up for a new user account."
echo "10. Start chatting! 🎉"
