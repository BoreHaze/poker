require_relative "player"
require_relative "deck"

class Game

  attr_reader :players, :active_players, :button_player, :deck, :ante, :pot

  def initialize(num_players, bankroll = 500)
    @players = []

    num_players.times { @players << ComputerPlayer.new(bankroll) }

    @players << HumanPlayer.new(bankroll)

    @deck = Deck.new.shuffle
    @ante = 2
    @pot = 0
    @hand_count = 0
  end

  def play
    activate_players
    until game_over? do
      setup_hand
      play_hand
      cleanup_hand
      @hand_count += 1
    end
  end

  def activate_players
    @button_player = @players.sample


    @active_players = {@button_player => true}
    current_idx = @players.index(@button_player)
    (@players.count - 1).times do
      current_idx += 1
      current_idx %= @players.count
      @active_players[@players[current_idx]] = true
    end

    nil
  end

  def setup_hand
    @deck.shuffle
    rotate_button #unless @hand_count == 0
    @active_players.each do |player, status|
      if status
        player.get_hand(deck)
        player.bankroll -= @ante
        @pot += @ante
      end
    end

    nil
  end

  def play_hand
    betting_round
    make_exchanges
    betting_round
    showdown
  end

  def betting_round
    @current_bet = 0
    @last_betraiser = nil
    @current_player = rotate(@button_player)
    @first_to_act = @current_player

    loop
      if @current_bet == 0
        action = @current_player.check_or_bet
        process_cb(action)
      else
        action = @current_player.call_raise_or_fold
        process_crf(action)
      end

      break if betting_over?
      @current_player = next_to_act
    end

    nil
  end

  def process_cb(action)
    if action.nil?
      return
    else
      @current_bet = action
      @pot += action
      @last_betraiser = @current_player
    end

    nil
  end

  def process_crf(action)
    if action.nil?
      @active_players[@current_player] = false
      return
    elsif action > @current_bet
      @current_bet = action
      @pot += action
      @last_betraiser = @current_player
    else
      @pot += action
    end
    
    nil
  end

  def betting_over?
    next_player = next_to_act

    ((@current_bet == 0) && (next_player == @first_to_act)) ||
    (@last_betraiser == next_player)
  end

  def next_to_act
    rotate(@current_player)
  end

  def rotate_button
    @button_player = rotate(@button_player)
    nil
  end

  def rotate(player)
    current_idx = @players.index(player)
    next_idx = (current_idx + 1) % @players.count
    while @active_players[@players[next_idx]] == false
      next_idx = (current_idx + 1) % @players.count
    end

    @players[next_idx]
  end

  def game_over?

  end
end
