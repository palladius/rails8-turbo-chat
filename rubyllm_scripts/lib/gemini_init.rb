require 'ruby_llm'

puts '[gemini_init] Configuring RubyLLM to use Gemini...'

RubyLLM.configure do |config|
  # https://rubyllm.com/configuration/
  config.default_model = 'gemini-2.5-flash'  # For RubyLLM.chat
  #config.default_embedding_model = 'text-embedding-3-large'  # For RubyLLM.embed
  config.default_image_model = "imagen-3.0-generate-002"

  # Add keys ONLY for the providers you intend to use.
  # Using environment variables is highly recommended.
  #config.openai_api_key = ENV.fetch('OPENAI_API_KEY', nil)
  # config.anthropic_api_key = ENV.fetch('ANTHROPIC_API_KEY', nil)
  config.gemini_api_key = ENV.fetch('GEMINI_API_KEY') # , nil)
  #puts("[DEB] Gemini API Key: #{config.gemini_api_key}")

  # imagen model model: "imagen-3.0-generate-002"
  #   image_blob = image.to_blob

  # # Now you can use image_blob, e.g., upload to S3, process with MiniMagick, etc.
  # puts "Image blob size: #{image_blob.bytesize} bytes"
end
