# frozen_string_literal: true

require "rubygems"
require "active_record"
require "bundler/setup"
require 'erb'
require 'twitch/chat'
require "discordrb"
# puts "#{ApplicationRecord.class}"
CMDRSHEPARD = true
COMMAND_PREFIX = "!"
# Getting Active Record set up (Taken from https://github.com/jwo/ActiveRecord-Without-Rails/blob/master/ar-no-rails.rb)
def chatbot_init
  project_root = File.dirname(File.absolute_path(__FILE__))
  require "#{project_root}/app/models/application_record.rb"
  puts "Loading Models"
  Dir.glob(project_root + "/app/models/*.rb").each do |f|
    puts "\t#{f}"
    require f
  end
  connection_details = YAML.load(ERB.new(File.read('config/database.yml')).result)
  ActiveRecord::Base.establish_connection(connection_details)

  # Let's define somewhere to put all of our various commands
  @bot_commands = {}
  # And a nice place for the various threads we are going to run...
  @threads = {}
  # Next up: Loading all the modules in cmds
  puts "Loading Modules"
  Dir["#{project_root}/app/cmds/*.rb"].each do |file|
    puts "\t#{file}"
    load file
    @bot_commands.merge!(commands)
  end

  # Creating Threads for our bots to run in
  puts "Initializing Bots"
  Dir["#{project_root}/app/bots/*.rb"].each do |file|
    puts "\t#{file}"
    load file
  end
  @threads.each do |_thread_name, thread|
    thread.join
  end
  puts "Exiting!"
end

if __FILE__ == $PROGRAM_NAME
  chatbot_init
end
