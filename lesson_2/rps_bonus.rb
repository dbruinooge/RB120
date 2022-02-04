class Move
  def >(other)
    @beats.include?(other.to_s)
  end
end

class Lizard < Move
  def initialize
    @beats = ['paper', 'Spock']
  end

  def to_s
    'lizard'
  end
end

class Spock < Move
  def initialize
    @beats = ['scissors', 'rock']
  end

  def to_s
    'Spock'
  end
end

class Rock < Move
  def initialize
    @beats = ['scissors', 'lizard']
  end

  def to_s
    'rock'
  end
end

class Paper < Move
  def initialize
    @beats = ['rock', 'spock']
  end

  def to_s
    'paper'
  end
end

class Scissors < Move
  def initialize
    @beats = ['paper', 'lizard']
  end

  def to_s
    'scissors'
  end
end

class Player
  attr_accessor :move, :name

  def initialize
    set_name
  end
end

class Human < Player
  def set_name
    n = nil
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter a value."
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "Please choose rock, paper, scissors, lizard, or Spock:"
      choice = gets.chomp.downcase
      break if ['rock', 'paper', 'scissors', 'lizard', 'spock'].include?(choice)
      puts "Sorry, invalid choice."
    end
    self.move = string_to_move(choice)
  end

  def string_to_move(string)
    case string
    when 'rock' then Rock.new
    when 'paper' then Paper.new
    when 'scissors' then Scissors.new
    when 'lizard' then Lizard.new
    when 'spock' then Spock.new
    end
  end
end

class R2D2 < Player
  def set_name
    self.name = 'R2D2'
  end

  def choose
    self.move = Rock.new
  end
end

class Hal < Player
  def set_name
    self.name = 'Hal'
  end

  def choose
    self.move = case rand(10)
                when 0..6 then Scissors.new
                when 7 then Paper.new
                when 8 then Lizard.new
                when 9 then Spock.new
                end
  end
end

class Chappie < Player
  def set_name
    self.name = 'Chappie'
  end

  def choose
    self.move = [Rock, Paper, Scissors, Lizard, Spock].sample.new
  end
end

class History
  attr_accessor :score, :game_number
  attr_reader :move_history

  def initialize
    @score = {}
    @game_number = 1
    @move_history = {}
  end

  def record_game(move1, move2)
    move_history[game_number] = [move1, move2]
    self.game_number += 1
  end

  def add_score(player)
    score[player] += 1
  end
end

# Game Orchestration Engine
class RPSGame
  attr_accessor :human, :computer, :score, :history

  def initialize
    @human = Human.new
    @computer = [R2D2, Hal, Chappie].sample.new
    @history = History.new
    history.score = { human => 0, computer => 0 }
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors!"
  end

  def display_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def find_winner
    if human.move > computer.move
      human
    elsif computer.move > human.move
      computer
    end
  end

  def display_winner
    winner = find_winner
    history.add_score(winner) if winner
    if winner.nil?
      puts "It's a tie!"
    else
      puts "#{winner.name} won!"
    end
  end

  def display_score
    puts "The current score is: #{human.name} #{history.score[human]}, "\
                                "#{computer.name} #{history.score[computer]}."
  end

  def display_move_history
    history.move_history.each do |game, moves|
      puts "Game #{game}: #{human.name} chose #{moves[0]}, "\
           "#{computer.name} chose #{moves[1]}."
    end
  end

  def match_winner?
    history.score.values.include?(3)
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include?(answer)
      puts "Sorry, must be y or n."
    end
    answer == 'y'
  end

  def display_goodbye_message
    winner = history.score.key(10)
    puts "#{winner.name} wins the game!" if winner
    puts "Thanks for playing Rock, Paper, Scissors. Goodbye!"
  end

  def display_outcome
    display_moves
    display_winner
    display_score
    history.record_game(human.move, computer.move)
  end

  def play
    display_welcome_message
    loop do
      human.choose
      computer.choose
      display_outcome
      display_move_history
      break if match_winner? || !play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play
