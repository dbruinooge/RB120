require './participant'
require './betable'

class HumanPlayer < Participant
  include Betable
  
  INITIAL_BANKROLL = 1000

  def initialize
    super
    @name = set_name
    @bankroll = INITIAL_BANKROLL
  end

  def make_bet
    chosen_bet = 0
    loop do
      puts ""
      puts "Please enter the amount you'd like to bet (1-#{@bankroll}):"
      chosen_bet = gets.chomp.to_i
      break if chosen_bet.between?(1, @bankroll)
      puts "Sorry, that's not a valid bet."
    end
    @bet = chosen_bet
  end

  def hit?(dealer_first_card_total)
    return false if total == 21
    loop do
      puts "You have #{total} and the dealer is showing "\
           "#{dealer_first_card_total}. Would you like to hit? (y/n)"
      choice = gets.chomp.downcase
      return true if ['y', 'yes'].include?(choice)
      return false if ['n', 'no'].include?(choice)
      puts "Sorry, that's not a valid choice."
    end
  end

  private

  def set_name
    choice = nil
    loop do
      puts "What's your name?"
      choice = gets.chomp
      break unless choice.empty?
      puts "Sorry, that's not a valid name."
    end
    choice
  end
end
