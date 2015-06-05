require "deck"

describe Deck do

  let(:deck) { Deck.new }

  it "contains 52 cards when initialized" do
  expect(deck.count).to eq(52)
  end

  it "can shuffle cards" do
    card = deck.cards[0]
    deck.shuffle

    expect(deck.cards[0]).not_to eq(card)
  end

  describe "#deal" do

    it "can deal a hand" do
      expect(deck.deal(5).count).to eq(5)
    end

    it "removes cards from deck when dealing" do
      deck.deal(5)
      expect(deck.count).to eq(47)
    end
  end

  describe "#return_cards" do

    it "can return cards from a hand to the deck" do
      cards = deck.deal(5)
      deck.return_cards(cards)
      expect(deck.count).to eq(52)
    end
  end

end
