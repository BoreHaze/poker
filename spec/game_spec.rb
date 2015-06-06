require "rspec"
require "game"

describe Game do
  let(:game) {Game.new(3)}
  it "intializes with new players" do
    expect(game.players).not_to eq(nil)
  end

  it "creates a deck" do
    expect(game.deck).not_to eq(nil)
  end

  context "#play" do

    context "#activate_players" do

      it "creates active player hash" do
        expect(game.active_players).to be(nil)
        game.activate_players
        expect(game.active_players).not_to be(nil)
      end

    end

    context "#setup_hand" do

      describe "#rotate_button" do

        it "sets button to next active player"
        it "skips players who are no longer in game"

      end

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

      it "puts the ante into the pot"

      it "rotates the button"


    end

    context "#play_hand" do



    end


    context "#cleanup_hand" do

    end
  end
end
