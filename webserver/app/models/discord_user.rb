class DiscordUser < ApplicationRecord
    belongs_to :user
    def mention
        return "<@#{uid}> "
    end
    class << self
        def fromDiscordRB(user)
            return getDiscordUserFromUID(user.id)
        end
        def findUserFromChat(textContent) 
            uid=textContent.match(/<@\d+>/)
            return getDiscordUserFromUID(uid)
        end
        private
        def getDiscordUserFromUID(uid)
            discord_user=DiscordUser.find_or_create_by(uid:uid)
            discord_user.user=User.from_thirdParty(discord_user.user_id)
            puts discord_user.user
            discord_user.name=user.username
            discord_user.discriminator=user.discriminator
            discord_user.icon=user.avatar_url
            discord_user.save!
        end
    end
end
