class TwitchChatKey < ApplicationRecord
    belongs_to :twitch_user
    class<<self
        def setupKey(auth_hash)
            #Ok if we got to this point we are assuming that the user already has associated a twitch account with the program
            twitch_user=TwitchUser.find_or_create_by(uid:auth_hash['uid'])
            twitch_chat_key=TwitchChatKey.find_or_create_by(twitch_user_id:twitch_user.id)
            twitch_chat_key.token=auth_hash.credentials['token']
            twitch_chat_key.enabled=false;
            twitch_chat_key.save!
            return twitch_user.user;
        end
    end
end
