# typed: false
class MessagesController < ApplicationController
  # https://stackoverflow.com/questions/40979186/using-dom-idobj-within-controller-to-set-variable
  include ActionView::RecordIdentifier

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
