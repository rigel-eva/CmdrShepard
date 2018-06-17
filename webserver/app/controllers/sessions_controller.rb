class SessionsController < ApplicationController
    def create
        render plain: request.env['omniauth.auth'].to_yaml
    end
    
    # def create
    #     @user=nil
    #     if(parameter[:provider]=="discord")
    #         @user=User.from_discord(request.env['omniauth.auth'].to_yaml)
        
    #     elsif(parameter[:provider]=="twitch")
    #         @user=User.from_twitch(request.env['omniauth.auth'].to_yaml)
    #     end
    #     render text: request.env['omniauth.auth'].to_yaml
    #     session[:user_id] = @user.id
    #     flash[:success] = "Welcome, #{@user.name}!"
    # rescue
    #     flash[:warning] = "There was an error while trying to authenticate you..."
    # end
    #     redirect_to root_path
    # end
  end