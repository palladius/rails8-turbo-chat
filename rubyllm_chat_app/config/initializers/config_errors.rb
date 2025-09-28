Rails.configuration.x.config_errors = []
Rails.configuration.x.config_warnings = []

# Check for GCS_CREDENTIALS_JSON
begin
  JSON.parse(ENV.fetch("GCS_CREDENTIALS_JSON"))
rescue KeyError
  Rails.configuration.x.config_warnings << "ENV[GCS_CREDENTIALS_JSON] environment variable not set. Upload to GCS might fail"
rescue JSON::ParserError
  Rails.configuration.x.config_warnings << "ENV[GCS_CREDENTIALS_JSON] is not a valid JSON. Upload to GCS might fail"
end

# Check for GCLOUD_REGION
if ENV["GCLOUD_REGION"].blank?
  Rails.configuration.x.config_warnings << "ENV['GCLOUD_REGION'] is not set. Deploy to Cloud Run might be impaired."
end

# Check for GEMINI_API_KEY
if ENV["GEMINI_API_KEY"].blank?
  Rails.configuration.x.config_errors << "ENV['GEMINI_API_KEY'] is not set. Gemini LLM might not work properly."
end

# Uncomment the next line just to test the system works fine :)
# Rails.configuration.x.config_errors << "ENV[TEST_ENV] is not set and its all right (just debugging)."
