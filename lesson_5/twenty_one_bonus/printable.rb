module Printable
  def display_game_state
    dealer_total = @player_turns ? dealer.first_card_total : dealer.total
    dealer_cards = @player_turns ? dealer.hand.first : dealer.list_cards
    system 'clear'
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
end

    # printf "%-20s %s\n", 'PARTICIPANT', 'CARDS' <- can't get it to print a third column