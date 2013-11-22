require 'spec_helper'

describe Tournament do
  before do
    @tournament = FactoryGirl.create(:tournament)
    8.times do |n|
      FactoryGirl.create(:player_tournament, :tournament => @tournament, :player => FactoryGirl.create(:player, name: "player #{n}"))
    end
  end

  context "when generating the first round" do
    before do
      @tournament.generate
    end

    it "should generate random pairings" do
      first_pairings = @tournament.matches
      @tournament.matches.destroy_all
      @tournament.current_round = 0
      @tournament.save
      @tournament.reload
      @tournament.generate
      first_pairings.should_not eq(@tournament.matches)
    end

    it "should determine the number of rounds" do
      @tournament.number_of_rounds.should eq(3)
    end

    it "should set the current round to 1" do
      @tournament.current_round.should eq(1)
    end
  end

  context "when there is an uneven number of players" do
    before do
      FactoryGirl.create(:player_tournament, :tournament => @tournament, :player => FactoryGirl.create(:player, name: "odd player"))
      @tournament.reload
      @tournament.generate
    end

    it "should give the last player a bye" do
      @tournament.matches.last.player_1.had_bye.should eq(true)
    end

  end

  context "when generating a new round" do

    it "should not give a player a bye twice" do
      tournament = FactoryGirl.create(:tournament)
      3.times do |n|
        FactoryGirl.create(:player_tournament, :tournament => tournament, :player => FactoryGirl.create(:player, name: "player #{n}"))
      end
      tournament.stub(:assess_rounds).and_return(3)
      tournament.generate

      bye_guy_1 = tournament.matches[1].player_1

      tournament.matches[0].game_1 = tournament.matches[0].player_1_id
      tournament.matches[0].game_2 = tournament.matches[0].player_1_id

      tournament.matches[1].game_1 = bye_guy_1.id
      tournament.matches[1].game_2 = bye_guy_1.id

      tournament.save
      tournament.reload
      tournament.generate

      bye_guy_2 = tournament.matches[3].player_1

      tournament.matches[2].game_1 = tournament.matches[2].player_1_id
      tournament.matches[2].game_2 = tournament.matches[2].player_1_id

      tournament.matches[3].game_1 = bye_guy_2.id
      tournament.matches[3].game_2 = bye_guy_2.id

      tournament.save
      tournament.reload
      tournament.generate

      bye_guy_3 = tournament.matches[5].player_1

      tournament.matches[4].game_1 = tournament.matches[4].player_1_id
      tournament.matches[4].game_2 = tournament.matches[4].player_1_id

      tournament.matches[5].game_1 = bye_guy_3.id
      tournament.matches[5].game_2 = bye_guy_3.id

      tournament.save
      tournament.reload

      expect(bye_guy_1 != bye_guy_2).to eq(true)
      expect(bye_guy_1 != bye_guy_3).to eq(true)
      expect(bye_guy_2 != bye_guy_3).to eq(true)
    end


    it "should increment the current round" do
      round_now = @tournament.current_round
      @tournament.generate
      expect(round_now).to_not eq(@tournament.current_round)
    end

    it "should not change the number of rounds"

    it "should match players according to standings"

  end
end
