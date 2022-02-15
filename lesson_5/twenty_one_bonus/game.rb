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

  def initialize
    display_welcome_message
    @deck = Deck.new
    @dealer = Dealer.new
    @human_player = HumanPlayer.new
    @players = [@human_player] + initialize_ai_players(how_many_ai_players)
  end

  def start
    loop do
      prepare_round
      player_turns
      dealer_turn unless everyone_busted?
      finish_round
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

  def prepare_round
    collect_bets
    deal_cards
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
    name = (player == human_player) ? 'you' : player.name
    puts "The dealer turns to #{name}."
    press_enter_and_clear
  end

  def dealer_turn
    @player_turns = false
    reveal_hidden_card
    while dealer.hit?
      hit(dealer)
    end
    display_turn_result(dealer)
  end

  def reveal_hidden_card
    display_game_state_and_clear
    puts "Dealer reveals the hidden card. It's the #{dealer.hand.last}!"
    press_enter_and_clear
  end

  def hit(participant)
    deck.deal(participant)
    show_hit(participant)
  end
  
  def show_hit(participant)
    name = (participant == human_player) ? 'you' : participant.name
    puts "#{name} takes a card. It's the #{participant.hand.last}!"
    press_enter_and_clear
  end

  def finish_round
    handle_results
    remove_broke_players
  end

  def handle_results
    players.each do |player|
      if player.busted? || dealer.busted?
        handle_busted_results(player)
      elsif player.total != dealer.total
        handle_point_results(player)
      else puts "#{player.name} ties the dealer!"
      end
    end
  end

  def handle_busted_results(player)
    if player.busted?
      player.give_up_losses
      puts "#{player.name} busted!"
    elsif dealer.busted?
      player.collect_winnings
      puts "#{player.name} wins since the dealer busted!"
    end
  end

  def handle_point_results(player)
    case player.total <=> dealer.total
    when 1
      puts "#{player.name} beats the dealer on points!"
      player.collect_winnings
    when -1
      puts "#{player.name} loses to the dealer on points!"
      player.give_up_losses
    end
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
    players.each do |player|
      remove(player) if (player.broke?) && player != @human_player
    end
  end

  def remove(player)
    puts ""
    puts "All out of money, #{player.name} leaves the table and walks away sadly."
    players.delete(player)
  end

  def reset
    deck.new_deck
    dealer.discard_hand
    players.each { |player| player.discard_hand }
  end

  attr_reader :deck, :human_player, :dealer, :players
end

Game.new.start
