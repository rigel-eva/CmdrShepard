require "rubygems"
require "active_record"
require "bundler/setup"
require 'erb'
require 'twitch/chat'
require "discordrb"
#puts "#{ApplicationRecord.class}"
CMDRSHEPARD=true;
COMMAND_PREFIX="!"
#Getting Active Record set up (Taken from https://github.com/jwo/ActiveRecord-Without-Rails/blob/master/ar-no-rails.rb)
def chatbot_init
    project_root = File.dirname(File.absolute_path(__FILE__))
    require "#{project_root}/app/models/application_record.rb"
    puts "Loading Models"
    Dir.glob(project_root + "/app/models/*.rb").each{|f|
        puts "\t#{f}"
        require f
    }
    connection_details = YAML::load(ERB.new(File.read('config/database.yml')).result)
    ActiveRecord::Base.establish_connection(connection_details)

    #Let's define somewhere to put all of our various commands
    @botCommands={}
    #And a nice place for the various threads we are going to run...
    @threads={}
    #Next up: Loading all the modules in cmds
    puts "Loading Modules"
    Dir["#{project_root}/app/cmds/*.rb"].each {|file| 
        puts "\t#{file}"
        load file
        @botCommands.merge!(commands())
    }

    #Creating Threads for our bots to run in
    puts "Initializing Bots"
    Dir["#{project_root}/app/bots/*.rb"].each{|file|
        puts "\t#{file}"
        load file
    }
    @threads.each{|threadName,thread|
        thread.join
    }
    puts "Exiting!"
end

if __FILE__==$0
    chatbot_init()
end