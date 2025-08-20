class GenerateChatImageJob < ApplicationJob
  queue_as :default

  def perform(chat)
    # 1. Generate a prompt for the image generation model
    image_prompt_prompt = <<~PROMPT
      Based on the following chat conversation, please generate a concise, descriptive prompt for an image generation model.
      The prompt should capture the essence of the conversation.
      The prompt should be in English.
      The prompt should be a single sentence.
      The prompt should be no more than 20 words.

      Here is the chat conversation:
      #{chat.fancy_chat_messages}
    PROMPT

    # 2. Use a text model to generate the image prompt
    response = RubyLLM.chat.ask(image_prompt_prompt)
    image_prompt = response.content.strip

    # 3. Use an image model to generate the image
    #    (This is a placeholder, as I don't have access to a real image generation API)
    #    In a real application, you would use a library like `google-cloud-ai_platform`
    #    to call the Vertex AI image generation API.
    #
    #    For now, I will use a local image.
    chat.generated_image.attach(
      io: File.open(Rails.root.join('app', 'assets', 'images', 'rails8-gemini-cute.png')),
      filename: 'rails8-gemini-cute.png',
      content_type: 'image/png'
    )
  end
end
