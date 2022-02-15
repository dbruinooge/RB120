require 'pry'
require './deck'
require './human_player'
require './dealer'
require './ai_player'
require './printable'

#
#
#
# REMINDER TO SELF
# GET RID OF MAGIC NUMBERS
# AND ASSIGN THEM TO CONSTANTS
#
#
#

class Game
  include Printable
  
  DEALER_STANDS = 17
  HIGHEST_SCORE = 21

  def initialize
    display_welcome_message
    @deck = Deck.new
    @dealer = Dealer.new
    @human_player = HumanPlayer.new
    @players = [@human_player] + initialize_ai_players(how_many_ai_players)
  end

  def start
    loop do
      collect_bets
      deal_cards
      player_turns
      dealer_turn unless everyone_busted?
      settle_bets
      show_all_results
      remove_broke_players
      break if human_player.broke? || !play_again?
      reset
    end
    display_goodbye_message
  end

  private

  def initialize_ai_players(number)
    players = []
    return players if number == 0
    number.times {players << AIPlayer.new}
    players
  end

  def how_many_ai_players
    choice = nil
    loop do
      puts ""
      puts "How many AI players will be joining you at the table? (0-7)"
      choice = gets.chomp
      break unless choice =~ /\D/ || !choice.to_i.between?(0, 7)
      puts "Sorry, that's not a valid choice."
    end
    choice.to_i
  end

  def collect_bets
    players.each {|player| player.make_bet}
  end

  def deal_cards
    2.times { deck.deal(dealer) }
    players.each do |player|
      2.times { deck.deal(player) }
    end
  end

  def player_turns
    @player_turns = true
    players.each do |player|
      display_game_state_and_clear
      start_turn(player)
      play_cards(player)
    end
  end

  def play_cards(player)
   loop do
      display_game_state_and_clear
      break unless player.hit?(dealer.first_card_total)
      hit(player)
      break if player.busted?
    end
    display_turn_result(player)
  end

  def start_turn(player)
    puts "The dealer turns to #{player.name}."
    press_enter_and_clear
  end

  def dealer_turn
    @player_turns = false
    display_game_state_and_clear
    puts "The dealer reveals her hidden card. It's the #{dealer.hand.last}!"
    press_enter_and_clear
    while dealer.total < DEALER_STANDS
      hit(dealer)
      display_game_state_and_clear
    end
    display_game_state_and_clear
  end

  def hit(participant)
    deck.deal(participant)
    show_hit(participant)
  end
  
  def show_hit(participant)
    puts "#{participant.name} takes a card. It's the #{participant.hand.last}!"
    press_enter_and_clear
  end

  def show_all_results
    # press enter to show results
    players.each {|player| show_result(player)}
  end

  def show_result(player)
    if player.busted?
      puts "#{player.name} busted!"
    elsif dealer.busted?
      puts "#{player.name} wins since the dealer busted!"
    else
      display_point_winner(player)
    end
  end

  def display_point_winner(player)
    case dealer.total <=> player.total
    when 1 then puts "#{player.name} loses to the dealer on points!"
    when -1 then puts "#{player.name} beats the dealer on points!"
    when 0 then puts "#{player.name} ties the dealer!"
    end
  end

  def settle_bets
    players.each {|player| player.settle_bet(dealer.total)}
  end

  def everyone_busted?
    players.all? {|player| player.busted?}
  end

  def play_again?
    choice = nil
    loop do
      puts ""
      puts "Would you like to play again? (y/n)"
      choice = gets.chomp.downcase
      break if %w(y n).include?(choice)
      puts "Sorry, invalid choice."
    end
    choice == 'y'
  end

  def remove_broke_players
    players.each {|player| remove(player) if (player.broke?)}
  end

  def remove(player)
    puts ""
    puts "All out of money, #{player.name} leaves the table and walks away sadly."
    players.delete(player) unless player == @human_player
  end

  def reset
    deck.new_deck
    dealer.discard_hand
    players.each { |player| player.discard_hand }
  end

  attr_reader :deck, :human_player, :dealer, :players
end

Game.new.start
