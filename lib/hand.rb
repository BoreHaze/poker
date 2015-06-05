require_relative "card"
require_relative "deck"

class BadDealError < StandardError
end

class Hand

  HAND_SIZE = 5

  attr_reader :cards

  def initialize(cards)
    raise BadDealError if cards.count != HAND_SIZE
    @cards = cards
  end

  def sort
    @cards.sort! {|a, b| a.get_order <=> b.get_order}
  end

  def flush?
    suit = @cards[0].suit
    @cards.all? {|c| c.suit == suit}
  end

  def straight?
    self.sort
    idx = 0
    current_rank = cards[idx].get_order
    (HAND_SIZE - 1).times do
      idx  += 1
      return false if current_rank + 1 != cards[idx].get_order
      current_rank = cards[idx].get_order
    end

    true
  end

  def straight_flush?
    straight? && flush?
  end



end
