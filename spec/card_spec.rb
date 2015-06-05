require 'card'

describe Card do

  let(:card) { Card.new(:ace, :spades) }

  it "Should have a rank" do
    expect(card.rank).not_to be(nil)
  end

  it "Should have a suit" do
    expect(card.suit).not_to be(nil)
  end

  it "Should not initialize with nonxistant ranks or suits" do
    expect {Card.new(:joker, :cups) }.to raise_error(FakeCardError)
  end


end
