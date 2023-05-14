class RankChecksController < ApplicationController
  before_action :set_rank_check, only: %i[ show edit update destroy ]

  # GET /rank_checks or /rank_checks.json
  def index
    @rank_checks = RankCheck.all
  end

  # GET /rank_checks/1 or /rank_checks/1.json
  def show
  end

  # GET /rank_checks/new
  def new
    @rank_check = RankCheck.new
  end

  # GET /rank_checks/1/edit
  def edit
  end

  # POST /rank_checks or /rank_checks.json
  def create
    @rank_check = RankCheck.new(rank_check_params)

    respond_to do |format|
      if @rank_check.save
        format.html { redirect_to rank_check_url(@rank_check), notice: "Rank check was successfully created." }
        format.json { render :show, status: :created, location: @rank_check }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @rank_check.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rank_checks/1 or /rank_checks/1.json
  def update
    respond_to do |format|
      if @rank_check.update(rank_check_params)
        format.html { redirect_to rank_check_url(@rank_check), notice: "Rank check was successfully updated." }
        format.json { render :show, status: :ok, location: @rank_check }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @rank_check.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rank_checks/1 or /rank_checks/1.json
  def destroy
    @rank_check.destroy

    respond_to do |format|
      format.html { redirect_to rank_checks_url, notice: "Rank check was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rank_check
      @rank_check = RankCheck.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def rank_check_params
      params.require(:rank_check).permit(:url, :keyword, :gsp_rank, :get_date, :zone_type, :site_id_id)
    end
end
