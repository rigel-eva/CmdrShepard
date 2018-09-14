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
        def getDiscordUserFromUID(uid)
            discord_user=DiscordUser.find_or_create_by(uid:uid)
            discord_user.user=User.from_thirdParty(discord_user.user_id)
            discord_user.save!
        end
    end
end
