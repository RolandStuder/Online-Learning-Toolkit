class PeerReviewSolutionsController < ApplicationController
  # GET /solutions
  # GET /solutions.xml
  def index
    @peer_review = PeerReview.find(params[:peer_review_id])
    @solutions = @peer_review.peer_review_solutions.all
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
  end

  # POST /solutions
  # POST /solutions.xml
  def create
    @assignment = PeerReviewAssignment.find(params[:peer_review_assignment_id])
    @solution = @assignment.peer_review_solutions.create(params[:peer_review_solution])
    @solution.save
    @peer_review = @assignment.peer_review
    
    # if @peer_review.peer_review_assignments.length == @peer_review.peer_review_solutions.length #start feedbacks when all solutions are in.
    #   @peer_review.start_feedbacks
    # end
    
    redirect_to peer_review_assignment_path(@assignment), :notice => "You solution has been saved."
  end

  # PUT /solutions/1
  # PUT /solutions/1.xml
  def update
    @solution = PeerReviewSolution.find(params[:id])
    @assignment = @solution.peer_review_assignment
    @peer_review = @solution.peer_review
    
    

    respond_to do |format|
      if @solution.update_attributes(params[:peer_review_solution])
        format.html { redirect_to(@assignment, :notice => 'Peer review solution was successfully updated.') }
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
end
