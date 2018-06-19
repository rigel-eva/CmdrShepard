class SessionsController < ApplicationController
    #TODO: debug code, remove from final. 
    #def create
    #     render plain: request.env['omniauth.auth'].to_yaml
    # end
    
    def create
        @user=nil
        if(params[:provider]=="discord")
            @user=User.from_discord(request.env['omniauth.auth'])
        end
        if(params[:provider]=="twitch")
            @user=User.from_twitch(request.env['omniauth.auth'])
        end
        puts @user
        session[:user_id] = @user.id
        welcomeMessage=""
        if ! @user.twitch_user.nil? && ! @user.discord_user.nil?
            welcomeMessage="/"
        end
        if ! @user.twitch_user.nil?
            welcomeMessage=@user.twitch_user.name+welcomeMessage
        end
        if ! @user.discord_user.nil?
            welcomeMessage+="#{@user.discord_user.name}##{@user.discord_user.discriminator}"
        end
        flash[:success] = "Welcome, #{welcomeMessage}!"
        redirect_to root_path
    end
  end