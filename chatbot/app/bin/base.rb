require 'action_view'
include ActionView::Helpers::DateHelper
def usage_Helper(method)
    return "Usage: #{COMMAND_PREFIX}#{commands.select{|key,value|value==method(method)}.keys[0]}"
end
def beep(user, message, chatter)
    chatter.("Beep Beep!")
end
def sheep(user, message, chatter)
    puts user.user
    chatter.("#{user.mention}, You currently have #{user.user.sheep} sheep. You have been in the chat for #{distance_of_time_in_words(0,user.user.twitch_user.timeWatched.minutes)}.")
end
def gamble(user, message, chatter)
    return_string=""
    puts message
    match=message.to_s.match(/^\S+ (\d+)/)
    puts match
    if(match.nil?)
        return_string="#{user.mention}, #{usage_Helper(:gamble)} [ammount]"#Uh ... this should work ...
    else
        sheep_gambled=match[-1].to_i
        if(sheep_gambled<4)
            return_string="#{user.mention}, You're only allowed to gamble a minimum amount of 5 Sheep."
        elsif(sheep_gambled>user.user.sheep)
            return_string="#{user.mention}, You're trying to bet more sheep than you have! I wouldn't do that ... Nyori would have to track you down"
        else
            user.user.sheep-=sheep_gambled
            return_string="You bet #{sheep_gambled} and "
            roll=(rand(1..10)/2-1).floor
            if(roll<1)
                return_string+="lost them all"
            else
                return_string+="and won #{sheep_gambled*roll}"
            end
            user.user.sheep+=sheep_gambled*roll
        end
    end
    chatter.(return_string)
end
def gift(user, message, chatter)
    return_string=""
    puts message
    match=message.to_s.match(/^\S+ (\S+) (\d+)/)
    if(match.nil?)
        return_string="#{user.mention}, #{usage_Helper(:gift)} [user] [ammount]"
    else
        #ok let's go ahead and split up or match into what we are actually after
        ammount=match[-1].to_i
        userTarget=user.class.findUserFromChat(match[-2])
        if(ammount>user.user.sheep)
            return_string="You can't give more sheep than you currently have! (Current Sheep: #{user.user.sheep})"
        else
            user.user.sheep-=ammount
            userTarget.user.sheep+=ammount
            return_string="Given #{userTarget.mention on} #{ammount}!"
        end
    end
    chatter.(return_string)
end
def truth_or_dare(user,message,chatter)
    return_string=""
    match=message.match(/^\S+ ([\s\S]+)/)
    if(match.nil?)
        return_string="#{user.mention}, #{usage_Helper(:truth_or_dare)} [Question]"
    else
        return_string="Truth or Dare is currently not Implemented"
    end
    chatter.(return_string)
end
def spar(user, message, chatter)
    return_string=""
    match=message.match(/^\S+/)
    #Should add some command stuff here to have the bot whisper to both the player and send the Owner (Marz) a message
    chatter.("Spar is Currently not Implemented")
end
def sheep_spar(user, message, chatter)
    chatter.("Sheep Spar is Currently not Implemented")
end
def next_hero(user, message, chatter)
    return_string=""
    match=message.match(/^\S+ ([\s\S]+)/)
    if(match.nil?)
        return_string="#{user.mention}, #{usage_Helper(:next_hero)} [Hero]"
    else
        return_string="Truth or Dare is currently not Implemented"
    end
    chatter.(return_string)
end
def cocast (user, message, chatter)
    chatter.("CoCast is Currently not Implemented")
end
def stream_request(user, message, chatter)
    return_string=""
    match=message.match(/^\S+ ([\s\S]+)/)
    if(match.nil?)
        return_string="#{user.mention} , #{usage_Helper(:stream_request)} [Game]"
    else
        return_string="Truth or Dare is currently not Implemented"
    end
end
def like_a_sheep(user, message, chatter)
    chatter.("Meow Meow I'm A cow. I said Meow meow I'm a cow.")
end
def like_a_nori(user, message, chatter)
    chatter.("Nyaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
    chatter.("nyamit nyyy nyould nyooo nyooo nyoo nyat?!")
end
def commands
    return {
        "beep"=>method(:beep),
        "sheep"=>method(:sheep),
        "gamble"=>method(:gamble),
        "gift"=>method(:gift),
        "tod"=>method(:truth_or_dare),
        "spar"=>method(:spar),
        "sheepspar"=>method(:sheep_spar),
        "nexthero"=>method(:next_hero),
        "cocast"=>method(:cocast),
        "streamrequest"=>method(:stream_request),
        "beepbeep"=>method(:like_a_sheep),
        "nyanya"=>method(:like_a_nori),
        "nyaa"=>method(:like_a_nori)
    }
end