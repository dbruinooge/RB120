class GuessingGame
  def initialize(low, high)
    @low = low
    @high = high
    @guesses = Math.log2(@high - @low).to_i + 1
    @target = nil
  end

  def play
    @target = rand(@high - @low + 1) + @low
    loop do
      display_remaining_guesses
      guess = obtain_guess
      show_result(guess)
      break if correct?(guess)
      @guesses -= 1
      if no_more_guesses?
        puts "You have no more guesses. You lost!"
        break
      end
    end
  end
  
  private

  def display_remaining_guesses
    if @guesses == 1
      puts "You have 1 guess remaining."
    else
      puts "You have #{@guesses} guesses remaining."
    end
  end

  def obtain_guess
    guess = nil
    loop do
      print "Enter a number between #{@low} and #{@high}: "
      guess = gets.chomp.to_i
      break if guess.between?(@low, @high)
      print "Invalid guess. "
    end
    guess
  end

  def show_result(guess)
    if guess > @target
      puts "Your guess is too high."
    elsif guess < @target
      puts "Your guess is too low."
    else
      puts "That's the number!"
    end
  end

  def correct?(guess)
    guess == @target
  end

  def no_more_guesses?
    @guesses <= 0
  end
end

GuessingGame.new(501, 1500).play
