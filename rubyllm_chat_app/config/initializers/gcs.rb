# This should eb the logic if env is not found.
if ENV['GCS_BUCKET'].blank? && ENV['PROJECT_ID'].present?
  ENV['GCS_BUCKET'] = "#{ENV['PROJECT_ID']}-rails8turbochat-assets"
  puts "✅ ENV[GCS_BUCKET] was not set, so I set it to '#{ENV['GCS_BUCKET']}'"
end
