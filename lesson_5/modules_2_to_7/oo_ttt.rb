=begin
Assignment: https://launchschool.com/lessons/97babc46/assignments/7dcb53f1
=end

require 'yaml'
MESSAGES = YAML.load_file('oo_ttt.yml')

module Textable
  def joinor(arr, delim=', ', conj='or')
    case arr.size
    when 0 then ''
    when 1 then arr.first
    when 2 then arr.join(" #{conj} ")
    else
      arr[-1] = "#{conj} #{arr.last}"
      arr.join(delim)
    end
  end
end

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                  [[1, 5, 9], [3, 5, 7]]

  attr_reader :squares

  def initialize
    @squares = {}
    reset
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

  def get_square_at(key)
    @squares[key]
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

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    Board::WINNING_LINES.each do |line|
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

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end
end

class Square
  INITIAL_MARKER = ' '

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
  MARKERS = ['X', 'O']

  attr_accessor :score
  attr_reader :marker, :name

  def initialize
    @score = 0
  end
end

class Human < Player
  def initialize
    super
    @name = set_name
    @marker = set_marker
  end

  private

  def set_name
    puts MESSAGES['player_name'] 
    gets.chomp
  end

  def set_marker
    answer = nil
    loop do
      puts "Select your marker: #{MARKERS.join(' or ')}"
      answer = gets.chomp.upcase
      break if MARKERS.include?(answer)
      puts "Sorry, you can only select #{MARKERS.join(' or ')}."
    end

    answer
  end
end

class Computer < Player
  def initialize
    super
    @name = set_name
    @marker = set_marker
  end

  private

  def set_name
    puts MESSAGES['opponent_name'] 
    gets.chomp
  end

  def set_marker
    answer = nil
    loop do
      puts "Select your opponent's marker: #{MARKERS.join(' or ')}"
      answer = gets.chomp.upcase
      break if MARKERS.include?(answer)
      puts "Sorry, you can only select #{MARKERS.join(' or ')}."
    end

    answer
  end
end

class TTTGame
  include Textable

  WINNING_SCORE = 3

  attr_reader :board, :human, :computer

  def initialize
    @board = Board.new
    @human = Human.new
    @computer = Computer.new
    @current_marker = human.marker
    @first_to_move = human.marker
  end

  def play
    clear
    display_welcome_message
    main_game
    display_game_winner
    display_goodbye_message
  end

  private

  def clear
    system('clear') || system('cls')
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe, #{human.name}!"
    puts ""
  end

  def main_game
    loop do
      display_board
      player_move
      display_result
      award_point
      break if player_wins?
      break unless play_again?
      reset
      display_play_again_message
    end
  end

  def human_wins?
    human.score == WINNING_SCORE
  end

  def computer_wins?
    computer.score == WINNING_SCORE
  end

  def player_wins?
    human_wins? || computer_wins?
  end

  def display_game_winner
    if human_wins?
      puts "#{human.name} wins with #{WINNING_SCORE} wins!"
    elsif computer_wins?
      puts "#{computer.name} wins with #{WINNING_SCORE} wins!"
    else
      puts MESSAGES['tie'] 
    end
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe, #{human.name}!"
  end

  def display_board
    puts "#{human.name} is a #{human.marker}. "\
         "#{computer.name} is a #{computer.marker}."
    puts ""
    board.draw
    puts ""
  end

  def player_move
    loop do
      current_player_moves
      break if board.someone_won? || board.full?
      clear_screen_and_display_board if human_turn?
    end
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def human_turn?
    @current_marker == human.marker
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

  def human_moves
    square = nil
    puts "Choose a square between (#{joinor(board.unmarked_keys)}):"
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end

    board[square] = human.marker
  end

  def find_at_risk_square(line, brd, marker)
    squares = brd.squares
    line_squares = brd.squares.values_at(*line)

    return nil if line_squares.map(&:marker).count(marker) < 2

    squares.select do |k, v|
      line.include?(k) && v.marker == Square::INITIAL_MARKER
    end.keys.first
  end

  def find_advantage_square_for(marker)
    square = nil

    Board::WINNING_LINES.each do |line|
      square = find_at_risk_square(line, board, marker)
      break if square
    end

    square
  end

  def computer_moves
    square = 5 if board.squares[5].marker == Square::INITIAL_MARKER

    square = find_advantage_square_for(computer.marker) if !square

    square = find_advantage_square_for(human.marker) if !square

    square = board.unmarked_keys.sample if !square

    board[square] = computer.marker
  end

  def display_result
    clear_screen_and_display_board

    case board.winning_marker
    when human.marker
      puts "#{human.name} won!"
    when computer.marker
      puts "#{computer.name} won!"
    else
      puts MESSAGES['tie']
    end
  end

  def award_point
    case board.winning_marker
    when human.marker
      human.score += 1
    when computer.marker
      computer.score += 1
    end
  end

  def play_again?
    answer = nil
    loop do
      puts MESSAGES['ask_play_again'] 
      answer = gets.chomp.downcase
      break if %w(y n).include?(answer)
      puts MESSAGES['invalid_y_n']
    end

    answer == 'y'
  end

  def reset
    board.reset
    @current_marker = human.marker
    clear
  end

  def display_play_again_message
    puts MESSAGES['play_again'] 
    puts ""
  end
end

game = TTTGame.new
game.play
