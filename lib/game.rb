require_relative 'human_player'
require_relative 'computer_player'
require_relative 'deck'

require 'byebug'

class Game

  attr_reader :players, :active_players, :button_player, :deck, :ante, :pot

  def initialize(num_players, bankroll = 500)
    @players = []

    the_crew = ["Charlie", "Dennis", "Mac", "Dee", "Frank"]

    num_players.times { |i| @players << ComputerPlayer.new(the_crew[i], bankroll) }

    @players << HumanPlayer.new("The hero", bankroll)

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
    @players_in_hand = []
    @active_players.each do |player, status|
      if status
        @players_in_hand << player
        player.get_hand(deck)
        player.pay(@ante)
        @pot += @ante
      end
    end
    rotate_button unless @hand_count == 0
    nil
  end

  def play_hand
    betting_round
    if hand_over?
      puts "The hand is over"
      puts "#{@players_in_hand[0].name} wins #{@pot} chips"
      return
    end
    make_exchanges
    betting_round
    if hand_over?
      puts "The hand is over"
      puts "#{@players_in_hand[0].name} wins #{@pot} chips"
      return
    end
    showdown
  end

  def hand_over?
    @players_in_hand.count == 1
  end

  def betting_round
    setup_betting_round
    over = false
    until over
      if @current_bet == 0
        action = @current_player.check_or_bet
        process_cb(action)
      else
        action = @current_player.call_raise_or_fold(@current_bet, @round_accounts[@current_player])
        process_crf(action)
      end

      report_action(action)
      over = betting_over?
      @current_player = next_to_act
    end

    report_betting_round unless hand_over?

    nil
  end

  def make_exchanges
    @players_in_hand.each do |player|
      discards = player.choose_discards
      player.exchange_cards(discards, @deck)
    end
  end

  def showdown

    winners = []
    @players_in_hand.each do |player|
      wins = true
      puts "#{player.name} reveals a #{Hand::HAND_RANKS[player.hand.rank_hands]}"
      @players_in_hand.each do |other_player|
        next if player == other_player
        if other_player.hand.beats?(player.hand)
          wins = false
        end
      end
      winners << player if wins
    end

    @players_in_hand = winners

    if winners.count == 1
      puts "#{winners[0].name} wins the hand with a #{Hand::HAND_RANKS[winners[0].hand.rank_hands]} "
    else
      winner_str = ""
      winners.each_with_index do |winner, idx|
        winner_str += winner.name
        winner_str += ", " unless idx == winners.count - 1
      end
      puts "#{winner_str} tie for the hand with a #{Hand::HAND_RANKS[winners[0].hand.rank_hands]}"
    end
  end

  def cleanup_hand
    num_winners = @players_in_hand.count
    @players_in_hand.each do |player|
      player.pay(@pot/num_winners)
    end

    @active_players.each do |player, status|
      if status
        @deck.return_cards(player.hand.cards)
        player.hand = nil
      end

      if status && player.bankroll == 0
        @active_players[player] = false
      end
    end

    @pot = 0

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
      @current_player.pay(action)
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
    elsif action > @current_bet - @round_accounts[@current_player]
      @current_bet += action + @round_accounts[@current_player]
      @current_player.pay(action)
      @pot += action
      @last_betraiser = @current_player
      @round_accounts[@current_player] += action
    else
      @current_player.pay(action)
      @pot += action
      @round_accounts[@current_player] += action
    end

    nil
  end

  def report_action(action)
    if action.nil? && @current_bet == 0
      puts "#{@current_player.name} checks"
    elsif action.nil?
      puts "#{@current_player.name} folds"
    elsif @current_player != @last_betraiser
      puts "#{@current_player.name} calls #{@current_bet}"
    else
      puts "#{@current_player.name} raises to #{@current_bet}"
    end
  end

  def report_betting_round
    puts "The current round of betting is over, there are #{@pot} chips in the pot"
  end

  def betting_over?
    next_player = next_to_act
    ((@current_bet == 0) && (next_player == @first_to_act)) || (next_player == @last_betraiser)
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
    while @active_players[@players[next_idx]] == false && @players_in_hand.include(@players[next_idx])
      next_idx = (current_idx + 1) % @players.count
    end

    @players[next_idx]
  end

  def game_over?
    @active_players.each_value.map{|v| v }.count == 1
  end
end
