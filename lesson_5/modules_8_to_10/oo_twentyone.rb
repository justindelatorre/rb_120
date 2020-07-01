=begin
Assignment: https://launchschool.com/lessons/97babc46/assignments/819bf113
=end

DIVIDER = '=' * 50

class Participant
  attr_accessor :hand
  attr_reader :name

  def initialize
    @hand = []
  end

  def hit!(deck)
    @hand << deck.deal!
  end

  def stay
    'stay'
  end

  def busted?
    total > Game::BUST_LIMIT
  end

  def calculate_raw_score
    @hand.map do |card|
      if card[0] == 'Ace'
        11
      elsif card[0].to_i == 0
        10
      else
        card[0].to_i
      end
    end.sum
  end

  def adjust_score_for_aces(raw_score)
    adjusted_score = raw_score
    @hand.select { |card| card[0] == 'Ace' }.count.times do
      adjusted_score -= 10 if adjusted_score > 21
    end

    adjusted_score
  end

  def total
    score = calculate_raw_score
    score = adjust_score_for_aces(score)

    score
  end

  def display_hand
    hand_str = @hand.map { |card| "#{card[0]} of #{card[1]}" }.join(', ')

    puts "#{name} has " + hand_str + " for a total of #{total}."
  end
end

class Player < Participant
  def initialize
    super
    @name = set_name
  end

  def set_name
    puts DIVIDER
    answer = nil

    loop do
      puts "What is your name?"
      answer = gets.chomp
      break if !answer.empty?
      puts "Please input your name."
    end

    answer
  end
end

class Dealer < Participant
  def initialize
    super
    @name = set_name
  end

  def set_name
    'Dealer'
  end

  def display_initial_hand
    puts "#{name} has a #{@hand[0][0]} of #{@hand[0][1]} and UNKNOWN."
  end
end

class Deck
  SUITS = ['Diamonds', 'Clubs', 'Hearts', 'Spades']
  VALUES = ['2', '3', '4', '5', '6', '7', '8', '9',
            '10', 'Jack', 'Queen', 'King', 'Ace']

  attr_accessor :cards

  def initialize
    @cards = reset_deck
  end

  def deal!
    @cards.pop
  end

  def reset_deck
    deck = []

    SUITS.each do |suit|
      VALUES.each do |value|
        deck.push([value, suit])
      end
    end

    deck.shuffle
  end
end

class Card
  attr_reader :suit, :value

  def initialize(suit, value)
    @suit = suit
    @value = value
  end
end

class Game
  STARTING_HAND_SIZE = 2
  BUST_LIMIT = 21

  attr_accessor :deck, :player, :dealer

  def initialize
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
    @winner = nil
  end

  def play
    loop do
      deal_cards!
      display_initial_cards
      player_turn
      dealer_turn unless player.busted?
      show_result
      determine_winner
      declare_winner
      play_again? ? reset : break
    end
  end

  def start
    clear
    display_welcome_message
    play
    display_goodbye_message
  end

  def clear
    system('clear') || system('cls')
  end

  def display_welcome_message
    puts "Welcome to Twenty-One, #{player.name}!"
    puts ""
  end

  def display_goodbye_message
    puts DIVIDER
    puts "Thanks for playing Twenty-One, #{player.name}!"
  end

  def deal_cards!
    STARTING_HAND_SIZE.times do |_|
      player.hand << deck.deal!
      dealer.hand << deck.deal!
    end
  end

  def display_initial_cards
    puts DIVIDER
    player.display_hand
    dealer.display_initial_hand
  end

  def select_hit_or_stay
    puts DIVIDER
    answer = nil
    loop do
      puts "Do you want to hit or stay?"
      answer = gets.chomp.downcase
      break if ['hit', 'stay'].include?(answer)
      puts "Sorry, please select hit or stay."
    end

    answer
  end

  def player_turn
    answer = select_hit_or_stay

    while answer == 'hit'
      puts "You chose to hit!"
      player.hit!(deck)
      player.display_hand
      break if player.busted? || answer == 'stay'
      answer = select_hit_or_stay
    end
  end

  def dealer_turn
    while dealer.total < 17
      dealer.hit!(deck)
    end
  end

  def show_result
    puts DIVIDER
    player.display_hand
    dealer.display_hand
  end

  def player_beats_dealer?
    player.total > dealer.total && !player.busted?
  end

  def dealer_beats_player?
    dealer.total > player.total && !dealer.busted?
  end

  def determine_winner
    player_name = player.name
    dealer_name = dealer.name
    @winner = if player.busted? || dealer_beats_player?
                dealer_name
              elsif dealer.busted? || player_beats_dealer?
                player_name
              end
  end

  def declare_winner
    puts DIVIDER

    if @winner
      puts "#{@winner} wins!"
    else
      puts "It's a tie!"
    end
  end

  def play_again?
    answer = nil

    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if ['y', 'n'].include?(answer)
      puts "Sorry, please select either y or n."
    end

    answer == 'y'
  end

  def reset
    clear
    @deck = Deck.new
    player.hand = []
    dealer.hand = []
  end
end

Game.new.start
