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
