class TwitchUser < ApplicationRecord
    belongs_to :user
    has_one :twitch_chat_key    
    class << self
        def findOrCreatebyUID(uid)
            TwitchUser.find_or_create_by(uid:uid)
            user=from_thirdParty(twitch_user.user_id)
            twitch_user.uid=uid
            #add code for finding this from endpoints
            userData=JSON::parse(RestClient.get("https://api.twitch.tv/helix/users",{"params"=>{id:uid}, "client-ID"=>ENV["TWITCH_KEY"]}))["data"][0]
            twitch_user.name=userData["display_name"]
            twitch_user.icon=userData["profile_image_url"]
            twitch_user.user_id=user.id
            puts twitch_user
            twitch_user.save!

        end
    end
end
