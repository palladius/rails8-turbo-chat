# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

raise "Missing Gemini API key, I can't do anything." if ENV["GEMINI_API_KEY"].blank?

u = User.create email: "fake-person@example.com", password: "not-This-vai-tranquillo", name: "Fake Person"

if ENV["PLAYWRIGHT_USERNAME"].present? && ENV["PLAYWRIGHT_PASSWORD"].present?
  PLAYWRIGHT_USERNAME = ENV["PLAYWRIGHT_USERNAME"]
  PLAYWRIGHT_PASSWORD = ENV["PLAYWRIGHT_PASSWORD"]
  playwright_user = User.find_or_create_by(email: PLAYWRIGHT_USERNAME) do |user|
    user.password = PLAYWRIGHT_PASSWORD
    user.name = "Playwright User for testing"
  end
end

# When everything else fails
u = User.first unless u.persisted?

raise "Missing User, I can't do anything." unless u&.persisted?


WORKSHOP_ENVIRONMENT = ENV["WORKSHOP_ENVIRONMENT"] || "unknown"

animal = case WORKSHOP_ENVIRONMENT
when "cloud_run" # not covered anywhere, yet, but nice to have
  "fox"
when "dot_env"
  "carnivorous plant"
when "cloud_build"
  "cat"
when "docker_compose"
  "dog"
when "unknown"
  "puffin"
else
  "hamster"
end

# Create a chat where there's a different animal per env.
c = Chat.create user_id: u.id, title: "[#{WORKSHOP_ENVIRONMENT}] What is rake db:seed?", public: true, description: "
  A forest full of furry animals and in front a huge big blue #{animal}
"

m = Message.create chat: c, role: "user", content: "Why would I use rake db:seed? Give me a few examples explaining it with furry animals"

#c.ask "Why would I use rake db:seed? Give me a few examples explaining it with furry animals"

#ChatStreamJob.perform_now(c.id, "Why would I use ActiveJob?")

GenerateChatImageJob.perform_now(c)
