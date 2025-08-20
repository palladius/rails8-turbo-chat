class ChatCardsController < ApplicationController
  def index
    @chats = Chat.all.order(updated_at: :desc)
  end
end