require_relative "deck"

class Player

  attr_accessor :bankroll, :hand

  def initialize(bankroll)
    @bankroll = bankroll
  end

  def get_hand(deck)
    @hand = deck.deal(5)
  end

  def exchange_cards(discards, deck)

    discards.each do |dc|
      deck.return(@hand[dc])
      @hand[dc] = deck.deal(1).first
    end

  end

  def check_or_bet
    raise NotImplementedError
  end

  def call_raise_or_fold
    raise NotImplementedError
  end


end
