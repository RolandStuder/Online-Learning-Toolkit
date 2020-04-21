class PeerReviewFeedbacksController < ApplicationController
  # GET /peer_review_feedbacks
  # GET /peer_review_feedbacks.xml
  def index
    @feedbacks = PeerReviewFeedback.all
    # @assignment = PeerReviewAssignment.find(params[:id])
    # @peer_review = @assignment.peer_review
    # @peer_review_feedbacks = @assignment.peer_review_feedbacks.all
    # @feedbacks = @peer_review_feedbacks
    #
    # respond_to do |format|
    #   format.html # index.html.erb
    #   format.xml  { render :xml => @peer_review_feedbacks }
    # end
  end

  # GET /peer_review_feedbacks/1
  # GET /peer_review_feedbacks/1.xml
  def show
    @peer_review_feedback = PeerReviewFeedback.find(params[:id])
    @solution = @peer_review_feedback.peer_review_solution
    @assignment = @peer_review_feedback.peer_review_assignment

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @peer_review_feedback }
    end
  end

  # GET /peer_review_feedbacks/new
  # GET /peer_review_feedbacks/new.xml
  def new
    @assignment = PeerReviewAssignment.find(params[:id])
    @peer_review = @assignment.peer_review

    unless @assignment.peer_review_feedbacks.all.count >= @peer_review.number_of_feedbacks
      @solutions = @peer_review.peer_review_solutions.find( :all,
                                # :conditions => [ 'peer_review_assignment_id NOT ?', '1'],
                                :select=> 'peer_review_solutions.*, count(peer_review_feedbacks.id) as feedback_count',
                                :joins => 'left outer join peer_review_feedbacks on peer_review_feedbacks.peer_review_solution_id = peer_review_solutions.id',
                                :group => 'peer_review_solutions.id',
                                :order => 'feedback_count asc')

      @exclude = PeerReviewSolution.find_all_by_peer_review_assignment_id(@assignment.id)

      unless @solutions.first.peer_review_assignment_id == @assignment.id
        @solution = @solutions.first
        @feedback = @solution.peer_review_feedbacks.new
        @feedback.peer_review_assignment = @assignment
        @feedback.save
        render 'new'
      else
        redirect_to :controller => 'peer_review_assignments', :action => 'show', :id => @assignment.id , :notice => 'No solution available for feedback.'
      end


    else
      redirect_to :controller => 'peer_review_assignments', :action => 'show', :id => @assignment.id , :notice => 'You already have provided enough feedbacks.'
    end
  end

  # GET /peer_review_feedbacks/1/edit
  def edit
    @feedback = PeerReviewFeedback.find(params[:id])
    @assignment = @feedback.peer_review_assignment
    @solution = @feedback.peer_review_solution
    @peer_review = @feedback.peer_review_assignment.peer_review
  end

  # POST /peer_review_feedbacks
  # POST /peer_review_feedbacks.xml
  def create
    @feedback = PeerReviewFeedback.new(feedback_params)

    if @feedback.save
      redirect_to :controller => 'peer_review_assignments', :action => 'index', :id => @feedback.peer_review_assgignment_id , :notice => 'Peer review feedback was successfully created.'
    else
      render :action => "new"
    end
  end

  # PUT /peer_review_feedbacks/1
  # PUT /peer_review_feedbacks/1.xml
  def update
    @feedback = PeerReviewFeedback.find(params[:id])


    respond_to do |format|
      if @feedback.update_attributes(feedback_params)
        @peer_review = @feedback.peer_review_assignment.peer_review
        @peer_review.check_if_feedback_is_complete
        @feedback.peer_review_solution.check_if_feedback_is_complete

        format.html { redirect_to(@feedback.peer_review_assignment, :notice => 'Peer review feedback was successfully saved.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @feedback.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /peer_review_feedbacks/1
  # DELETE /peer_review_feedbacks/1.xml
  def destroy
    @peer_review_feedback = PeerReviewFeedback.find(params[:id])
    @peer_review_feedback.destroy

    respond_to do |format|
      format.html { redirect_to(peer_review_feedbacks_url) }
      format.xml  { head :ok }
    end
  end

  private

  def feedback_params
    params.require(:peer_review_feedback).permit(:text)
  end
end
