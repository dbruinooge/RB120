require 'pry'
require './deck'
require './player'
require './dealer'

class Game
  attr_reader :deck, :player, :dealer
  
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
    puts "You have #{player.describe_hand}."
    puts "Dealer has #{dealer.describe_hand}."
  end
  
  def player_turn
    loop do
      puts "You have #{player.total}. Dealer has #{dealer.total}."
      if hit?
        puts "You take a card."
        deck.deal(player) 
      else
        break
      end
      show_initial_cards
      if player.busted?
        puts "You have #{player.total}. Dealer has #{dealer.total}."
        puts "You busted!"
        break
      end
    end
  end
  
  def dealer_turn
    while dealer.total < 17
      puts "Dealer takes a card."
      deck.deal(dealer)
      show_all_cards
      puts "You have #{player.total}. Dealer has #{dealer.total}."
    end
    puts "Dealer busted!" if dealer.busted?
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
  
  def show_result
    if player.busted?
      puts "Dealer wins!"
    elsif dealer.busted?
      puts "Player wins!"
    elsif dealer.total > player.total
      puts "Dealer wins!"
    elsif player.total > dealer.total
      puts "Player wins!"
    else
      puts "It's a tie!"
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
end

Game.new.start