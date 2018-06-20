class SessionsController < ApplicationController
    #TODO: debug code, remove from final. 
    # def create
    #     render plain: request.env['omniauth.auth'].to_yaml
    # end
    
    def create
        @user=nil
        welcomeMessage=""
        case params[:provider]
        when "discord"
            @user=User.from_discord(request.env['omniauth.auth'])
            welcomeMessage="Welcome, "
        when "twitch"
            @user=User.from_twitch(request.env['omniauth.auth'])
            welcomeMessage="Welcome, "
        when "twitch_chat"
            @user=TwitchChatKey.setupKey(request.env['omniauth.auth'])
            welcomeMessage="Thank you for entering your stream key, "
        end
        puts @user
        session[:user_id] = @user.id

        if ! @user.twitch_user.nil?
            welcomeMessage+=@user.twitch_user.name
        end
        if ! @user.twitch_user.nil? && ! @user.discord_user.nil?
            welcomeMessage+="/"
        end
        if ! @user.discord_user.nil?
            welcomeMessage+="#{@user.discord_user.name}##{@user.discord_user.discriminator}"
        end
        if params[:provider]=="twitch_chat"
            welcomeMessage+=". Now go enable it on *INSERT API KEY ENABLING THING HERE*"
        end
        flash[:success] = "#{welcomeMessage}"
        redirect_to root_path
    end
  end