# frozen_string_literal: true

class CreateTwitchChatKeys < ActiveRecord::Migration[5.2]
  def change
    create_table :twitch_chat_keys do |t|
      t.string :token
      t.boolean :enabled
      t.belongs_to :twitch_user, index: true
      t.timestamps
    end
  end
end
