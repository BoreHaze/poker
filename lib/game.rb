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

    next_player = rotate(@button_player)
    (@players.count - 1).times do
      @active_players[next_player] = true
      next_player = rotate(next_player)
    end

    nil
  end

  def setup_hand
    @deck.shuffle
    rotate_button #unless @hand_count == 0

    @players_in_hand = []
    @active_players.each do |player, status|
      if status
        @players_in_hand << player
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
    setup_betting_round
    loop
      if @current_bet == 0
        action = @current_player.check_or_bet
        report_action(action)
        process_cb(action)
      else
        action = @current_player.call_raise_or_fold(@current_bet, @round_accounts[@current_player])
        report_action(action)
        process_crf(action)
      end

      break if betting_over?
      @current_player = next_to_act
    end

    report_betting_round

    nil
  end

  def setup_betting_round
    @current_bet = 0
    @last_betraiser = nil
    @current_player = rotate(@button_player)
    @first_to_act = @current_player

    @round_accounts = {}
    @players_in_hand.each do |player|
      @round_accounts[player] = 0
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
      @round_accounts[@current_player] += action
    end

    nil
  end

  def process_crf(action)
    if action.nil?
      @players_in_hand.delete(@current_player)
      return
    elsif action > [@current_bet - @round_accounts[@current_player]]
      @current_bet = action
      @pot += action
      @last_betraiser = @current_player
    else
      @pot += action
    end

    nil
  end

  def report_action(action)
    
  end

  def report_betting_round
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
