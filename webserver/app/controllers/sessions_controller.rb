# frozen_string_literal: true

class SessionsController < ApplicationController
  # TODO: debug code, remove from final.
  # def create
  #     render plain: request.env['omniauth.auth'].to_yaml
  # end

  def create
    @user = nil
    welcome_message = ""
    case params[:provider]
    when "discord"
      @user = User.from_discord(request.env['omniauth.auth'], session)
      welcome_message = "Welcome, "
    when "twitch"
      @user = User.from_twitch(request.env['omniauth.auth'], session)
      welcome_message = "Welcome, "
    when "twitch_chat"
      @user = TwitchChatKey.setupKey(request.env['omniauth.auth'], session)
      welcome_message = "Thank you for entering your stream key, "
    end
    puts @user
    session[:user_id] = @user.id

    unless @user.twitch_user.nil?
      welcome_message += @user.twitch_user.name
    end
    if !@user.twitch_user.nil? && !@user.discord_user.nil?
      welcome_message += "/"
    end
    unless @user.discord_user.nil?
      welcome_message += "#{@user.discord_user.name}##{@user.discord_user.discriminator}"
    end
    if params[:provider] == "twitch_chat"
      welcome_message += ". Now go enable it on *INSERT API KEY ENABLING THING HERE*"
    end
    flash[:success] = welcome_message.to_s
    redirect_to root_path
  end
end
