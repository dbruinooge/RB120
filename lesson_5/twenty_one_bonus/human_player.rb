require './participant'

class HumanPlayer < Participant
  attr_reader :name
  
  def initialize
    super
    @name = 'Derek'
  end
end

=begin

maybe implement betting after AI players are working, then implement competition (x rounds, winner is person with highest total)

new class, AIPlayer
game method that initializes all of them and stores in a game instance variable @ai_players []
  in initialize, maybe @ai_players = initialize_ai_players

after player turn, ai_turn unless @ai_players.empty?

ai_turn, @ai_players.each |player| ai_turn(player) 

ai_turn
 - [choose bet]
- hit or stand based on basic strategy
    FIRST: hit if self.hand <= 11
    Stand when your hand is 12-16 when the dealer has 2-6. 
    Hit when your hand is 12-16 when the dealer has 7-Ace
    Always hit Aces-6
    
    can use a blank case statement
    when self.hand < dealer.hand
      hit
    when self.hand.between?(12, 16) AND dealer.hand.between?(2, 6)
      hit
    when aces_six?
      hit
    end
    



=end