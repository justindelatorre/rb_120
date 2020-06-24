=begin
Assignment begins here: https://launchschool.com/lessons/dfff5f6b/assignments/180e267e
=end

require 'yaml'
MESSAGES = YAML.load_file('oo_rps.yml')

class Move
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']

  def initialize(value)
    @value = value
  end

  def scissors?
    @value == 'scissors'
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def lizard?
    @value == 'lizard'
  end

  def spock?
    @value == 'spock'
  end

  def >(other)
    (rock? && other.scissors?) ||
      (paper? && other.rock?) ||
      (scissors? && other.paper?)
  end

  def <(other)
    (rock? && other.paper?) ||
      (paper? && other.scissors?) ||
      (scissors? && other.rock?)
  end

  def to_s
    @value
  end
end

#TODO: Fill out these subclasses.
class Rock < Move
end

class Paper < Move
end

class Scissors < Move
end

class Lizard < Move
end

class Spock < Move
end

class Player
  attr_accessor :move, :name, :score, :moves

  def initialize
    @score = 0
    @moves = []
    set_name
  end

  def add_move(mv)
    @moves << mv
  end
end

class Human < Player
  def set_name
    n = ''
    loop do
      puts MESSAGES['request_name']
      n = gets.chomp
      break unless n.empty?
      puts MESSAGES['no_value']
    end
    self.name = n
  end

  def choose
    choice = nil

    loop do
      puts MESSAGES['player_choose']
      choice = gets.chomp
      break if Move::VALUES.include?(choice)
      puts MESSAGES['invalid_choice']
    end

    self.move = Move.new(choice)
    add_move(self.move)
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
    add_move(self.move)
  end
end

class RPSGame
  WINNING_SCORE = 2

  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts MESSAGES['welcome']
  end

  def display_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def display_winner
    if human.move > computer.move
      puts "#{human.name} won!"
      human.score += 1
    elsif human.move < computer.move
      puts "#{computer.name} won!"
      computer.score += 1
    else
      puts MESSAGES['tie'] 
    end
  end

  def display_score
    puts "#{human.name}: #{human.score}"
    puts "#{computer.name}: #{computer.score}"
  end

  def display_goodbye_message
    puts MESSAGES['goodbye']
  end

  def play_again?
    answer = nil

    loop do
      puts MESSAGES['play_again']
      answer = gets.chomp
      break if ['y', 'n'].include?(answer.downcase)
      puts MESSAGES['invalid_y_n'] 
    end

    ['Y', 'y'].include?(answer) ? true : false
  end

  def series_over?
    human.score == WINNING_SCORE || computer.score == WINNING_SCORE
  end

  def display_series_winner
    puts "This is a placeholder."
  end

  def display_series_winner
    if human.score == WINNING_SCORE
      puts "#{human.name} won the series with #{human.score} wins!"
    elsif
      puts "#{computer.name} won the series with #{computer.score} wins!"
    else
      puts MESSAGES['no_series_winner'] 
    end
  end

  def play
    display_welcome_message

    loop do
      human.choose
      computer.choose
      display_moves
      display_winner
      display_score

      #TODO: Remove this.
      puts "#{human.name}'s moves: #{human.moves}"
      puts "#{computer.name}'s moves: #{computer.moves}"

      break if series_over?
      break unless play_again?
    end

    display_series_winner

    display_goodbye_message
  end
end

RPSGame.new.play
