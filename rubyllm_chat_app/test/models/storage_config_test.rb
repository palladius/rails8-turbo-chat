require "test_helper"

class StorageConfigTest < ActiveSupport::TestCase
  test "google storage service should not be public" do
    # Read storage config directly to inspect its raw values
    configs = YAML.load(ERB.new(File.read(Rails.root.join("config/storage.yml"))).result)
    google_config = configs["google"]
    
    assert_not_equal true, google_config["public"], "GCS Bucket should be secure and use signed URLs (not public: true)"
  end
end
