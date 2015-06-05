require 'hand'

describe Hand do
  let(:deck) { Deck.new }
  let(:hand) { Hand.new(deck.deal(5)) }

  let(:junk) {Hand.new([
    Card.new(:four, :hearts),
    Card.new(:five, :spades),
    Card.new(:jack, :clubs),
    Card.new(:six, :spades),
    Card.new(:seven, :diamonds)])}

  it "Initializes with cards" do
    expect(hand.cards).not_to be(nil)
  end

  it "Must start with 5 cards" do
    expect{ Hand.new(deck.deal(4)) }.to raise_error(BadDealError)
  end

  let(:straight) {Hand.new([
    Card.new(:four, :hearts),
    Card.new(:five, :spades),
    Card.new(:three, :clubs),
    Card.new(:six, :spades),
    Card.new(:seven, :diamonds)])}

  it "Sorts cards" do
    straight.sort
    expect(straight.cards[0].rank).to eq(:three)
  end

  it "Identifies a straight" do
    expect(straight.straight?).to be(true)
  end

  it "Doesn't mistake junk for a straight" do
    expect(junk.straight?).to be(false)
  end

  let(:flush) {Hand.new([
    Card.new(:four, :spades),
    Card.new(:five, :spades),
    Card.new(:jack, :spades),
    Card.new(:six, :spades),
    Card.new(:seven, :spades)])}

  it "Identifies a flush" do
    expect(flush.flush?).to be(true)
  end

  it "Doesn't mistake junk for a flush" do
    expect(junk.flush?).to be(false)
  end

  let(:straight_flush) {Hand.new([
    Card.new(:four, :spades),
    Card.new(:five, :spades),
    Card.new(:eight, :spades),
    Card.new(:six, :spades),
    Card.new(:seven, :spades)])}

  it "Identifies a straight flush" do
    expect(straight_flush.straight_flush?).to be(true)
  end

  it "Doesn't mistake junk for a straight flush" do
    expect(junk.straight_flush?).to be(false)
  end

end
