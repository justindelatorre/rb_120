=begin
Assignment begins here: https://launchschool.com/lessons/dfff5f6b/assignments/180e267e
=end

require 'yaml'
MESSAGES = YAML.load_file('oo_rps.yml')

class Move
  attr_reader :value, :beats

  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']

  def >(other)
    @beats.include?(other.to_s)
  end

  def to_s
    @value
  end
end

class Rock < Move
  def initialize
    @value = 'rock'
    @beats = ['scissors', 'lizard']
  end
end

class Paper < Move
  def initialize
    @value = 'paper'
    @beats = ['rock', 'spock']
  end
end

class Scissors < Move
  def initialize
    @value = 'scissors'
    @beats = ['paper', 'lizard']
  end
end

class Lizard < Move
  def initialize
    @value = 'lizard'
    @beats = ['paper', 'spock']
  end
end

class Spock < Move
  def initialize
    @value = 'spock'
    @beats = ['rock', 'scissors']
  end
end

class Player
  attr_accessor :move, :name, :score, :moves

  OBJECTS = {
    'rock' => Rock.new,
    'paper' => Paper.new,
    'scissors' => Scissors.new,
    'lizard' => Lizard.new,
    'spock' => Spock.new
  }

  def initialize
    @score = 0
    @moves = []
    set_name
  end

  def add_move(mv)
    @moves << mv
  end

  def to_s
    @name
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
      break if Player::OBJECTS.keys.include?(choice)
      puts MESSAGES['invalid_choice']
    end

    self.move = Player::OBJECTS[choice]
    add_move(move)
  end
end

class Computer < Player
  attr_accessor :name
end

class R2D2 < Computer
  def set_name
    @name = 'R2D2'
  end

  def choose
    self.move = Player::OBJECTS['rock']
    add_move(move)
  end
end

class Hal < Computer
  def set_name
    @name = 'Hal'
  end

  def choose
    random = (rand * 100).round(0)
    self.move = if random < 50
                  Player::OBJECTS['rock']
                elsif random >= 50 && random < 69
                  Player::OBJECTS['scissors']
                else
                  Player::OBJECTS['lizard']
                end
    add_move(move)
  end
end

class Chappie < Computer
  def set_name
    @name = 'Chappie'
  end

  def choose
    random = (rand * 100).round(0)
    self.move = if random <= 50
                  Player::OBJECTS['lizard']
                else
                  Player::OBJECTS['spock']
                end
    add_move(move)
  end
end

class Sonny < Computer
  def set_name
    @name = 'Sonny'
  end

  def choose
    selection = Move::VALUES.sample
    self.move = Player::OBJECTS[selection]
    add_move(move)
  end
end

class Number5 < Computer
  def set_name
    @name = 'Number 5'
  end

  def choose
    self.move = Player::OBJECTS['paper']
    add_move(move)
  end
end

class RPSGame
  WINNING_SCORE = 10

  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = [R2D2.new, Hal.new, Chappie.new, Sonny.new, Number5.new].sample
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
    human_move = human.move
    computer_move = computer.move
    if human_move > computer_move
      puts "#{human} won!"
    elsif computer_move > human_move
      puts "#{computer} won!"
    else
      puts MESSAGES['tie']
    end
  end

  def update_score
    human_move = human.move
    computer_move = computer.move
    if human_move > computer_move
      human.score += 1
    elsif computer_move > human_move
      computer.score += 1
    end
  end

  def display_score
    puts MESSAGES['divider']
    puts "#{human}: #{human.score}"
    puts "#{computer}: #{computer.score}"
  end

  def display_all_moves(plyr1, plyr2)
    puts MESSAGES['divider']
    [plyr1, plyr2].each do |plyr|
      puts plyr
      plyr.moves.each_with_index do |move, idx|
        puts "ROUND #{idx + 1}: #{move}"
      end
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
    human_score = human.score
    computer_score = computer.score
    if human_score == WINNING_SCORE
      puts "#{human} won the series with #{human_score} wins!"
    elsif computer_score == WINNING_SCORE
      puts "#{computer} won the series with #{computer_score} wins!"
    else
      puts MESSAGES['no_series_winner']
    end
  end

  def match_play
    system('clear') || system('cls')
    human.choose
    computer.choose
    display_moves
    display_winner
    update_score
    display_score
    display_all_moves(human, computer)
  end

  def play
    display_welcome_message
    loop do
      match_play
      break if series_over?
      break unless play_again?
    end
    display_series_winner
    display_goodbye_message
  end
end

RPSGame.new.play
