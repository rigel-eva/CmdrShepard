class CreateTwitchChatKeysAgain < ActiveRecord::Migration[5.2]
  def change
    create_table :twitch_chat_keys do |t|
      t.string :uid
      t.string :name
      t.string :token
      t.text :targetChannels, array: true, default: []
      t.boolean :enabled
      t.belongs_to :user, index:true
    end
  end
end
