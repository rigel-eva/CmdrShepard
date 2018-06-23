class User < ApplicationRecord
    has_one :discord_user
    has_one :twitch_user
    has_many :twitch_chat_key
    class << self
        def from_thirdParty(id, session=nil)
            id=session[:user_id] if id.nil?&& !session.nil?
            user=find_or_create_by(id:id)
            if user.sheep.nil?
                user.sheep=0
            end
            if user.admin.nil?
                user.admin=false
            end
            user.save!
            return user
        end
        def from_discord(auth_hash, session=nil)
            #... realized I could do something smart here ... I could just check the twitch id here via discord connections... which is going to require a rails migration ... 
            discord_user=DiscordUser.find_or_create_by(uid:auth_hash['uid'])
            user=from_thirdParty(discord_user.user_id, session)
            discord_user.uid=auth_hash['uid']
            discord_user.name=auth_hash.extra.raw_info['username']
            discord_user.discriminator=auth_hash.extra.raw_info['discriminator']
            discord_user.icon=auth_hash.info['image']
            discord_user.token=auth_hash.credentials['token']
            discord_user.user_id=user.id
            discord_user.save!
            return user
        end
        def from_twitch(auth_hash, session=nil)
            #unfortunatly I can't get much info out of twitch about discord ... but I think I could have discord automaticly fill in the id and the username on this end, and I could do a check on if the image has been filled in!
            twitch_user=TwitchUser.find_or_create_by(uid:auth_hash['uid'])
            user=from_thirdParty(twitch_user.user_id,session)
            twitch_user.uid=auth_hash['uid']
            twitch_user.name=auth_hash.info['name']
            twitch_user.icon=auth_hash.info['image']
            twitch_user.token=auth_hash.credentials['token']
            twitch_user.user_id=user.id
            twitch_user.save!
            return user
        end
    end
end
