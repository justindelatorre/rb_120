=begin
Assignment begins here: https://launchschool.com/lessons/dfff5f6b/assignments/180e267e
=end

class Player
  def initialize

  end

  def choose

  end
end

class Move
  def initialize

  end
end

class Rule
  def initialize

  end
end

def compare(move1, move2)

end

class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Player.new
    @computer = Player.new
  end

  def play
    # Potential subprocesses:
    # - display_welcome_message
    human.choose # - human_choose_move
    computer.choose # - computer_choose_move
    # - display_winner
    # - display_goodbye_message
  end
end
