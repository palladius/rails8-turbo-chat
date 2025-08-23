Rails.configuration.x.config_errors = []

# Check for GCS_CREDENTIALS_JSON
begin
  JSON.parse(ENV.fetch("GCS_CREDENTIALS_JSON"))
rescue KeyError
  Rails.configuration.x.config_errors << "🌱 ENV[GCS_CREDENTIALS_JSON] environment variable not set."
rescue JSON::ParserError
  Rails.configuration.x.config_errors << "🌱 ENV[GCS_CREDENTIALS_JSON] is not a valid JSON."
end

# Rails.configuration.x.config_errors << "🌱 ENV[TEST_ENV] is not set."
