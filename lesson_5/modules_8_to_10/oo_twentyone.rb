=begin
Assignment: https://launchschool.com/lessons/97babc46/assignments/819bf113
=end

class Player
  def initialize
    # what states should a Player object have?
    # cards? a name?
  end

  def hit
  end

  def stay
  end

  def busted?
  end

  def total
    # definitely looks like we need to know about "cards" to produce some total
  end
end

class Dealer
  def initialize
    # seems like very similar to Player... do we need this?
  end

  def deal
    # does the dealer or the deck deal
  end

  def hit
  end

  def stay
  end

  def total
  end
end

class Participant
  # what goes here? is this a super class of Player and Dealer?
end

class Deck
  def initialize
    # what data structure should keep track of cards?
  end

  def deal
    # should the dealer or the deck deal?
  end
end

class Card
  def initialize
    # what are the "states" of a card?
  end
end

class Game
  def start
    deal_cards
    show_initial_cards
    player_turn
    dealer_turn
    show_result
  end
end

Game.new.start
