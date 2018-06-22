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
twitch_user=chat_oauth.twitch_user
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
@twitchClient=Twitch::Chat::Client.new(channel:"chatrooms:#{twitch_user.uid}:6b324056-abd8-4eaa-b52d-a921f2586ec7", username:'CmdrShepardBot_development',nickname:'rigel_eva', password:"oauth:#{chat_oauth.token}")do
    on(:connected) do
        send_message "Yo! Everything is working on this end!"
        puts botCommands
    end  
    on(:message) do |user, message|
        #log "Recieved Message!: #{message.to_s}"
        match=message.message.match(/(?:^#{COMMAND_PREFIX})(\S+)/)
        log match[-1] if match
        if(match&&botCommands.has_key?(match[-1]))
            user_id=message.userParams['user-id']
            twitch_user=TwitchUser.find_or_create_by(uid:user_id)
            botCommands[match[-1]].(twitch_user,message, method(:send_message))
        end
    end
    on(:userstate) do |user|
        send_message("Heya! #{user} Thanks for coming!")
        puts "#{user} just joined"
    end
end
@discordBot=Discordrb::Bot.new token: ENV["DISCORD_CHAT_KEY"]
botCommands.each{|command,function|
    @discordBot.message(with_text:COMMAND_PREFIX+command){|event|
        #ok let's grab our user first ...
        discord_user=DiscordUser.find_or_create_by(uid:event.author.id)
        function.(discord_user,event.message.content,lambda {|string| event.respond string})
    }
}
#Creating Threads for our bots to run in
threads["twitch"]=Thread.new{
    @twitchClient.run!
}
threads["discord"]=Thread.new{
    @discordBot.run
}
threads.each{|threadName,thread|
    thread.join
}
puts "Exiting!"