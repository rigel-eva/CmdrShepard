# frozen_string_literal: true

# Getting our Twitch Chat Key...
chat_oauth = TwitchChatKey.find_by(enabled: true)
# and getting our twitch user...
twitch_user = chat_oauth.user.twitch_user
@twitch_clients = []
puts "Configing Twitch Bots"
chat_oauth.targetChannels.each do |channel|
  puts "\tChannel: #{channel}"
  bc = @bot_commands # This fixes the issue of it not finding bot commands inside of the twitch client
  twitch_client = Twitch::Chat::Client.new(channel: channel, username: chat_oauth.name,\
    nickname: chat_oauth.name, password: "oauth:#{chat_oauth.token}") do
    # Debug Code:
    # on(:connected) do
    #      send_message "Yo! Everything is working on this end!"
    #      puts "Bot Commands: #{bc}"
    # end
    on(:message) do |_user, message|
      # log "Recieved Message!: #{message.to_s}"
      match = message.message.match(/(?:^#{COMMAND_PREFIX})(\S+)/)
      log match[-1] if match
      if match && bc.key?(match[-1])
        user_id = message.userParams['user-id']
        twitch_user = TwitchUser.findOrCreatebyUID(user_id)
        bc[match[-1]].call(twitch_user, message, method(:send_message))
      end
    end
    # Should implement join in next patch to twitch-chat...
  end
  @twitch_clients.push(twitch_client)
end
puts "Spinning up Twitch Bots"
(0..@twitch_clients.length - 1).each do |i|
  puts "\tChannel: #{@twitch_clients[i].channel.name}"
  @threads["twitch_#{i}"] = Thread.new do
    logger = Logger.new(STDOUT)
    @twitch_clients[i].run!
  end
end
puts "Spinning up Timekeeper"
@threads["timeKeeper"] = Thread.new do
  logger = Logger.new(STDOUT)
  loop do
    logger.debug("Checking Connected")
    if JSON.parse(RestClient.get("https://api.twitch.tv/helix/streams?user_id=#{twitch_user.uid}",\
      "client-ID" => ENV["TWITCH_KEY"]))["data"].empty?
      # Just to acknowledge that we ran the command successfully, but we haven't started streaming
      logger.debug("Not even streaming")
    else
      # Pulling the current users into a variable to do ... things with it.
      chatters = JSON.parse(RestClient.get("http://tmi.twitch.tv/group/user/\
        #{User.find_by(owner: true).twitch_user.name}/chatters"))["chatters"]
      if viewers.empty?
        # Acknowledging that we ran the command but no one is watching, not even ourselves 😢
        logger.debug("Empty Crowd /shrug")
      else
        viewers = chatters["viewers"] # people currently watching the stream
        # viewers=chatters["moderators"]#Debug Code
        moderators = chatters["moderators"] # members of the mod staff watching the stream
        viewers.each do |u|
          sheep_given = 1
          # checking if there is anything special that we should do with sheep
          sheep_given += 3 if moderators.include?(u)
          luser = TwitchUser.findOrCreatebyName(u) # checking if we have that user or creating it if we don't.
          luser.user.sheep += sheep_given
          luser.timeWatched += 1
          logger.debug("giving #{sheep_given} sheep to #{u}")
          luser.user.save!
          luser.save!
        end
      end
    end
    sleep 60 # Sleep for a hot minute owo
  end
end
