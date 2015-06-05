require_relative "card"
require_relative "deck"

class BadDealError < StandardError
end

class Hand

  HAND_RANKS = {
    :straight_flush => "Straight Flush",
    :quads          => "Four of a Kind",
    :full_house     => "Full House",
    :flush          => "Flush",
    :straight       => "Straight",
    :trips          => "Three of a Kind",
    :two_pair       => "Two Pair",
    :pair           => "Pair",
    :high_card      => "High Card"
  }

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


  def pair?(rank)
    @cards.map{|c| c.rank}.count(rank) == 2
  end

  def trips?(rank)
    @cards.map{|c| c.rank}.count(rank) == 3
  end

  def quads?(rank)
    cards.map{|c| c.rank}.count(rank) == 4
  end

  def rank_paired_hands
    num_pairs = 0
    num_trips = 0
    Card::CARD_RANKS.each_key do |rank|
      return :quads if quads?(rank)
      num_trips += 1 if trips?(rank)
      num_pairs += 1 if pair?(rank)
    end

    if num_trips > 0 && num_pairs > 0
      return :full_house
    elsif num_trips > 0
      return :trips
    elsif num_pairs == 2
      return :two_pair
    elsif num_pairs == 1
      return :pair
    else
      return :high_card
    end
  end

  def rank_connected_hands
    return :straight_flush if straight_flush?
    return :flush if flush?
    return :straight if straight?
    nil
  end

  def rank_hands
    hand_rank = rank_connected_hands
    hand_rank = rank_paired_hands if hand_rank.nil?

    hand_rank
  end

  def beats?(other_hand)
    hand_order(rank_hands) < hand_order(other_hand.rank_hands)
  end

  def hand_order(rank)
    HAND_RANKS.keys.index(rank)
  end

end
