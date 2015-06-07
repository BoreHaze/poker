class FakeCardError < StandardError
end

class Card

  CARD_SUITS = {
    :hearts   => "Hearts",
    :spades   => "Spades",
    :diamonds => "Diamonds",
    :clubs    => "Clubs"
  }

  CARD_RANKS = {
    :two   => "2",
    :three => "3",
    :four  => "4",
    :five  => "5",
    :six   => "6",
    :seven => "7",
    :eight => "8",
    :nine  => "9",
    :ten   => "10",
    :jack  => "J",
    :queen => "Q",
    :king  => "K",
    :ace   => "A"

  }

  attr_reader :rank, :suit

  def initialize(rank, suit)
    raise FakeCardError unless (CARD_RANKS.keys.include?(rank) && CARD_SUITS.keys.include?(suit))
    @rank = rank
    @suit = suit
  end

  def get_order
    CARD_RANKS.keys.index(rank)
  end

  def display
    "#{CARD_RANKS[rank]} of #{CARD_SUITS[suit]}"
  end

end
