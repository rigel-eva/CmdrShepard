puts "Configuring Discord Client"
@discordBot=Discordrb::Bot.new token: ENV["DISCORD_CHAT_KEY"]
@botCommands.each{|command,function|
    @discordBot.message(with_text:COMMAND_PREFIX+command){|event|
        #ok let's grab our user first ...
        puts event.author.id
        discord_user=DiscordUser.getDiscordUserFromUID(event.author.id)
        function.(discord_user,event.message.content,lambda {|string| event.respond string})
    }
}
puts "Spinning up Discord Client"
@threads["discord"]=Thread.new{
    @discordBot.run
}