# typed: false
class ChatsController < ApplicationController
  # https://stackoverflow.com/questions/40979186/using-dom-idobj-within-controller-to-set-variable
  # include ActionView::RecordIdentifier

  before_action :set_chats, only: [:index, :show] # Load chats list for sidebar
  before_action :set_chat, only: [:show, :edit, :update, :destroy, :generate_image, :delete_image, :regenerate_title, :generate_description, :im_feeling_lucky] # Load specific chat for actions

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
    default_model = RubyLLM.config.default_model # _id || 'gpt-4o-mini' # Fallback needed
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

  # GET /chats/:id/edit
  # Displays the form to edit an existing chat
  def edit
    # @chat is set by before_action
    # @chats is not strictly needed here unless your edit form also shows the sidebar
    # If you want the sidebar on the edit page, uncomment the next line:
    # set_chats
  end

  # PATCH/PUT /chats/:id
  # Updates an existing chat
  def update
    # @chat is set by before_action
    if @chat.update(chat_params)
      redirect_to @chat, notice: "✏️ Chat was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end
  # DELETE /chats/:id
  # Deletes a chat session
  def destroy
    # @chat is set by before_action
    @chat.destroy
    redirect_to chats_url, status: :see_other, notice: "🗑️ Chat session deleted."
  end

  def generate_image
    # @chat is set by before_action
    # In a real app, you'd enqueue a background job here
    # For simplicity, we'll call the service directly
    GenerateChatImageJob.perform_later(@chat)
    redirect_to @chat, notice: "🖼️ Image generation started. It will appear shortly."
  end

  def delete_image
    @chat.generated_image.purge
    redirect_to @chat, notice: "🗑️ Image deleted."
  end

  def regenerate_title
    @chat.autotitle_if_needed
    redirect_to @chat, notice: "🎨 Title regenerated!"
  end

  def generate_description
    @chat.generate_description
    redirect_to @chat, notice: "📝 Description generated!"
  end

  def im_feeling_lucky
    ImFeelingLuckyJob.perform_later(@chat)
    redirect_to @chat, notice: "✨ I'm feeling lucky! Updates are on the way."
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
  def chat_params
    params.require(:chat).permit(:title, :description, :model_id)
  end
end
