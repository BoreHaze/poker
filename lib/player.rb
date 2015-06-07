require_relative 'deck'
require_relative 'hand'
class Player

  attr_accessor :name, :bankroll, :hand

  def initialize(name, bankroll)
    @name = name
    @bankroll = bankroll
  end

  def get_hand(deck)
    @hand = Hand.new(deck.deal(5))
  end

  def exchange_cards(discards, deck)

    discards.each do |dc|
      deck.return_cards([@hand.cards[dc]])
      @hand.cards[dc] = deck.deal(1).first
    end

  end

  def pay(amnt)
    @bankroll -= amnt
  end

  def get(amnt)
    @bankroll += amnt
  end

  def check_or_bet
    raise NotImplementedError
  end

  def call_raise_or_fold
    raise NotImplementedError
  end

  def inspect
    "#{@name}"
  end

end
