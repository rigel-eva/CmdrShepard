class TwitchUser < ApplicationRecord
    belongs_to :user
    has_one :twitch_chat_key
end
