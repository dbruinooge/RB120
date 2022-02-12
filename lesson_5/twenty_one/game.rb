require 'pry'
require './deck'
require './player'
require './dealer'

class Game
  def initialize
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
  end

  def start
    loop do
      deal_cards
      show_initial_cards
      player_turn
      dealer_turn unless player.busted?
      show_result
      break unless play_again?
      reset
    end
  end

  private

  def deal_cards
    2.times { deck.deal(player) }
    2.times { deck.deal(dealer) }
  end

  def show_initial_cards
    puts "You have #{player.describe_hand}."
    puts "Dealer has #{dealer.hand[0]} and one card face down."
  end

  def show_all_cards
    puts "Player has #{player.describe_hand}."
    puts "Dealer has #{dealer.describe_hand}."
  end

  def show_totals
    puts "Player has #{player.total}. Dealer has #{dealer.total}."
  end

  def player_turn
    loop do
      show_totals
      break unless hit?
      hit_player
      show_initial_cards
      if player.busted?
        show_totals
        break
      end
    end
  end

  def dealer_turn
    while dealer.total < 17
      hit_dealer
      show_all_cards
      show_totals
    end
  end

  def hit?
    loop do
      puts "Hit? (y/n)"
      choice = gets.chomp.downcase
      return true if ['y', 'yes'].include?(choice)
      return false if ['n', 'no'].include?(choice)
      puts "Invalid input."
    end
  end

  def hit_player
    deck.deal(player)
    puts "Player takes a card. It's the #{player.hand.last}!"
  end

  def hit_dealer
    puts "Dealer takes a card. It's the #{dealer.hand.last}!"
    deck.deal(dealer)
  end

  def show_result
    if player.busted?
      puts "Player busted. Dealer wins!"
    elsif dealer.busted?
      puts "Dealer busted. Player wins!"
    else
      display_point_winner
    end
  end

  def display_point_winner
    case dealer.total <=> player.total
    when 1 then puts "Dealer wins!"
    when -1 then puts "Player wins!"
    when 0 then puts "It's a tie!"
    end
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

  def reset
    deck.new_deck
    player.discard_hand
    dealer.discard_hand
  end

  attr_reader :deck, :player, :dealer
end

Game.new.start
