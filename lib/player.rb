require_relative "deck"

class Player

  attr_accessor :bankroll
  attr_accessor :hand

  def initialize(bankroll)
    @bankroll = bankroll
  end

  def get_hand(deck)
    @hand = deck.deal(5)
  end

  def exchange_cards(discards, deck)

    discards.each do |dc|
      #deck.return(@hand[dc])
      @hand[dc] = deck.deal(1).first
    end

  end


end
