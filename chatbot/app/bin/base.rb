def beep(user, message, chatter)
    chatter.("Beep Beep!")
end
def sheep(user, message, chatter)
    puts user.user
    chatter.("@#{user.name} , You currently have #{user.user.sheep} sheep.You have been in the chat for #{"INSERT TIME KEEPING CODE HERE"}")
end
def gamble(user, message, chatter)
    chatter.("Gamble is Currently not Implemented")
end
def gift(user, message, chatter)
    chatter.("Gift is Currently not Implemented")
end
def truth_or_dare(user,message,chatter)
    chatter.("Truth or Dare is Currently not Implemented")
end
def spar(user, message, chatter)
    chatter.("Spar is Currently not Implemented")
end
def sheep_spar(user, message, chatter)
    chatter.("Sheep Spar is Currently not Implemented")
end
def next_hero(user, message, chatter)
    chatter.("Next Hero is Currently not Implemented")
end
def cocast (user, message, chatter)
    chatter.("CoCast is Currently not Implemented")
end
def stream_request(user, message, chatter)
    chatter.("Stream Request is Currently not Implemented")
end
def like_a_sheep(user, message, chatter)
    chatter.("Meow Meow I'm A cow. I said Meow meow I'm a cow.")
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
        "beepbeep"=>method(:like_a_sheep)
    }
end