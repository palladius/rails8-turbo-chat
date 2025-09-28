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
u.save

# WWhen everything else fails
u ||= User.first

raise "Missing User, I can't do anything." if u.blank?

c = Chat.create user_id: u.id, title: "What is rake db:seed?", public: true, description: "A fake chat to demonstrate the app created by rake db:seed"
c.save

m = Message.create chat: c, role: "user", content: "Why would I use rake db:seed? Give me a few examples explaining it with furry animals"
m.save

c.ask "Why would I use rake db:seed? Give me a few examples explaining it with furry animals"

ChatStreamJob.perform_later(c.id, "Why would I use ActiveJob?")

GenerateChatImageJob.perform_later(c)
