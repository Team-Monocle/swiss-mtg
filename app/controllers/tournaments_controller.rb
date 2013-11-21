class TournamentsController < ApplicationController
  before_action :set_tournament, only: [:show, :edit, :update, :destroy, :generate_round, :add_players, :update_results, :end_prelims]

  skip_before_filter :authenticate_user!, only: [:index, :show]

  # GET /tournaments
  # GET /tournaments.json
  def index
    @tournaments = Tournament.all
  end

  # GET /tournaments/1
  # GET /tournaments/1.json
  def show
    @players = Player.all
  end

  # GET /tournaments/new
  def new
    @tournament = Tournament.new
  end

  # GET /tournaments/1/edit
  def edit
    if current_user && current_user.id == @tournament.user.id
      render :edit
    else
      redirect_to @tournament
    end
  end

  def add_players
   @tournament.find_or_create_player(tournament_params["name"])
   redirect_to @tournament, notice: 'You do not have the proper permissions, you terrorist.'
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

   def end_prelims
    @tournament.finished = true
    @tournament.save
    redirect_to @tournament
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tournament
      @tournament = Tournament.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tournament_params
      params.require(:tournament).permit(:name, :matches_id, :format, :location, :date, :details)
    end

    def match_params
      params.require(:match).permit(:match_id, :game_1, :game_2, :game_3)
    end
end
