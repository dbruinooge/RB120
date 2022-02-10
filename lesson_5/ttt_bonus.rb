require 'pry'

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  MIDDLE_SQUARE = 5

  def initialize
    @squares = {}
    reset
  end

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def game_winner?
    !!game_winning_marker
  end

  def game_winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  def immediate_danger?(marker)
    !!threat(marker)
  end

  def blocking_square(marker)
    threat(marker).find do |square|
      @squares[square].marker == Square::INITIAL_MARKER
    end
  end

  def immediate_opportunity?(marker)
    !!threat(marker)
  end

  def winning_square(marker)
    threat(marker).find do |square|
      @squares[square].marker == Square::INITIAL_MARKER
    end
  end

  def middle_empty?
    @squares[MIDDLE_SQUARE].marker == Square::INITIAL_MARKER
  end

  def strategic_move(current_marker, opponent_marker)
    if immediate_opportunity?(current_marker)
      winning_square(current_marker)
    elsif immediate_danger?(opponent_marker)
      blocking_square(opponent_marker)
    elsif middle_empty?
      Board::MIDDLE_SQUARE
    end
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end

  def threat(marker)
    threats = WINNING_LINES.select do |line|
      markers = markers_at_line(line)
      markers.count(marker) == 2 &&
        markers.count(Square::INITIAL_MARKER) == 1
    end
    threats.first
  end

  def markers_at_line(line)
    squares = @squares.values_at(*line)
    squares.collect(&:marker)
  end
end

class Square
  INITIAL_MARKER = " "

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end
end

class Player
  attr_reader :marker, :name, :score

  def initialize
    @name = set_name
    @marker = set_marker
    @score = 0
  end

  def set_name
    choice = nil
    loop do
      puts "Please enter your name:"
      choice = gets.chomp
      break if !choice.empty?
    end
    @name = choice
  end

  def set_marker
    marker = 'X'
    loop do
      puts "Choose a marker:"
      marker = gets.chomp
      break if marker.size == 1 && marker != 'O'
    end
    marker
  end
  
  def increment_score
    @score += 1
  end
end

class Computer < Player
  def set_name
    @name = %w(Data Hal R2D2 Sonny).sample
  end
  
  def set_marker
    @marker = 'O'
  end
end

class TTTGame
  WINNING_SCORE = 2

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Player.new
    @computer = Computer.new
    @current_marker = human.marker
  end

  def play
    clear
    display_welcome_message
    main_game
    display_match_result if match_winner?
    display_goodbye_message
  end

  private

  def main_game
    loop do
      display_board
      player_move
      display_game_result
      update_score
      break if match_winner? || !play_again?
      reset
      display_play_again_message
    end
  end

  def update_score
    case board.game_winning_marker
    when human.marker
      human.increment_score
    when computer.marker
      computer.increment_score
    end
  end

  def match_winner?
    [human.score, computer.score].include?(WINNING_SCORE)
  end

  def match_winning_marker
    if human.score == (WINNING_SCORE)
      human.marker
    elsif computer.score == (WINNING_SCORE)
      computer.marker
    end
  end

  def display_match_result
    match_winner = case match_winning_marker
                   when human.marker then @human
                   when computer.marker then @computer
                   end
    scores = [human.score, computer.score].sort
    puts "#{match_winner.name} wins the match, #{scores.max} to #{scores.min}!"
  end

  def player_move
    loop do
      current_player_moves
      break if board.game_winner? || board.full?
      clear_screen_and_display_board if human_turn?
    end
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe, #{human.name}!"
    puts ""
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe, #{human.name}! Goodbye!"
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def human_turn?
    @current_marker == human.marker
  end

  def display_board
    puts "You're a #{human.marker}. Computer is a #{computer.marker}."
    puts ""
    board.draw
    puts ""
  end

  def joinor(arr, delimiter=', ', word='or')
    case arr.size
    when 0 then ''
    when 1 then arr.first
    when 2 then arr.join(" #{word} ")
    else
      arr[-1] = "#{word} #{arr.last}"
      arr.join(delimiter)
    end
  end

  def human_moves
    puts "Choose a square (#{joinor(board.unmarked_keys)}): "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end

    board[square] = human.marker
  end

  def computer_moves
    strategy = board.strategic_move(computer.marker, human.marker)
    if strategy
      board[strategy] = computer.marker
    else
      board[board.unmarked_keys.sample] = computer.marker
    end
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = computer.marker
    else
      computer_moves
      @current_marker = human.marker
    end
  end

  def display_game_result
    clear_screen_and_display_board

    case board.game_winning_marker
    when human.marker
      puts "You won!"
    when computer.marker
      puts "Computer won!"
    else
      puts "It's a tie!"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts "Sorry, must be y or n"
    end

    answer == 'y'
  end

  def clear
    system "clear"
  end

  def reset
    board.reset
    @current_marker = human.marker
    clear
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ""
  end
end

game = TTTGame.new
game.play
