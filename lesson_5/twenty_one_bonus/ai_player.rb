require './participant'
require './betable'

class AIPlayer < Participant
  include Betable
  
  INITIAL_BANKROLL = 1000
  
  def self.get_names
    name_list = []
    names = File.open("ai_names.txt")
    names.each do |line|
      name_list << line.chomp
    end
    name_list
  end
  
  @@name_list = get_names
  @@taken_names = []

  def initialize
    super
    possible_names = @@name_list.reject {|name| @@taken_names.include?(name) }
    @name = possible_names.sample
    @@taken_names << @name
    @bankroll = INITIAL_BANKROLL
  end

  def make_bet
    @bet = rand(@bankroll + 1).ceil(-2)
  end

  def hit?(dealer_first_card_total)
    case
    when total <= 11
      return true
    when total.between?(12, 16) && dealer_first_card_total.between?(7, 11)
      return true
    when ace_and_six?
      return true
    else
      return false
    end
  end

  private

  def hand_values
    hand.map { |card| card.value }
  end

  def ace_and_six?
    hand_values.include?('Ace') && hand_values.include?('6')
  end
end