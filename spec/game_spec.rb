require "rspec"
require "game"

describe Game do
  let(:game) {Game.new(2)}
  it "intializes with new players" do
    expect(game.players).not_to eq(nil)
  end

  it "creates a deck" do
    expect(game.deck).not_to eq(nil)
  end

  describe "#setup_hand" do


    it "deals five card hands to each player" do
      expect(game.players[0].hand).to be(nil)
      game.setup_hand
      expect(game.players[0].hand).not_to be(nil)
    end


    it "collects an ante from each player" do
      expect(game.players[0].bankroll).to eq(500)
      game.setup_hand
      expect(game.players[0].bankroll).not_to eq(500)
    end

  end

  describe "#play" do





  end
end
