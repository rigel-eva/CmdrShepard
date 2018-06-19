class CreateTwitchUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :twitch_users do |t|
      t.string :uid
      t.string :name
      t.string :icon
      t.belongs_to :user, index:true
      t.timestamps
    end
  end
end
