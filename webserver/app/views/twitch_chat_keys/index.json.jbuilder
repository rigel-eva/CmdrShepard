# frozen_string_literal: true

json.array! @twitch_chat_keys, partial: 'twitch_chat_keys/twitch_chat_key', as: :twitch_chat_key
