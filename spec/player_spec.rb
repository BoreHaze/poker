require 'player'

describe Player do
  let (:player) { Player.new('dummy', 500) }
  let(:deck) { double(:deck) }

  let(:junk) {Hand.new([
    Card.new(:four, :hearts),
    Card.new(:five, :spades),
    Card.new(:jack, :clubs),
    Card.new(:six, :spades),
    Card.new(:seven, :diamonds)])}

  it "Initializes with a bankroll" do
    expect(player.bankroll).not_to be(nil)
  end

  it "Has correct amount in bankroll" do
    expect(player.bankroll).to eq(500)
  end

  describe "#get_hand" do

    it "Gets hand from dealer and sets to instance variable" do
      allow(deck).to receive(:deal).and_return(junk.cards)
      player.get_hand(deck)
      expect(player.hand).not_to be(nil)
    end

  end

  describe "#exchange_cards" do

    let(:discards) {[1]}
    let(:no_discards) {[]}
    let(:new_card) { Card.new(:ace, :spades) }

    before(:each) do
      allow(deck).to receive(:deal).and_return([new_card])
      allow(deck).to receive(:return_cards)
    end

    it "discards cards" do
      player.hand = junk
      old_card = player.hand.cards[1]
      player.exchange_cards(discards, deck)
      expect(player.hand.cards[1]).not_to eq(old_card)
    end

    it "replaces selected card with a new card" do
      player.hand = junk
      player.exchange_cards(discards, deck)
      expect(player.hand.cards[1]).to eq(new_card)
    end

    it "Does nothing when player doesn't want to exchange" do
      player.hand = junk
      player.exchange_cards(no_discards, deck)

      expect(player.hand).to eq(junk)
    end


  end


end
