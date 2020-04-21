class PeerReviewSolutionsController < ApplicationController
  # GET /solutions
  # GET /solutions.xml


  def index
    @peer_review = PeerReview.find(params[:peer_review_id])
    @solutions = @peer_review.peer_review_solutions.find(:all)
    @anonymous = params[:anonymous]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @solutions }
    end
  end

  # GET /solutions/1
  # GET /solutions/1.xml
  def show
    @solution = PeerReviewSolution.find(params[:id])
    @assignment = @solution.peer_review_assignment
    @peer_review = @assignment.peer_review

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @solution }
    end
  end

  # GET /solutions/new
  # GET /solutions/new.xml
  def new
    @assignment = PeerReviewAssignment.find(params[:peer_review_assignment_id])
    @peer_review = @assignment.peer_review
    @solution = @assignment.peer_review_solutions.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @solution }
    end
  end

  # GET /solutions/1/edit
  def edit
    @solution = PeerReviewSolution.find(params[:id])
    @assignment = @solution.peer_review_assignment

  end

  # POST /solutions
  # POST /solutions.xml
  def create
    @assignment = PeerReviewAssignment.find(params[:peer_review_assignment_id])
    if @assignment.peer_review_solutions.count == 0
      @solution = @assignment.peer_review_solutions.create(peer_review_solution_params)
      @solution.save
      @peer_review = @assignment.peer_review

      @peer_review.start_feedbacks?

      redirect_to peer_review_assignment_path(@assignment), :notice => "You solution has been saved."
    else
      redirect_to peer_review_assignment_path(@assignment), :notice => "You can only submit one solution."
    end
  end

  # PUT /solutions/1
  # PUT /solutions/1.xml
  def update
    @solution = PeerReviewSolution.find(params[:id])
    params[:peer_review_solution][:text] = params[:peer_review_solution][:text].gsub(/<!--(.|\s)*?-->/,"")
    @assignment = @solution.peer_review_assignment
    @peer_review = @assignment.peer_review


    @peer_review.start_feedbacks?


    respond_to do |format|
      if @solution.update_attributes(peer_review_solution_params)
        format.html { redirect_to(@assignment, :notice => "Yay, sucessfully saved") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @solution.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /solutions/1
  # DELETE /solutions/1.xml
  def destroy
    @solution = PeerReviewSolution.find(params[:id])
    @solution.destroy

    respond_to do |format|
      format.html { redirect_to(solutions_url) }
      format.xml  { head :ok }
    end
  end

  private

  def peer_review_solution_params
    params.require(:peer_review_solution).permit(:text)
  end
end
