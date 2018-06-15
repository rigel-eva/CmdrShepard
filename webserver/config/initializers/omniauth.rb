Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitch, ENV['TWITCH_KEY'], ENV['TWITCH_SECRET']
  provider :discord, ENV['DISCORD_KEY'], ENV['DISCORD_SECRET']
  scope: 'profile', image_aspect_ratio: 'square', image_size: 48, access_type: 'online', name: 'google'
  def auth_failure
    redirect_to root_path
  end
end
