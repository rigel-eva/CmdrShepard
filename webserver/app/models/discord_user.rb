# frozen_string_literal: true

class DiscordUser < ApplicationRecord
  belongs_to :user
  def mention
    "<@#{uid}> "
  end
  class << self
      def from_discord_rb(user)
        get_discord_user_from_uid(user.id)
      end

      def find_user_from_chat(text_content)
        uid = text_content.match(/<@\d+>/)
        get_discord_user_from_uid(uid)
      end

      def get_discord_user_from_uid(uid)
        discord_user = DiscordUser.find_or_create_by(uid: uid)
        discord_user.user = User.from_third_party(discord_user.user_id)
        discord_user.save!
      end
  end
end
