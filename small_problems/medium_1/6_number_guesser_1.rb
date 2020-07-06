=begin
https://launchschool.com/exercises/e4b17f84
=end

class GuessingGame
  def initialize
    reset
  end

  def play
    loop do
      display_guesses_left
      request_guess
      display_high_or_low
      break if guessed_correctly?
      decrement_guesses_left
      break if no_guesses_left?
    end

    end_game
    reset
  end

  private

  attr_reader :guesses, :num


  def display_guesses_left
    puts "You have #{guesses_left} guesses remaining."
  end

  def request_guess
    answer = nil

    loop do
      print "Enter a number between 1 and 100: "
      answer = gets.chomp.to_i
      break if (1..100).include?(answer)
      print "Invalid guess. "
    end

    @player_guess = answer
  end

  def display_high_or_low 
    if @player_guess > @num
      puts "Your guess is too high."
    elsif @player_guess < @num
      puts "Your guess is too low." 
    end
  end

  def decrement_guesses_left
    @guesses_left -= 1
  end

  def no_guesses_left?
    guesses_left <= 0
  end

  def guessed_correctly?
    @player_guess == @num
  end

  def end_game
    if guesses_left.zero?
      puts "You have no more guesses. You lost!"
    else
      puts "That's the number!"
    end
  end

  def reset
    @num = (1..100).to_a.sample
    @guesses_left = 7
    @player_guess = nil
  end

  def guesses_left
    @guesses_left
  end
end

game = GuessingGame.new

# First game
game.play

# Second, new game
game.play
