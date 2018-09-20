# frozen_string_literal: true

puts "Configuring Discord Client"
discord_bot = Discordrb::Bot.new token: ENV["DISCORD_CHAT_KEY"]
@bot_commands.each do |command, function|
  discord_bot.message(with_text: COMMAND_PREFIX + command) do |event|
    # ok let's grab our user first ...
    puts event.author.id
    discord_user = DiscordUser.get_discord_user_from_uid(event.author.id)
    function.call(discord_user, event.message.content, lambda { |string| event.respond string })
  end
end
puts "Spinning up Discord Client"
@threads["discord"] = Thread.new do
  discord_bot.run
end
