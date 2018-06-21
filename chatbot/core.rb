require "rubygems"
require "bundler/setup"
require "active_record"
require 'erb'
CMDRSHEPARD=true;
#Getting Active REcord set up (Taken from https://github.com/jwo/ActiveRecord-Without-Rails/blob/master/ar-no-rails.rb)
project_root = File.dirname(File.absolute_path(__FILE__))
Dir.glob(project_root + "/app/models/*.rb").each{|f| require f}

connection_details = YAML::load(ERB.new(File.read('config/database.yml')).result)
ActiveRecord::Base.establish_connection(connection_details)
#Just getting the list of all twitch users to demo the fact that active record is loading them
TwitchUser.all.each{|user|
    puts user.name
}