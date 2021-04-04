class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    ActionCable.server.broadcast "room_channel_#{message.room_id}", message: render_message(message)
  end

  private
  def render_message(message)
    if message.user_id.present?
      ApplicationController.render_with_signed_in_user(user, 'messages/message', locals: { message: message })
    elsif message.stylist_id.present?
      ApplicationController.render_with_signed_in_user(stylist, 'messages/message', locals: { message: message })
    end
  end
end