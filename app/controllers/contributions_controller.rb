class ContributionsController < ApplicationController
  before_action :set_contribution, only: [:show, :edit, :update, :destroy]

  def upvote
    if(current_user)
      @contributions = Contribution.find(params[:id])
      @contributions.liked_by current_user
      @contributions.update(puntos: @contributions.votes_for.size)
    end
    redirect_to root_path
  end
  
  #def upvote 
  #  @contributions = Contribution.find(params[:id])
  #  @contributions.upvote_by current_user
  #  redirect_to :back
  #end
  
  def downvote
    @contributions = Contribution.find(params[:id])
    @contributions.downvote_by current_user
    redirect_to :back
  end

  # GET /contributions
  # GET /contributions.json
  def index
    @contributions =  Contribution.order("created_at desc").where("url<>'' AND url<>' '  OR url is not null") 
    Contribution.all.order("created_at desc")
  end

  # GET /contributions/1
  # GET /contributions/1.json
  def show
    @comment = Comment.new
  end

  # GET /contributions/new
  def new
    @contribution = Contribution.new

  end

  # GET /contributions/1/edit
  def edit
  end

  # POST /contributions
  # POST /contributions.json
  def create
    @contribution = Contribution.new(contribution_params)
    respond_to do |format|
      if @contribution.save
        format.html { redirect_to "" }
        format.json { render :index, status: :created, location: @contribution }
      else
        format.html { render :new }
        format.json { render json: @contribution.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contributions/1
  # PATCH/PUT /contributions/1.json
  def update
    respond_to do |format|
      if @contribution.update(contribution_params)
        format.html { redirect_to @contribution, notice: 'Contribution was successfully updated.' }
        format.json { render :show, status: :ok, location: @contribution }
      else
        format.html { render :edit }
        format.json { render json: @contribution.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contributions/1
  # DELETE /contributions/1.json
  def destroy
    @contribution.destroy
    respond_to do |format|
      format.html { redirect_to contributions_url, notice: 'Contribution was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contribution
      @contribution = Contribution.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contribution_params
      params.require(:contribution).permit(:titulo, :user_id, :url, :puntos, :comentarios, :tipo, :text)
    end
end
