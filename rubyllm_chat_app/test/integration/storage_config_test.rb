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
end
