def beep(user, message)
    return "Beep Beep!"
end
def commands
    return {"beep"=>method(:beep)}
end