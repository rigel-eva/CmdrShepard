# frozen_string_literal: true
COSTS = {
  "song_request" => 30,
}
def song_request(user, message, chatter)
  # So basic scaffold is going to be
  # 1. determine if the user has the sheeps to request a song
  # 2. If they do, great look up the song on spotify
  # 3. If the song doesn't exist Refund the sheep
  # 4. if the song does exist, add the song to the "queue" in the next position
  # 5. Done!
end

def commands
  {
    "sr" => method(:song_request),
    "songRequest" => method(:song_request),
    "songrequest" => method(:song_request),
  }
end
