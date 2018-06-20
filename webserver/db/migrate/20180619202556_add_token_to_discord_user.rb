class AddTokenToDiscordUser < ActiveRecord::Migration[5.2]
  def change
    add_column :discord_users, :token, :string
  end
end
