=begin
Assignment begins here: https://launchschool.com/lessons/dfff5f6b/assignments/180e267e
=end

require 'yaml'
MESSAGES = YAML.load_file('oo_rps.yml')

class Move
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']

  attr_reader :value

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
    (rock? && (other.scissors? || other.lizard?)) ||
      (paper? && (other.rock? || other.spock?)) ||
      (scissors? && (other.paper? || other.lizard?)) ||
      (lizard? && (other.paper? || other.spock)) ||
      (spock? && (other.rock? || other.scissors?))
  end

  def <(other)
    (rock? && (other.paper? || other.spock?)) ||
      (paper? && (other.scissors? || other.lizard?)) ||
      (scissors? && (other.rock? || other.spock?)) ||
      (lizard? && (other.rock? || other.scissors?)) ||
      (spock? && (other.paper? || other.lizard?))
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
    puts MESSAGES['divider']
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
  WINNING_SCORE = 5

  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts MESSAGES['divider']
    puts MESSAGES['welcome']
  end

  def display_moves
    puts MESSAGES['divider']
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def display_winner
    puts MESSAGES['divider']
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
    puts MESSAGES['divider']
    puts "#{human.name}: #{human.score}"
    puts "#{computer.name}: #{computer.score}"
  end

  def display_all_moves
    puts MESSAGES['divider']
    puts "Moves by round:"
    0.upto(human.moves.size - 1) do |idx|
      puts "ROUND #{idx + 1} - #{human.name}: #{human.moves[idx].value} | "\
           "#{computer.name}: #{computer.moves[idx].value}"
    end 
  end

  def display_goodbye_message
    puts MESSAGES['divider']
    puts MESSAGES['goodbye']
  end

  def play_again?
    puts MESSAGES['divider']
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
    puts MESSAGES['divider']
    if human.score == WINNING_SCORE
      puts "#{human.name} won the series with #{human.score} wins!"
    elsif computer.score == WINNING_SCORE
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
      display_all_moves

      break if series_over?
      break unless play_again?
    end

    display_series_winner

    display_goodbye_message
  end
end

RPSGame.new.play
