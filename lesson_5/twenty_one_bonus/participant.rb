require 'pry'

class Participant
  CARD_VALUES = { '2' => 2, '3' => 3, '4' => 4, '5' => 5, '6' => 6,
                '7' => 7, '8' => 8, '9' => 9, '10' => 10, 'J' => 10,
                'Q' => 10, 'K' => 10, 'A' => 11 }
                
  attr_reader :hand
  
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
    while total > 21 && aces > 0
      total -= 10
      aces -= 1
    end
    total
  end
  
  def busted?
    total > 21
  end
  
  def discard_hand
    @hand = []
  end
  
  private

  attr_writer :hand
 
end