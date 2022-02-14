require './participant'
require './betable'

class AIPlayer < Participant
  include Betable
  
  INITIAL_BANKROLL = 1000
  
  def self.get_names
    name_list = []
    names = File.open("ai_players.txt")
    names.each do |line|
      name_list << line.chomp
    end
    name_list
  end
  
  @@name_list = get_names
  @@taken_names = []
  
  attr_reader :name
  
  def initialize
    super
    possible_names = @@name_list.reject {|name| @@taken_names.include?(name) }
    @name = possible_names.sample
    @@taken_names << @name
    @bankroll = INITIAL_BANKROLL
  end

  def ace_and_six?
    hand_values.include?('Ace') && hand_values.include?('6')
  end

  def make_bet
    @bet = rand(@bankroll + 1).round(-2)
  end

  private

  def hand_values
    hand.map { |card| card.value }
  end
end