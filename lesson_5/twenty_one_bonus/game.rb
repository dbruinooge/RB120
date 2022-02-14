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
  
  def initialize(number_of_ai_players=0)
    @deck = Deck.new
    @human_player = HumanPlayer.new
    @dealer = Dealer.new
    initialize_ai_players(number_of_ai_players)
  end

  def start
    loop do
      collect_bets
      deal_cards
      human_player_turn
      ai_player_turns
      dealer_turn unless everyone_busted?
      settle_bets
      show_all_results
      break unless play_again?
      reset
    end
  end

  private

  def initialize_ai_players(number)
    @ai_players = []
    number.times {@ai_players << AIPlayer.new}
  end

  def collect_bets
    human_player.make_bet
    ai_players.each {|ai_player| ai_player.make_bet}
  end

  def deal_cards
    2.times { deck.deal(human_player) }
    2.times { deck.deal(dealer) }
    ai_players.each do |ai_player|
      2.times { deck.deal(ai_player) }
    end
  end

  def human_player_turn
    @player_turns = true
    loop do
      display_game_state
      break unless hit?
      hit(human_player)
      if human_player.busted?
        display_game_state
        break
      end
    end
  end

  def ai_player_turns
    @player_turns = true
    ai_players.each do |ai_player|
      display_game_state
      start_turn(ai_player)
      loop do
        unless ai_hit?(ai_player)
          puts "#{ai_player.name} stands on #{ai_player.total}!"
          break
        end
        hit(ai_player)
        display_game_state
        break if ai_player.busted?
      end
      press_enter
    end
  end

  def start_turn(ai_player)
    puts "The dealer turns to #{ai_player.name}."
    press_enter
  end

  def dealer_turn
    @player_turns = false
    display_game_state
    while dealer.total < 17
      hit(dealer)
    end
    display_game_state
  end

  def hit?
    return false if human_player.total == 21
    loop do
      puts "You have #{human_player.total} and the dealer is showing "\
           "#{dealer.first_card_total}. Would you like to hit? (y/n)"
      choice = gets.chomp.downcase
      return true if ['y', 'yes'].include?(choice)
      return false if ['n', 'no'].include?(choice)
      puts "Invalid input."
    end
  end

  def ai_hit?(ai_player)
    case
    when ai_player.total <= 11
      return true
    when ai_player.total.between?(12, 16) && dealer.first_card_total.between?(7, 11)
      return true
    when ai_player.ace_and_six?
      return true
    else
      return false
    end
  end

  def hit(participant)
    deck.deal(participant)
    show_hit(participant)
  end
  
  def show_hit(participant)
    puts "#{participant.name} takes a card. It's the #{participant.hand.last}!"
    puts "#{participant.name} busted!" if participant.busted?
    press_enter
  end

  def show_all_results
    # press enter to show results
    show_result(human_player)
    ai_players.each {|ai_player| show_result(ai_player)}
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
    human_player.settle_bet(dealer.total)
    ai_players.each {|ai_player| ai_player.settle_bet(dealer.total)}
  end

  def everyone_busted?
    human_player.busted? &&
    ai_players.all? {|ai_player| ai_player.busted?}
  end

  def play_again?
    choice = nil
    loop do
      puts "Would you like to play again? (y/n)"
      choice = gets.chomp.downcase
      break if %w(y n).include?(choice)
      puts "Sorry, invalid choice."
    end
    choice == 'y'
  end

  def remove_broke_players
    ai_players.each {|ai_player| remove(ai_player) if ai_player.broke? }
  end

  def remove(player)
    puts "All out of money, #{player.name} leaves the table and walks away sadly."
    ai_players.delete(player)
  end

  def reset
    deck.new_deck
    human_player.discard_hand
    dealer.discard_hand
    ai_players.each { |ai_player| ai_player.discard_hand }
  end

  def press_enter
    puts "Press ENTER to continue..."
    gets.chomp
  end

  attr_reader :deck, :human_player, :dealer, :ai_players
end

Game.new(7).start
