class Participant
  CARD_VALUES = { '2' => 2, '3' => 3, '4' => 4, '5' => 5, '6' => 6,
                  '7' => 7, '8' => 8, '9' => 9, '10' => 10, 'J' => 10,
                  'Q' => 10, 'K' => 10, 'A' => 11 }

  MAX_SCORE = 21

  attr_reader :hand, :name

  def initialize
    @hand = []
  end

  def hit(card)
    hand << card
  end

  def list_cards
    hand.join(', ')
  end

  def total
    total = 0
    hand.each { |card| total += CARD_VALUES[card.value] }
    aces = hand.select { |card| card.value == 'A' }.count
    while total > MAX_SCORE && aces > 0
      total -= 10
      aces -= 1
    end
    total
  end

  def busted?
    total > MAX_SCORE
  end

  def discard_hand
    @hand = []
  end
end
