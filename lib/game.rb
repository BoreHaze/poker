require_relative "player"
require_relative "deck"

class Game

  attr_reader :players, :deck, :ante
  attr_accessor :pot

  def initialize(num_players, bankroll = 500)
    @players = []
    num_players.times { @players << Player.new(bankroll) }

    @players << Player.new(bankroll) #human player

    @button_player = @players.sample
    @deck = Deck.new.shuffle
    @ante = 2
  end

  def play

    setup_hand


  end

  def setup_hand
    @pot = 0
    @players.each do |player|
      player.get_hand(deck)
      player.bankroll -= ante
      @pot += ante
    end

  end



end
