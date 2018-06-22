require "rubygems"
require "bundler/setup"
require "active_record"
require 'erb'
require 'twitch/chat'
CMDRSHEPARD=true;
COMMAND_PREFIX="!"
#Getting Active Record set up (Taken from https://github.com/jwo/ActiveRecord-Without-Rails/blob/master/ar-no-rails.rb)
project_root = File.dirname(File.absolute_path(__FILE__))
Dir.glob(project_root + "/app/models/*.rb").each{|f| require f}
connection_details = YAML::load(ERB.new(File.read('config/database.yml')).result)
ActiveRecord::Base.establish_connection(connection_details)
#So first of all, connecting to The twitch chat
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
client=Twitch::Chat::Client.new(channel:"chatrooms:#{twitch_user.uid}:6b324056-abd8-4eaa-b52d-a921f2586ec7", username:'CmdrShepardBot_development',nickname:'rigel_eva', password:"oauth:#{chat_oauth.token}")do
    on(:connected) do
        send_message "Yo! Everything is working on this end!"
        puts botCommands
    end  
    on(:message) do |user, message|
        #log "Recieved Message!: #{message.to_s}"
        match=message.match(/(?:^#{COMMAND_PREFIX})(\S+)/)
        log match[-1] if match
        if(match&&botCommands.has_key?(match[-1]))
            #TODO: Figure out a better way to do this(as in let the function call the command)
            botCommands[match[-1]].(user,message, method(:send_message))
        end
    end
end
threads["twitch"]=Thread.new{
    client.run!
}
threads.each{|threadName,thread|
    thread.join
}
puts "Exiting!"