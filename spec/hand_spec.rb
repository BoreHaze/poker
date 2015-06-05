require 'hand'

describe Hand do

  let(:junk) {Hand.new([
    Card.new(:four, :hearts),
    Card.new(:five, :spades),
    Card.new(:jack, :clubs),
    Card.new(:six, :spades),
    Card.new(:seven, :diamonds)])}

  it "Initializes with cards" do
    expect(junk.cards).not_to be(nil)
  end

  it "Must start with 5 cards" do
    expect{ Hand.new([Card.new(:three, :hearts)]) }.to raise_error(BadDealError)
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
    expect(straight).to be_straight
  end

  it "Doesn't mistake junk for a straight" do
    expect(junk).not_to be_straight
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

  let(:pair) {Hand.new([
    Card.new(:five, :hearts),
    Card.new(:five, :spades),
    Card.new(:jack, :clubs),
    Card.new(:six, :spades),
    Card.new(:seven, :diamonds)])}


  it "ranks a pair" do
    expect(pair.rank_hands).to eq(:pair)
  end

  let(:trips) {Hand.new([
    Card.new(:five, :hearts),
    Card.new(:five, :spades),
    Card.new(:jack, :clubs),
    Card.new(:five, :clubs),
    Card.new(:seven, :diamonds)])}

  it "ranks three of a kind" do
    expect(trips.rank_hands).to eq(:trips)
  end

  let(:quads) {Hand.new([
    Card.new(:five, :hearts),
    Card.new(:five, :spades),
    Card.new(:five, :diamonds),
    Card.new(:five, :clubs),
    Card.new(:seven, :diamonds)])}

  it "ranks four of a kind" do
    expect(quads.rank_hands).to eq(:quads)
  end

  let(:boat) {Hand.new([
    Card.new(:five, :hearts),
    Card.new(:five, :spades),
    Card.new(:five, :diamonds),
    Card.new(:seven, :clubs),
    Card.new(:seven, :diamonds)])}

  it "ranks a full house" do
    expect(boat.rank_hands).to eq(:full_house)
  end

  let(:two_pair) {Hand.new([
    Card.new(:five, :hearts),
    Card.new(:five, :spades),
    Card.new(:six, :diamonds),
    Card.new(:seven, :clubs),
    Card.new(:seven, :diamonds)])}

  it "ranks two pair" do
    expect(two_pair.rank_hands).to eq(:two_pair)
  end

  it "ranks junk as high card" do
    expect(junk.rank_hands).to eq(:high_card)
  end

  it "Compares hands correctly" do
    expect(junk.beats?(pair)).to be(false)
    expect(trips.beats?(pair)).to be(true)
    expect(straight_flush.beats?(quads)).to be(true)
    expect(straight.beats?(flush)).to be(false)
  end


end
