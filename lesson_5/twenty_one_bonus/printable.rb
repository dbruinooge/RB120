module Displayable
  def display_welcome_message
    system 'clear'
    puts "Welcome to Twenty-One!"
    puts ""
    display_rules
  end

  def display_rules
    puts "The goal of Twenty-One is to beat the dealer's hand "\
         "without going over 21, or 'busting'."
    puts "Each player is dealt two cards, face up."
    puts "The dealer is also dealt two cards, but one of them is face down."
    puts "On each player's turn, they can choose to take another card ('hit') "\
         "or end their turn ('stand')."
    puts "On the dealer's turn, the dealer must hit "\
         "until reaching a score of 17 or higher."
    puts ""
  end

  def display_game_state_and_clear
    system 'clear'
    puts 'PARTICIPANT (BANKROLL, CURRENT BET)'.ljust(40) + 'CARDS (TOTAL)'
    puts '================================================================='
    display_dealer_details
    puts '-----------------------------------------------------------------'
    players.each { |player| display_player_details(player) }
    puts ""
  end

  def display_dealer_details
    dealer_total = @player_turns ? dealer.first_card_total : dealer.total
    dealer_cards = @player_turns ? "#{dealer.hand.first}, ?" : dealer.list_cards
    puts dealer.name.ljust(40) + "#{dealer_cards} (#{dealer_total})"
  end

  def display_player_details(player)
    print "#{player.name} (#{player.bankroll}, #{player.bet})".ljust(40)
    puts "#{player.list_cards} (#{player.total})"
  end

  def display_hit(participant)
    if participant == @human_player
      print "You take a card. "
    else
      print "#{participant.name} takes a card. "
    end
    puts "It's the #{participant.hand.last}!"
    press_enter_and_clear
  end

  def display_turn_result(player)
    if player.busted?
      puts "#{player.name} busted!"
    else
      puts "#{player.name} stands on #{player.total}!"
    end
    press_enter_and_clear
  end

  def press_enter_and_clear
    puts "Press ENTER to continue..."
    gets.chomp
    display_game_state_and_clear
  end

  def display_goodbye_message
    puts ""
    if human_player.broke?
      puts "All out of money, you leave the table and walk away sadly."
    else
      puts "You calmly collect your remaining chips worth "\
           "$#{human_player.bankroll} and leave the table."
    end
    puts ""
    puts "Goodbye!"
  end
end
