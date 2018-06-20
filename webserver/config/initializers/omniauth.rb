Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitch, ENV['TWITCH_KEY'], ENV['TWITCH_SECRET'],{
    :scope=>'user_read'
  }
  provider :twitch, ENV['TWITCH_CHAT_KEY'], ENV['TWITCH_CHAT_SECRET'],{
    :name =>'twitch_chat',
    :scope =>'user_read+chat_login',
    :callback_path=>"/auth/twitch_chat/callback"
  }
  provider :discord, ENV['DISCORD_KEY'], ENV['DISCORD_SECRET'], scope: 'identify connections'
  def auth_failure
    redirect_to root_path
  end
end
OmniAuth.config.logger = Rails.logger if Rails.env.development?