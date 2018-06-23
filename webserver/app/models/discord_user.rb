class DiscordUser < ApplicationRecord
    belongs_to :user
    def mention
        return "<@#{uid}>"
    end
    class << self
        def fromDiscordRB(user)
            discord_user=DiscordUser.find_or_create_by(uid:user.id)
            discord_user.user=User.from_thirdParty(discord_user.user_id)
            discord_user.name=user.username
            discord_user.discriminator=user.discriminator
            discord_user.icon=user.avatar_url
            discord_user.save!
            return discord_user
        end
    end
end
