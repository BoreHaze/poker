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

      before {game.activate_players}

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

      it "puts the ante into the pot" do
        expect(game.pot).to eq(0)
        game.setup_hand
        expect(game.pot).to eq(game.ante * game.players.count)
      end

      it "rotates the button" do
        prior_btn_index = game.players.index(game.button_player)
        game.setup_hand
        new_btn_index = game.players.index(game.button_player)
        expect(new_btn_index).to eq((prior_btn_index + 1) % game.players.count)
      end


    end

    context "#play_hand" do

      before do
        game.activate_players
        game.setup_hand
      end

      describe "#betting_round" do

        it "Keeps looping until #betting_over?"

        it "Asks players for correct action"



      end



    end


    context "#cleanup_hand" do

    end
  end
end
