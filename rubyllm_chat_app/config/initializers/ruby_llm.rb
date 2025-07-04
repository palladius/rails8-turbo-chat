# config/initializers/ruby_llm.rb
# Load ENV variables from .env file in development/test
Dotenv.load('.env') if defined?(Dotenv) && (Rails.env.development? || Rails.env.test?)

GEMINI_API_KEY = ENV.fetch('GEMINI_API_KEY', nil)
RICCARDOS_FAVOURITE_DEV_MODEL =  'gemini-2.0-flash'
#DEFAULT_LLM_MODEL = 'gemini-2.0-flash'
DEFAULT_LLM_MODEL = ENV.fetch('DEFAULT_LLM_MODEL', RICCARDOS_FAVOURITE_DEV_MODEL)

#raise "no gemini key sorry (GEMINI_API_KEY not set)" if GEMINI_API_KEY.nil?
puts "no gemini key sorry (GEMINI_API_KEY not set). I should fail but cloud build does NOT work itherwise so i close one eye. i believe this is in CB trigger ENV and will be in CR. Just .env doesnt exist" if GEMINI_API_KEY.nil?

RubyLLM.configure do |config|
  # Configure your preferred LLM provider here
  # Example for OpenAI:
  #config.provider = :openai
  config.gemini_api_key = GEMINI_API_KEY
  # ENV.fetch('GEMINI_API_KEY', 'YOUR_API_KEY_HERE') # Use ENV!

  # Example for Google GenAI (Vertex AI or AI Platform):
  # config.provider = :google_genai
  # config.api_key = ENV.fetch('GOOGLE_API_KEY', 'YOUR_API_KEY_HERE')
  # config.google_project_id = ENV.fetch('GOOGLE_PROJECT_ID', nil) # Optional but recommended for Vertex
  # config.google_region = ENV.fetch('GOOGLE_REGION', nil)       # Optional but recommended for Vertex

  # Set a default model (optional, but nice!)
  config.default_model = DEFAULT_LLM_MODEL
  # config.default_embedding_model = 'text-embedding-3-small'  # Default: 'text-embedding-3-small'
  # config.default_image_model = 'dall-e-3'            # Default: 'dall-e-3'

  # Add other configurations as needed
  Rails.logger.info "✅ RubyLLM Initialized with model: #{config.default_model}"
end

# Quick check to ensure API key is somewhat loaded (don't log the key itself!)
if RubyLLM.config.gemini_api_key.nil? # || RubyLLM.config.api_key == 'YOUR_API_KEY_HERE'
  Rails.logger.warn "⚠️ RubyLLM Warning: API Key is not set properly in ENV variables. Please check your .env file or environment configuration."
end

=begin

RubyLLM.models.chat_models.each do |model|
  puts "- #{model.id} (#{model.provider})" if model.provider =~ /gemini/
end ; nil

=>


- aqa (gemini)
- chat-bison-001 (gemini)
- embedding-gecko-001 (gemini)
- gemini-1.0-pro-vision-latest (gemini)
- gemini-1.5-flash (gemini)
- gemini-1.5-flash-001 (gemini)
- gemini-1.5-flash-001-tuning (gemini)
- gemini-1.5-flash-002 (gemini)
- gemini-1.5-flash-8b (gemini)
- gemini-1.5-flash-8b-001 (gemini)
- gemini-1.5-flash-8b-exp-0827 (gemini)
- gemini-1.5-flash-8b-exp-0924 (gemini)
- gemini-1.5-flash-8b-latest (gemini)
- gemini-1.5-flash-latest (gemini)
- gemini-1.5-pro (gemini)
- gemini-1.5-pro-001 (gemini)
- gemini-1.5-pro-002 (gemini)
- gemini-1.5-pro-latest (gemini)
- gemini-2.0-flash (gemini)
- gemini-2.0-flash-001 (gemini)
- gemini-2.0-flash-exp (gemini)
- gemini-2.0-flash-exp-image-generation (gemini)
- gemini-2.0-flash-lite (gemini)
- gemini-2.0-flash-lite-001 (gemini)
- gemini-2.0-flash-lite-preview (gemini)
- gemini-2.0-flash-lite-preview-02-05 (gemini)
- gemini-2.0-flash-live-001 (gemini)
- gemini-2.0-flash-preview-image-generation (gemini)
- gemini-2.0-flash-thinking-exp (gemini)
- gemini-2.0-flash-thinking-exp-01-21 (gemini)
- gemini-2.0-flash-thinking-exp-1219 (gemini)
- gemini-2.0-pro-exp (gemini)
- gemini-2.0-pro-exp-02-05 (gemini)
- gemini-2.5-flash-preview-04-17 (gemini)
- gemini-2.5-flash-preview-04-17-thinking (gemini)
- gemini-2.5-pro-exp-03-25 (gemini)
- gemini-2.5-pro-preview-03-25 (gemini)
- gemini-2.5-pro-preview-05-06 (gemini)
- gemini-embedding-exp (gemini)
- gemini-exp-1206 (gemini)
- gemini-pro-vision (gemini)
- gemma-3-12b-it (gemini)
- gemma-3-1b-it (gemini)
- gemma-3-27b-it (gemini)
- gemma-3-4b-it (gemini)
- learnlm-1.5-pro-experimental (gemini)
- learnlm-2.0-flash-experimental (gemini)
- text-bison-001 (gemini)
- veo-2.0-generate-001 (gemini)

=end

# Usage example:
# RubyLLM.chat.ask 'ciao'
# => #<RubyLLM::Message:0x000000012607d128
#  @content=#<RubyLLM::Content:0x0000000127ff73a0 @attachments=[], @text="Ciao! Come posso aiutarti oggi?\n">,
#  @input_tokens=1,
#  @model_id="gemini-2.0-flash",
#  @output_tokens=9,
#  @role=:assistant,
#  @tool_call_id=nil,
#  @tool_calls=nil>
# r = RubyLLM.chat.ask "What's in this image?", with: { image: "app/assets/images/rails8-gemini-cute.png" }
# puts r.content
# => The image features a red train with "RAILS 8" written on the front, traveling on a track through the sky. There's a robot with a yellow face and the word "AI" on its chest, standing on a cloud next to the train and pointing towards it. Above the train, there's a cloud with the words "Google Cloud" written on it, and a rainbow arching over the cloud. Another cloud below the robot has rainbow-colored streams coming out of it. The background is a light blue sky with other clouds scattered around. The robot has a speech bubble with "Gemini" written inside.
