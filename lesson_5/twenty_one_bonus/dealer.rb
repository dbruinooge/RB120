require './participant'

class Dealer < Participant
  attr_reader :name
  
  def initialize
    super
    @name = 'Dealer'
  end

  def first_card_total
    Participant::CARD_VALUES[hand.first.value]
  end
  
  def list_cards
    hand.join(', ')
  end
end
