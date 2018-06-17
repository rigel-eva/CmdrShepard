class User < ApplicationRecord
    def from_discord(auth_hash)
        discord_user.find_or_create_by(uid:auth_hash)
    end
end
