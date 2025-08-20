# A script to find a working image generation model from Google Gemini.
#
# Usage:
#
#   rails runner script/find_image_model.rb
#
# It will iterate through all Google Gemini models, attempt to generate an
# image with each, and log the results to tmp/gemini-models/
#
require "ruby_llm"
require "fileutils"

# Create a directory to store the logs
log_dir = Rails.root.join("tmp", "gemini-models")
FileUtils.mkdir_p(log_dir)

# Your sample prompt
sample_prompt = "A cute robot writing Ruby code on a laptop, with the Ruby logo visible on the screen."

puts "Searching for a working image generation model from Google Gemini..."

# Get all Google Gemini models
google_gemini_models = RubyLLM.models.select { |m| m.id.start_with?("google/gemini") }

# Iterate through the models and try to generate an image
google_gemini_models.each do |model|
  model_id = model.id.gsub("google/", "")
  log_file = log_dir.join("#{model_id.gsub('/', '_')}.log")
  File.open(log_file, "w") do |f|
    f.puts "Testing model: #{model_id}"
    f.puts "Attempting to generate image with prompt: '#{sample_prompt}'..."
    begin
      image = RubyLLM.paint(sample_prompt, model: model_id, provider: :gemini)

      # Save the image to a file
      if image.save(log_dir.join("#{model_id.gsub('/', '_')}.png"))
        f.puts "Image successfully saved to #{log_dir.join("#{model_id.gsub('/', '_')}.png")}"
        puts "Success! Image generated with model: #{model_id}"
        exit
      else
        f.puts "Error: Could not save the image."
      end
    rescue => e
      f.puts "An error occurred during image generation: #{e.message}"
      f.puts e.backtrace.join("\n")
    end
  end
end

puts "No working image generation model found."