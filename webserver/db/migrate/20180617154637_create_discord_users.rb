class CreateDiscordUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :discord_users do |t|
      t.string :uid, unique: true
      t.string :name
      t.string :icon
      t.string :email
      t.belongs_to :user, index:true
      t.timestamps
    end
  end
end
