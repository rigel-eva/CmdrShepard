class AddDiscriminatorToDiscordUser < ActiveRecord::Migration[5.2]
  def change
    add_column :discord_users, :discriminator, :string
  end
end
