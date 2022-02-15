require 'pry'

module Printable
  def display_welcome_message
    system 'clear'
    puts "Welcome to Twenty-One!"
    puts ""
    puts "The goal of Twenty-One is to beat the dealer's hand "\
         "without going over 21, or 'busting'."
    puts "Each player is dealt two cards, face up."
    puts "The dealer is also dealt two cards, but one of them is face down."
    puts "On each player's turn, they can choose whether to get another card ('hit') "\
         "or end their turn ('stand')."
    puts "On the dealer's turn, the dealer must hit until reaching a score of 17 or higher."
    puts ""
  end

  def display_game_state_and_clear
    system 'clear'
    dealer_total = @player_turns ? dealer.first_card_total : dealer.total
    dealer_cards = @player_turns ? "#{dealer.hand.first}, ?" : dealer.list_cards
    puts 'PARTICIPANT (BANKROLL, CURRENT BET)'.ljust(40) + 'CARDS (TOTAL)'
    puts '===================================================================='
    puts dealer.name.ljust(40) + "#{dealer_cards} (#{dealer_total})"
    puts '--------------------------------------------------------------------'
    display_participant(human_player)
    ai_players.each {|ai_player| display_participant(ai_player)}
    puts ""
  end

  def display_participant(participant)  # rename to display_player?
    print "#{participant.name} (#{participant.bankroll}, #{participant.bet})".ljust(40)
    puts "#{participant.list_cards} (#{participant.total})"
  end

  def display_goodbye_message
    puts ""
    if human_player.broke?
      puts "All out of money, you leave the table and walk away sadly."
    else
      puts "You calmly collect your remaining chips worth $#{human_player.bankroll}" \
           " and leave the table."
    end
  end
end
