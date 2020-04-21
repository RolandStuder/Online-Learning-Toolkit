class PeerReviewsController < ApplicationController
  # GET /peer_reviews
  # GET /peer_reviews.xml

  before_filter :authorize, :only => :index
  # before_filter :is_owner?, :only => [:show, :edit]

  def index
    @peer_reviews = PeerReview.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @peer_reviews }
    end
  end

  # GET /peer_reviews/1
  # GET /peer_reviews/1.xml
  def show
    @peer_review = PeerReview.find(params[:id])
    @assignments = @peer_review.peer_review_assignments.includes(:user).where(participant: true).order(:created_at)
    @errors = []

    @feedback_count = 0
    @assignments.each do |a|
      if a.status == 'feedback_given' || a.status == 'feedback_received'
        @feedback_count += 1
      end
    end


    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @peer_review }
    end
  end

  # GET /peer_reviews/new
  # GET /peer_reviews/new.xml
  def new
    @peer_review = PeerReview.new
    @peer_review.solution_due = Time.now + 7.days
    @peer_review.feedback_due = Time.now + 14.days

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @peer_review }
    end
  end

  # GET /peer_reviews/1/edit
  def edit
    @peer_review = PeerReview.find(params[:id])

  end

  # POST /peer_reviews
  # POST /peer_reviews.xml
  def create
    @peer_review = PeerReview.new(peer_review_params)
    if @peer_review.save
      if User.find_by_email(@peer_review.email)
        @admin = User.find_by_email(@peer_review.email)
      else
        @admin = User.create(:email => @peer_review.email)
      end
      session[:user_id] = @admin.id
      PeerReviewAssignment.create(:peer_review => @peer_review, :user => @admin, :admin => true )
      redirect_to assign_peer_review_path(@peer_review), :notice => "Successfully created"
    else
      render :action => "new"
    end
  end

  # PUT /peer_reviews/1
  # PUT /peer_reviews/1.xml
  def update
    @peer_review = PeerReview.find(params[:id])

    respond_to do |format|
      if @peer_review.update_attributes(peer_review_params)
        format.html { redirect_to(@peer_review, :success => 'Peer review was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @peer_review.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /peer_reviews/1
  # DELETE /peer_reviews/1.xml
  def destroy
    @peer_review = PeerReview.find(params[:id])
    @peer_review.destroy

    respond_to do |format|
      format.html { redirect_to(peer_reviews_url) }
      format.xml  { head :ok }
    end
  end

  def assign
    @peer_review = PeerReview.find(params[:id])
    @peer_review.participants
    @users = @peer_review.users.all

  end

  def assign_participants
    @peer_review = PeerReview.find(params[:id])
    @assignments = @peer_review.peer_review_assignments.where(:participant => true)
    @participants = params[:participants]

    @emails = @participants.scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i)

    new_counter = 0
    # @emails = @participants.split(/,|;|\n/)
    @emails.each do |email|
      # email = email.strip
      @user = User.find_or_create_by(email: email)
      unless @peer_review.peer_review_assignments.find_by_user_id(@user.id)
          new_counter += 1
          @peer_review.peer_review_assignments.create([:user_id => @user.id, :peer_review_id => @peer_review.id, :participant => true])
      else
        @assignment = @peer_review.peer_review_assignments.find_by_user_id(@user.id)
        new_counter += 1 unless @assignment.participant == true
        @assignment.participant = true
        @assignment.save
      end
    end

    if new_counter > 0
      flash[:success] = "#{new_counter} participants added"
    else
      flash[:error] = "No participants added. Check the list below to see, whether they were already assigned."
    end
    redirect_to :action => "show"
  end

  def start
    @peer_review = PeerReview.find(params[:id])
    @assignments = @peer_review.peer_review_assignments.where(:participant => true)
    @errors = []

    if @assignments.count < @peer_review.number_of_feedbacks+1
      flash.now[:error] = "You need to assign more people, you cannot have less people then the number of feedbacks that have to be given."
      render :action => 'show'
    else
      unless @peer_review.started?
        @assignments.each do |a|
          unless PeerReviewMailer.participant_task(@peer_review, a, a.user).deliver
               @errors << @user.email
          end
        end


        unless PeerReviewMailer.setup(@peer_review).deliver
          @errors << "You"
        end


        @peer_review.started = true
        @peer_review.save
        flash.now[:success] = "Peer Review successfully started, all participants have received an email with their task."

        render :action => "show"
      else
        flash.now[:error] = "The peer review was already started."
        render :action => "show"
      end
    end


  end

  def start_feedbacks_manually
    @peer_review = PeerReview.find(params[:id])
    @peer_review.start_feedbacks
    redirect_to :action => "show", :notice => "Peer Review Feedbacks started, all participants have received an email with their assignment."
  end


  protected

  def is_owner?
    @peer_review = PeerReview.find(params[:id])
    @assignment = @peer_review.peer_review_assignments.find_by_admin(true)
    @admin = @assignment.user
    unless session[:user_id]== @admin.id || session[:super_user] == true
      redirect_to "/", :notice => "No Acesss, this is not your exercise"
    end
  end

  private

  def peer_review_params
    params.require(:peer_review).permit(:title, :task, :solution_due, :feedback_instructions, :feedback_due, :email, :number_of_feedbacks)
  end


end
