def beep(user, message, chatter)
    chatter.("Beep Beep!")
end
def commands
    return {"beep"=>method(:beep)}
end