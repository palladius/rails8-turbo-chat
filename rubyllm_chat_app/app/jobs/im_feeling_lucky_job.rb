class ImFeelingLuckyJob < ApplicationJob
  queue_as :default

  def perform(chat)
    # Broadcast the notice to the chat
    chat.broadcast_prepend_to [chat, "messages"],
                              partial: "chats/im_feeling_lucky_notice",
                              target: "messages"
    # Ensure chat has enough messages
    return unless chat.messages.count >= 2

    # 1. Generate Image if it doesn't exist. This is already a background job.
    GenerateChatImageJob.perform_later(chat) unless chat.generated_image.attached?

    # 2. Autotitle if needed. This is a synchronous LLM call within the job.
    chat.autotitle_if_needed if chat.ugly_title?

    # 3. Generate description if needed.
    # Reload the chat to get the updated title from the previous step.
    chat.reload
    if !chat.ugly_title? && chat.description.blank?
      chat.generate_description
    end
  end
end
