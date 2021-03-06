class TournamentsController < ApplicationController
  before_action :set_tournament, only: [:show, :edit, :update, :destroy, :generate_round, :re_generate_round, :add_players, :remove_player, :update_results, :end_prelims, :add_player_list]

  skip_before_filter :authenticate_user!, only: [:index, :show]

  # GET /tournaments
  # GET /tournaments.json
  def index
    @tournaments = Tournament.all
  end

  # GET /tournaments/1
  # GET /tournaments/1.json
  def show
  end

  # GET /tournaments/new
  def new
    @tournament = Tournament.new
  end

  # GET /tournaments/1/edit
  def edit
    if current_user && current_user.id == @tournament.users[0].id
      render :edit
    else
      redirect_to @tournament, notice: 'You do not have the proper permissions, you terrorist.'
    end
  end

  def add_player_list
    if current_user && current_user.id == @tournament.users[0].id
      names = tournament_params["name"].split(',').map(&:strip)
      names.each do |name|
        @tournament.find_or_create_player(name)
      end
      redirect_to @tournament
    else
      redirect_to @tournament, notice: 'You do not have the proper permissions, you terrorist.'
    end
  end

  def remove_player
    if current_user && current_user.id == @tournament.users[0].id
      pt = @tournament.player_tournaments.find(params[:p_id])
      pt.player.destroy if pt.player.player_tournaments.size == 1
      pt.destroy
      redirect_to @tournament, notice: 'Player removed'
    else
      redirect_to @tournament, notice: 'You do not have the proper permissions, you terrorist.'
    end
  end


  # POST /tournaments
  # POST /tournaments.json
  def create
    @tournament = Tournament.new(tournament_params)
    
    respond_to do |format|
      if @tournament.save
        UserTournament.create(tournament_id: @tournament.id, user_id: current_user.id)
        format.html { redirect_to @tournament, notice: 'Tournament was successfully created.' }
        format.json { render action: 'show', status: :created, location: @tournament }
      else
        format.html { render action: 'new' }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_results
    match = Match.find(match_params[:match_id])
    match.update(game_1: match_params[:game_1], game_2: match_params[:game_2], game_3: match_params[:game_3])
    redirect_to @tournament
  end

  # PATCH/PUT /tournaments/1
  # PATCH/PUT /tournaments/1.json
  def update
    respond_to do |format|
      if @tournament.update(tournament_params)
        format.html { redirect_to @tournament, notice: 'Tournament was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tournaments/1
  # DELETE /tournaments/1.json
  def destroy
    @tournament.destroy
    respond_to do |format|
      format.html { redirect_to tournaments_url }
      format.json { head :no_content }
    end
  end

  def generate_round
    if @tournament.round_complete
      redirect_to @tournament, notice: "Round #{@tournament.current_round} Matches Generated"
      @tournament.generate 
    else
      redirect_to @tournament, notice: "New round pairings cannot be generated until the current round has been completed"
    end
  end

  def re_generate_round
    redirect_to @tournament, notice: "Round #{@tournament.current_round} Matches Re-Generated"
    @tournament.re_generate
  end

  def end_prelims
    redirect_to @tournament
    @tournament.end_tournament
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tournament
      @tournament = Tournament.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tournament_params
      params.require(:tournament).permit(:name, :format, :location, :date, :details)
    end

    def match_params
      params.require(:match).permit(:match_id, :game_1, :game_2, :game_3)
    end
end
