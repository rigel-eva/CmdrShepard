# frozen_string_literal: true

require 'action_view'
include ActionView::Helpers::DateHelper
COSTS = {
  "truth_or_dare" => 20,
  "spar" => 60,
  "sheep_spar" => 120,
  "next_hero" => 60,
  "cocast" => 2000,
  "stream_request" => 5000,
}
def usage_helper(method)
  "Usage: #{COMMAND_PREFIX}#{commands.select { |_key, value| value == method(method) }.keys[0]}"
end

def beep(_user, _message, chatter)
  chatter.call("Beep Beep!")
end

def sheep(user, _message, chatter)
  puts user.user
  chatter.call("#{user.mention}, You currently have #{user.user.sheep} \
    sheep. You have been in the chat for #{distance_of_time_in_words(0, user.user.twitch_user.timeWatched.minutes)}.")
end

def gamble(user, message, chatter)
  return_string = ""
  puts message
  match = message.to_s.match(/^\S+ (\d+)/)
  puts match
  if match.nil?
    return_string = "#{user.mention}, #{usage_helper(:gamble)} [ammount]" # Uh ... this should work ...
  else
    sheep_gambled = match[-1].to_i
    if sheep_gambled < 4
      return_string = "#{user.mention}, You're only allowed to gamble a minimum amount of 5 Sheep."
    elsif sheep_gambled > user.user.sheep
      return_string = "#{user.mention}, You're trying to bet more sheep than you have!\
       I wouldn't do that ... Nyori would have to track you down"
    else
      user.user.sheep -= sheep_gambled
      return_string = "You bet #{sheep_gambled} and "
      roll = (rand(1..10) / 2 - 1).floor
      return_string += if roll < 1
        "lost them all"
      else
        "and won #{sheep_gambled * roll}"
      end
      user.user.sheep += sheep_gambled * roll
    end
  end
  chatter.call(return_string)
end

def gift(user, message, chatter)
  return_string = ""
  puts message
  match = message.to_s.match(/^\S+ (\S+) (\d+)/)
  if match.nil?
    return_string = "#{user.mention}, #{usage_helper(:gift)} [user] [ammount]"
  else
    # ok let's go ahead and split up or match into what we are actually after
    ammount = match[-1].to_i
    user_target = user.class.findUserFromChat(match[-2])
    if ammount > user.user.sheep
      return_string = "You can't give more sheep than you currently have! (Current Sheep: #{user.user.sheep})"
    else
      user.user.sheep -= ammount
      user_target.user.sheep += ammount
      return_string = "Given #{user_target.mention on} #{ammount}!"
    end
  end
  chatter.call(return_string)
end

def truth_or_dare(user, message, chatter)
  return_string = ""
  match = message.match(/^\S+ ([\s\S]+)/)
  if match.nil?
    return_string = "#{user.mention}, #{usage_helper(:truth_or_dare)} [Question]"
  else
    owner = User.find_by(owner: true).discord_user
    channel = @discordBot.pm_channel(owner.id)
    @discordBot.send_message(channel, "#{user.name} has Issued a truth or dare: #{match[-1]}")
    return_string = "Sent!"
  end
  chatter.call(return_string)
end

def spar(_user, message, chatter)
  return_string = ""
  match = message.match(/^\S+/)
  # Should add some command stuff here to have the bot whisper to both the player and send the Owner (Marz) a message
  chatter.call("Spar is Currently not Implemented")
end

def sheep_spar(_user, _message, chatter)
  chatter.call("Sheep Spar is Currently not Implemented")
end

def next_hero(user, message, chatter)
  return_string = ""
  match = message.match(/^\S+ ([\s\S]+)/)
  if match.nil?
    return_string = "#{user.mention}, #{usage_helper(:next_hero)} [Hero]"
  elsif user.user.sheep < COSTS["next_hero"]
    return_string = "Sorry, but you don't quite have the Baaaa to cover that transaction, please try again later"
  else
    User.find
  end
  chatter.call(return_string)
end

def cocast(_user, _message, chatter)
  chatter.call("CoCast is Currently not Implemented")
end

def stream_request(user, message, _chatter)
  return_string = ""
  match = message.match(/^\S+ ([\s\S]+)/)
  return_string = if match.nil?
    "#{user.mention} , #{usage_helper(:stream_request)} [Game]"
  else
    "Truth or Dare is currently not Implemented"
  end
  chatter.call(return_string)
end

def like_a_sheep(_user, _message, chatter)
  chatter.call("Meow Meow I'm A cow. I said Meow meow I'm a cow.")
end

def like_a_nori(user, _message, chatter)
  puts(user)
  chatter.call("Nyaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
  chatter.call("nyamit nyyy nyould nyooo nyooo nyoo nyat?!")
end

def commands
  {
    "beep" => method(:beep),
    "sheep" => method(:sheep),
    "gamble" => method(:gamble),
    "gift" => method(:gift),
    "tod" => method(:truth_or_dare),
    "spar" => method(:spar),
    "sheepspar" => method(:sheep_spar),
    "nexthero" => method(:next_hero),
    "cocast" => method(:cocast),
    "streamrequest" => method(:stream_request),
    "beepbeep" => method(:like_a_sheep),
    "nyanya" => method(:like_a_nori),
    "nyaa" => method(:like_a_nori),
  }
end
