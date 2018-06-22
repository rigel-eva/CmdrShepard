class AddWatchTimeToTwitchUser < ActiveRecord::Migration[5.2]
  def change
    add_column :twitch_users, :timeWatched, :integer, :null => false, :default=>0
  end
end
