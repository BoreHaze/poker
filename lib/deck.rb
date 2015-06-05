require_relative "card"

class Deck

  attr_reader :cards

  def initialize
    @cards = []
    Card::CARD_SUITS.each_key do |suit|
      Card::CARD_RANKS.each_key do |rank|
        @cards << Card.new(rank, suit)
      end
    end
  end

  def count
    @cards.count
  end


  def shuffle
    @cards.shuffle!
    self
  end

  def deal(num)
    dealt = []
    num.times {dealt << @cards.shift}
    dealt
  end

  def return_cards(cards)
    @cards += cards
  end

end
