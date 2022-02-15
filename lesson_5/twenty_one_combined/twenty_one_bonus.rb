module Displayable
  private

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
    puts "#{participant.name} takes a card. It's the #{participant.hand.last}!"
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
      puts "All out of money, you leave the table and sadly walk away."
    else
      puts "You calmly collect your remaining chips worth "\
           "$#{human_player.bankroll} and leave the table."
    end
    puts ""
    puts "Goodbye!"
  end
end

module Betable
  attr_reader :bankroll, :bet
  attr_accessor :result

  def give_up_losses
    @bankroll -= @bet
  end

  def collect_winnings
    @bankroll += bet
  end

  def broke?
    @bankroll <= 0
  end
end

class Game
  include Displayable

  MIN_AI_PLAYERS = 0
  MAX_AI_PLAYERS = 7

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
    number.times { players << AIPlayer.new }
    players
  end

  def how_many_ai_players
    choice = nil
    loop do
      prompt_number_of_ai_players
      choice = gets.chomp
      break unless choice =~ /\D/ ||
                   !choice.to_i.between?(MIN_AI_PLAYERS, MAX_AI_PLAYERS)
      puts "Sorry, that's not a valid choice."
    end
    choice.to_i
  end

  def prompt_number_of_ai_players
    puts ""
    puts "How many AI players will be joining you at the table? "\
         "(#{MIN_AI_PLAYERS}-#{MAX_AI_PLAYERS})"
  end

  def prepare_round
    collect_bets
    deal_cards
  end

  def collect_bets
    players.each(&:make_bet)
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

  def start_turn(player)
    name = player == human_player ? 'you' : player.name
    puts "The dealer turns to #{name}."
    press_enter_and_clear
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
    display_hit(participant)
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
    players.all?(&:busted?)
  end

  def play_again?
    choice = nil
    loop do
      puts ""
      puts "Would you like to play again? (y/n)"
      choice = gets.chomp.downcase
      break if %w(y yes n no).include?(choice)
      puts "Sorry, invalid choice."
    end
    choice == 'y'
  end

  def remove_broke_players
    broke_players = identify_broke_players
    broke_players.each do |broke_player|
      puts ""
      puts "All out of money, #{broke_player.name} leaves the table "\
           "and sadly walks away."
    end
    players.reject! { |player| broke_players.include?(player) }
  end

  def identify_broke_players
    players.each_with_object([]) do |player, broke_players|
      if (player.broke?) && player != @human_player
        broke_players << player
      end
    end
  end

  def reset
    deck.new_deck
    dealer.discard_hand
    players.each(&:discard_hand)
  end

  attr_reader :deck, :human_player, :dealer, :players
end

class Deck
  attr_accessor :deck

  SUITS = %w(Hearts Diamonds Spades Clubs)
  VALUES = %w(2 3 4 5 6 7 8 9 10 J Q K A)

  def initialize
    new_deck
  end

  def new_deck
    self.deck = []
    SUITS.each do |suit|
      VALUES.each do |value|
        deck << Card.new(value, suit)
      end
    end
    deck.shuffle!
  end

  def deal(participant)
    participant.hit(deck.pop)
  end
end

class Card
  SUIT_SYMBOLS = { 'Hearts' => "\u2665", 'Diamonds' => "\u2666",
                   'Spades' => "\u2660", 'Clubs' => "\u2663" }

  attr_reader :value

  def initialize(value, suit)
    @value = value
    @suit = suit
  end

  def to_s
    "#{value}#{SUIT_SYMBOLS[suit]}"
  end

  private

  attr_reader :suit
end

class Participant
  CARD_VALUES = { '2' => 2, '3' => 3, '4' => 4, '5' => 5, '6' => 6,
                  '7' => 7, '8' => 8, '9' => 9, '10' => 10, 'J' => 10,
                  'Q' => 10, 'K' => 10, 'A' => 11 }

  MAX_SCORE = 21

  attr_reader :hand, :name

  def initialize
    @hand = []
  end

  def hit(card)
    hand << card
  end

  def list_cards
    hand.join(', ')
  end

  def total
    total = 0
    hand.each { |card| total += CARD_VALUES[card.value] }
    aces = hand.select { |card| card.value == 'A' }.count
    while total > MAX_SCORE && aces > 0
      total -= 10
      aces -= 1
    end
    total
  end

  def busted?
    total > MAX_SCORE
  end

  def discard_hand
    @hand = []
  end
end

class Dealer < Participant
  DEALER_STANDS = 17

  def initialize
    super
    @name = 'Dealer'
  end

  def first_card_total
    Participant::CARD_VALUES[hand.first.value]
  end

  def hit?
    total < DEALER_STANDS
  end

  def list_cards
    hand.join(', ')
  end
end

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

  def hit?(dealer_first_card_total)
    return false if total == MAX_SCORE
    loop do
      display_hit_prompt(dealer_first_card_total)
      choice = gets.chomp.downcase
      return true if ['h', 'hit'].include?(choice)
      return false if ['s', 'stand'].include?(choice)
      puts "Sorry, that's not a valid choice."
    end
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

  def display_bet_prompt
    puts ""
    puts "You have $#{@bankroll}. Please enter the amount "\
         "you'd like to bet (1-#{@bankroll}):"
  end

  def display_hit_prompt(dealer_first_card_total)
    puts "You have #{total} and the dealer is showing "\
    "#{dealer_first_card_total}. Would you like to (h)it or (s)tand?"
  end
end

class AIPlayer < Participant
  include Betable

  INITIAL_BANKROLL = 1000

  def self.load_names_from_file
    name_list = []
    names = File.open("ai_names.txt")
    names.each do |line|
      name_list << line.chomp
    end
    name_list
  end

  @@name_list = load_names_from_file

  def initialize
    super
    @name = @@name_list.shuffle!.pop
    @bankroll = INITIAL_BANKROLL
  end

  def make_bet
    @bet = rand(@bankroll + 1).ceil(-2)
  end

  def hit?(dealer_first_card_total)
    if total <= 11
      true
    elsif total.between?(12, 16) && dealer_first_card_total.between?(7, 11)
      true
    elsif ace_and_six?
      true
    else
      false
    end
  end

  private

  def hand_values
    hand.map(&:value)
  end

  def ace_and_six?
    hand_values.include?('A') &&
      hand_values.include?('6') &&
      hand.size == 2
  end
end

Game.new.start
