# frozen_string_literal: true

class AddTokenToTwitchUser < ActiveRecord::Migration[5.2]
  def change
    add_column :twitch_users, :token, :string
  end
end
