require 'pry'

class Card
  include Comparable
  
  RANK_RANKING = {1 => 2, 2 => 3, 3 => 4, 4 => 5, 5 => 6, 6 => 7, 7 => 8,
             8 => 9, 9 => 10, 10 => 'Jack', 11 => 'Queen', 12 => 'King', 13 => 'Ace' }

  SUIT_RANKING = {1 => 'Diamonds', 2 => 'Clubs', 3 => 'Hearts', 4 => 'Spades' }

  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def <=>(other)
    [RANK_RANKING.key(self.rank), SUIT_RANKING.key(self.suit)] <=>
    [RANK_RANKING.key(other.rank), SUIT_RANKING.key(other.suit)]
  end

  def to_s
    "#{@rank} of #{@suit}"
  end
end

cards = [Card.new(2, 'Hearts'),
         Card.new(2, 'Diamonds'),
         Card.new(2, 'Clubs'),
         Card.new(2, 'Spades'),
         Card.new('Jack', 'Spades')]

puts cards.sort
