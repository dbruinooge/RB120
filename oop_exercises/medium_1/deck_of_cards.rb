class Deck
  RANKS = ((2..10).to_a + %w(Jack Queen King Ace)).freeze
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze

  def initialize
    reset
  end
  
  def draw
    reset if @deck.empty?
    @deck.pop
  end

  private

  def reset
    @deck = []
    RANKS.each do |rank|
      SUITS.each do |suit|
        @deck << Card.new(rank, suit)
      end
    end
    @deck.shuffle!
  end
end

class Card
  include Comparable
  
  RANK_RANKING = {1 => 2, 2 => 3, 3 => 4, 4 => 5, 5 => 6, 6 => 7, 7 => 8,
             8 => 9, 9 => 10, 10 => 'Jack', 11 => 'Queen', 12 => 'King', 13 => 'Ace' }

  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def <=>(other)
    RANK_RANKING.key(self.rank) <=> RANK_RANKING.key(other.rank)
  end

  def to_s
    "#{@rank} of #{@suit}"
  end
end
