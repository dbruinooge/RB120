# What would happen if we added a play method to the Bingo class, keeping in mind that there is already a method of this name in the Game class that the Bingo class inherits from.

class Game
  def play
    "Start the game!"
  end
end

class Bingo < Game
  def rules_of_play
    #rules of play
  end
end

# If a play method were added to the Bingo, then calling #play on a Bingo object
# would invoke the #play instance method in the Bingo class, not the one in the Game class.
