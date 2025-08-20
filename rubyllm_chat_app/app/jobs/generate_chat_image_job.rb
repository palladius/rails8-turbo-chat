class GenerateChatImageJob < ApplicationJob
  queue_as :default

  def perform(chat)
    if chat.generated_image.attached?
      Rails.logger.warn "📸 Chat #{chat.id} already has a generated image. Skipping."
      return
    end

    # 1. Generate a prompt for the image generation model
    image_prompt_prompt = <<~PROMPT
      Based on the following chat conversation, please generate a concise, descriptive prompt for an image generation model.
      The prompt should capture the essence of the conversation.
      The prompt should be in English.
      The prompt should be a single sentence.
      The prompt should be no more than 20 words.
      Also, ensure there's a ruby gem on the bottom right and a yellow heart emoji on the bottom left.

      Here is the chat conversation:
      #{chat.fancy_chat_messages}
    PROMPT

    # 2. Use a text model to generate the image prompt
    response = RubyLLM.chat.ask(image_prompt_prompt)
    image_prompt = response.content.strip

    Rails.logger.info "🎨 " + Rainbow("Image Prompt:").cyan + " #{image_prompt}"

    # 3. Use an image model to generate the image
    image = RubyLLM.paint(image_prompt, model: "imagen-3.0-generate-002")

    # 4. Save the image to a temporary file
    image_path = Rails.root.join('tmp', 'generated-image.png')
    image.save(image_path)
    Rails.logger.debug "Image saved to #{image_path}"

    # 5. Attach the image to the chat
    key = "#{Rails.env}/#{chat.id}/#{SecureRandom.uuid}.png"
    attachment = chat.generated_image.attach(io: File.open(image_path), filename: 'generated_image.png', content_type: 'image/png', key: key)
    Rails.logger.info "Attachment result: #{attachment.inspect}"
    Rails.logger.info "Blob inspect: #{chat.generated_image.blob.inspect}"
  ensure
    File.delete(image_path) if image_path && File.exist?(image_path)
  end
end
