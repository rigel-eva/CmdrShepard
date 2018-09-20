# frozen_string_literal: true

json.extract! twitch_chat_key, :id, :created_at, :updated_at
json.url twitch_chat_key_url(twitch_chat_key, format: :json)
