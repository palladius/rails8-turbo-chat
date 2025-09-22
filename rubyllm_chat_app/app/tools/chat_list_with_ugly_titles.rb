# frozen_string_literal: true

class ChatListWithUglyTitles < ApplicationTool
  description 'Get List of 🥴 UGLY Chat titles'

  def call
    Chat.all.select{|c| c.ugly_title? }.map do |chat| {
        id: chat.id,
        title: chat.title,
    } end.to_json
  end
end
