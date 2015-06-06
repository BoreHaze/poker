require_relative "player"
require_relative "deck"

class Game

  attr_reader :players, :activate_players, :deck, :ante
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

    activate_players

    until game_over? do
      setup_hand
      play_hand
      cleanup_hand
    end
  end

  def activate_players
    @active_players = {@current_player => true}
    current_idx = @players.index(@current_player)
    @players.count.times - 1 do
      current_idx += 1
      current_idx %= @players.count
      @active_players[@players[current_idx]] = true
    end

    nil
  end

  def setup_hand

    rotate_button

    @players.each do |player|
      player.get_hand(deck)
      player.bankroll -= ante
      @pot += ante
    end
  end

  def rotate_button

  end

  def over?

  end
end
