# frozen_string_literal: true

class TwitchUser < ApplicationRecord
  belongs_to :user
  has_one :twitch_chat_key
  def mention
    "@#{name}"
  end
  class << self
      def find_or_create_by_uid(uid)
        twitch_user = TwitchUser.find_or_create_by(uid: uid)
        user = User.from_third_party(twitch_user.user_id)
        # add code for finding this from endpoints
        user_data = JSON.parse(RestClient.get("https://api.twitch.tv/helix/users", "params" => { id: uid }, \
                                             "client-ID" => ENV["TWITCH_KEY"]))["data"][0]
        twitch_user.name = user_data["login"]
        twitch_user.icon = user_data["profile_image_url"]
        twitch_user.user_id = user.id
        twitch_user.save!
        twitch_user
      end

      def find_or_create_by_name(name)
        twitch_user = TwitchUser.find_or_create_by(name: name)
        user = User.from_third_party(twitch_user.user_id)
        user_data = JSON.parse(RestClient.get("https://api.twitch.tv/helix/users", "params" => { login: name }, \
                                             "client-ID" => ENV["TWITCH_KEY"]))["data"][0]
        twitch_user.id = user_data["id"]
        twitch_user.name = user_data["login"]
        twitch_user.icon = user_data["profile_image_url"]
        twitch_user.user_id = user.id
        twitch_user.save!
        twitch_user
      end

      def find_user_from_chat(info)
        find_or_create_by_name(info)
      end
  end
end
