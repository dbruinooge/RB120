module Printable
  def display_game_state
    dealer_total = @player_turns ? dealer.first_card_total : dealer.total
    dealer_cards = @player_turns ? dealer.hand.first : dealer.list_cards
    system 'clear'
    puts 'PARTICIPANT'.ljust(30) + 'CARDS' + 'TOTAL'.rjust(30)
    puts '===================================================================='
    puts dealer.name.ljust(30) + dealer_cards.to_s + dealer_total.to_s.rjust(30)
    puts '--------------------------------------------------------------------'
    display_participant(human_player)
    ai_players.each {|ai_player| display_participant(ai_player)}
    puts ""
  end
  
  def display_participant(participant)
    puts participant.name.ljust(30) + participant.list_cards + participant.total.to_s.rjust(30)
  end
  
  # def show_initial_cards
  #   puts "You have #{player.list_cards}."
  #   ai_players.each do |ai_player|
  #     puts "#{ai_player.name} has #{ai_player.list_cards}."
  #   end
  #   puts "Dealer has #{dealer.hand.first} and one card face down."
  # end

  # def show_all_cards
  #   puts "Player has #{player.list_cards}."
  #   ai_players.each do |ai_player|
  #     puts "#{ai_player.name} has #{ai_player.list_cards}."
  #   end
  #   puts "Dealer has #{dealer.list_cards}."
  # end

  # def show_totals_player_turns
  #   puts "Player has #{player.total}. Dealer has #{dealer.first_card_total}."
  # end
  
  # def show_totals_dealer_turn
  #   puts "Player has #{player.total}. Dealer has #{dealer.total}."
  # end
end

    # printf "%-20s %s\n", 'PARTICIPANT', 'CARDS' <- can't get it to print a third column