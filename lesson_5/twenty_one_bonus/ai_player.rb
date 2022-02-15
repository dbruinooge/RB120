require './participant'
require './betable'

class AIPlayer < Participant
  include Betable

  INITIAL_BANKROLL = 1000

  def self.load_names_from_file
    name_list = []
    names = File.open("ai_names.txt")
    names.each do |line|
      name_list << line.chomp
    end
    name_list
  end

  @@name_list = load_names_from_file

  def initialize
    super
    @name = @@name_list.shuffle!.pop
    @bankroll = INITIAL_BANKROLL
  end

  def make_bet
    @bet = rand(@bankroll + 1).ceil(-2)
  end

  def hit?(dealer_first_card_total)
    if total <= 11
      true
    elsif total.between?(12, 16) && dealer_first_card_total.between?(7, 11)
      true
    elsif ace_and_six?
      true
    else
      false
    end
  end

  private

  def hand_values
    hand.map(&:value)
  end

  def ace_and_six?
    hand_values.include?('A') && hand_values.include?('6')
  end
end
