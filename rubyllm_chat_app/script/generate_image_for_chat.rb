#!/usr/bin/env ruby

chat_id = ARGV.first
unless chat_id
  puts "Usage: rails runner script/generate_image_for_chat.rb <chat_id>"
  exit 1
end

chat = Chat.find_by(id: chat_id)
if chat
  puts "Found chat ##{chat.id}. Generating image..."
  GenerateChatImageJob.perform_now(chat)
  puts "Image generation complete for chat ##{chat.id}."
  puts "Chat image URL: #{chat.generated_image.url}"
else
  puts "Could not find chat with ID #{chat_id}."
  exit 1
end
