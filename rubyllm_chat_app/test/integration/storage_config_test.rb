require "test_helper"
require "yaml"
require "erb"

class StorageConfigTest < ActiveSupport::TestCase
  test "google storage service is not public" do
    yaml_content = File.read(Rails.root.join("config", "storage.yml"))
    parsed_yaml = ERB.new(yaml_content).result
    storage_config = YAML.safe_load(parsed_yaml, aliases: true)
    
    google_config = storage_config["google"]
    assert_not google_config["public"], "Expected google GCS bucket to not be public, but it was set to true"
  end

  test "storage.yml handles multiline GCS_CREDENTIALS_JSON correctly" do
    multiline_json = <<~JSON
      {
        "type": "service_account",
        "project_id": "test-project",
        "private_key_id": "test-key-id"
      }
    JSON
    
    ENV["GCS_CREDENTIALS_JSON"] = multiline_json
    ENV["PROJECT_ID"] = "test-project"
    ENV["GCS_BUCKET"] = "test-bucket"

    yaml_path = Rails.root.join("config", "storage.yml")
    erb_result = ERB.new(File.read(yaml_path)).result

    begin
      credentials_lines = erb_result.lines.select { |l| l.include?("credentials:") || l.include?("\"type\":") }
      
      # The credentials must be fully contained on a single line in the rendered YAML
      # This matches the requirement: "GCS_CREDENTIALS_JSON should be only in one line"
      credentials_line = erb_result.lines.find { |l| l.match?(/^\s*credentials:/) }
      assert credentials_line.match?(/credentials:\s*\{.*\}$/), "credentials JSON must be rendered on a single line, but it spanned multiple lines: #{credentials_line.inspect}"

      parsed_yaml = YAML.safe_load(erb_result, aliases: true)
      
      assert_not_nil parsed_yaml["google"]
      
      if parsed_yaml["google"]["credentials"].is_a?(String)
        credentials_hash = JSON.parse(parsed_yaml["google"]["credentials"])
        assert_equal "service_account", credentials_hash["type"]
      else
        assert_equal "service_account", parsed_yaml["google"]["credentials"]["type"]
      end
    rescue Psych::SyntaxError => e
      flunk "YAML syntax error when parsing storage.yml with multiline GCS_CREDENTIALS_JSON: #{e.message}"
    ensure
      ENV.delete("GCS_CREDENTIALS_JSON")
      ENV.delete("PROJECT_ID")
      ENV.delete("GCS_BUCKET")
    end
  end
end
