Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitch, ENV['TWITCH_KEY'], ENV['TWITCH_SECRET']
  provider :discord, ENV['DISCORD_KEY'], ENV['DISCORD_SECRET'], scope: 'identify connections'
  def auth_failure
    redirect_to root_path
  end
end
