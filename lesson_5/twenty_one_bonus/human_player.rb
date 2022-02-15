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
      display_bet_prompt
      chosen_bet = gets.chomp.to_i
      break if chosen_bet.between?(1, @bankroll)
      puts "Sorry, that's not a valid bet."
    end
    @bet = chosen_bet
  end

  def display_bet_prompt
    puts ""
    puts "You have #{@bankroll}. Please enter the amount "\
         "you'd like to bet (1-#{@bankroll}):"
  end

  def hit?(dealer_first_card_total)
    return false if total == 21
    loop do
      display_hit_prompt(dealer_first_card_total)
      choice = gets.chomp.downcase
      return true if ['h', 'hit'].include?(choice)
      return false if ['s', 'stand'].include?(choice)
      puts "Sorry, that's not a valid choice."
    end
  end

  def display_hit_prompt(dealer_first_card_total)
    puts "You have #{total} and the dealer is showing "\
    "#{dealer_first_card_total}. Would you like to (h)it or (s)tand?"
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
