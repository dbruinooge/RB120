require 'pry'

class Participant
  CARD_VALUES = { '2' => 2, '3' => 3, '4' => 4, '5' => 5, '6' => 6,
                '7' => 7, '8' => 8, '9' => 9, '10' => 10, 'Jack' => 10,
                'Queen' => 10, 'King' => 10, 'Ace' => 11 }
                
  attr_reader :hand
  
  def initialize
    @hand = []
  end
  
  def hit(card)
    hand << card
  end
  
  def describe_hand
    joinor(hand)
  end
  
  def total
    total = 0
    hand.each { |card| total += CARD_VALUES[card.value] }
    aces = hand.select { |card| card.value == 'Ace' }.count
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
  
  def joinor(arr, delimiter=', ', word='and')
    arr = arr.clone
    case arr.size
    when 0 then ''
    when 1 then arr.first
    when 2 then arr.join(" #{word} ")
    else
      arr[-1] = "#{word} #{arr.last}"
      arr.join(delimiter)
    end
  end
  
  attr_writer :hand
 
end