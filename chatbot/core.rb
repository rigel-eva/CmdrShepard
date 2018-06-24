require "rubygems"
require "bundler/setup"
require "active_record"
require 'erb'
require 'twitch/chat'
require "discordrb"
CMDRSHEPARD=true;
COMMAND_PREFIX="!"
#Getting Active Record set up (Taken from https://github.com/jwo/ActiveRecord-Without-Rails/blob/master/ar-no-rails.rb)
project_root = File.dirname(File.absolute_path(__FILE__))
Dir.glob(project_root + "/app/models/*.rb").each{|f| require f}
connection_details = YAML::load(ERB.new(File.read('config/database.yml')).result)
ActiveRecord::Base.establish_connection(connection_details)
#Getting our Twitch Chat Key...
chat_oauth=TwitchChatKey.find_by(enabled:true)
#and getting our twitch user...
twitch_user=chat_oauth.user.twitch_user
#Let's define somewhere to put all of our various commands
botCommands={}
#And a nice place for the various threads we are going to run...
threads={}
#Next up: Loading all the files in bin
Dir["#{project_root}/app/bin/*.rb"].each {|file| 
    load file
    botCommands.merge!(commands())
}
#TODO: Add database option to ask which channel to connect to
#{twitch_user.uid}:6b324056-abd8-4eaa-b52d-a921f2586ec7
@twitchClients=[]
chat_oauth.targetChannels.each{|channel|
    twitchClient=Twitch::Chat::Client.new(channel:channel, username:chat_oauth.name,nickname:chat_oauth.name, password:"oauth:#{chat_oauth.token}")do
        # on(:connected) do
        #     send_message "Yo! Everything is working on this end!"
        #     puts botCommands
        # end  
        on(:message) do |user, message|
            #log "Recieved Message!: #{message.to_s}"
            match=message.message.match(/(?:^#{COMMAND_PREFIX})(\S+)/)
            log match[-1] if match
            if(match&&botCommands.has_key?(match[-1]))
                user_id=message.userParams['user-id']
                twitch_user=TwitchUser.findOrCreatebyUID(user_id)
                botCommands[match[-1]].(twitch_user,message, method(:send_message))
            end
        end
        #Should implement join in next patch to twitch-chat...
    end
    @twitchClients.push(twitchClient)
}

@discordBot=Discordrb::Bot.new token: ENV["DISCORD_CHAT_KEY"]
botCommands.each{|command,function|
    @discordBot.message(with_text:COMMAND_PREFIX+command){|event|
        #ok let's grab our user first ...
        discord_user=DiscordUser.fromDiscordRB(event.author)
        function.(discord_user,event.message.content,lambda {|string| event.respond string})
    }
}
#Creating Threads for our bots to run in
(0..@twitchClients.length-1).each{|i|
    threads["twitch_#{i}"]=Thread.new{
        @twitchClients[i].run!
    }
}

threads["discord"]=Thread.new{
    @discordBot.run
}
threads["timeKeeper"]=Thread.new{
    #Add code to tick up when user joins
    while true
        unless(!JSON::parse(RestClient.get("https://api.twitch.tv/helix/streams?user_id=#{twitch_user.uid}",{"client-ID"=>ENV["TWITCH_KEY"]}))["data"].empty?)
            JSON::parse(RestClient.get("http://tmi.twitch.tv/group/user/#{twitch_user.uid}/chatters"))["chatters"].each{|type, user|
                luser=TwitchUser.findOrCreatebyName(user)
                luser.user.sheep+=1
                puts "giving 1 sheep to #{name}"
                luser.user.save!
                luser.save!
            }
        end
        sleep 1.minute
    end
}
threads.each{|threadName,thread|
    thread.join
}
puts "Exiting!"