# frozen_string_literal: true

class TwitchChatKey < ApplicationRecord
  belongs_to :user
  def mention
    "@#{name}"
  end
  class<<self
      def setupKey(auth_hash, session = nil)
        unless session.nil?
          # Ok if we got to this point we are assuming that the user already has associated a twitch account with the program
          twitch_chat_key = TwitchChatKey.find_or_create_by(uid: auth_hash['uid'])
          twitch_chat_key.user = User.find_or_create_by(id: session[:user_id])
          twitch_chat_key.name = auth_hash.info['name']
          twitch_chat_key.token = auth_hash.credentials['token']
          twitch_chat_key.enabled = false
          twitch_chat_key.targetChannels.push(twitch_chat_key.user.twitch_user.name)
          twitch_chat_key.save!
          return twitch_chat_key.user
        end
        nil
      end
  end
end
