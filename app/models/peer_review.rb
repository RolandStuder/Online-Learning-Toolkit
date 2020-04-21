class PeerReview < ActiveRecord::Base
  has_many :peer_review_assignments
  has_many :users, through: :peer_review_assignments
  has_many :peer_review_solutions, :through => :peer_review_assignments
  has_many :peer_review_feedbacks, :through => :peer_review_assignments

  validates_presence_of :title, :task, :number_of_feedbacks

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  validate :timeliness_given

  #MODEL Methods
  #################

  def status
    if finished
      "finished"
    elsif reviewing?
      "reviewing"
    elsif started?
      "started"
    else
      "not started"
    end
  end

  def start_feedbacks?
    if peer_review_assignments.length == peer_review_solutions.length #start feedbacks when all solutions are in.
      self.start_feedbacks unless self.started == false
    end
  end

  def start_feedbacks
    if self.started == true
      self.reviewing = true
      @solutions = self.peer_review_solutions.all


      @solutions.each_with_index do |solution, i|
        @assignment = @solutions[i].peer_review_assignment
        @user = @assignment.user
        PeerReviewMailer.feedback_assignment(@assignment, self, @user).deliver

        self.number_of_feedbacks.downto(1) do |n|
          n=(i+n) % @solutions.count
          @feedback = PeerReviewFeedback.create([:peer_review_assignment => @assignment, :peer_review_solution => @solutions[n]])
        end
      end
      PeerReviewMailer.status(self).deliver
      self.save
    end
  end

  def check_if_feedback_is_complete
    if self.reviewing == true
      @feedbacks = self.peer_review_feedbacks.where(:text => nil)
      unless self.finished == true
        if @feedbacks.count == 0 or feedback_due <= Time.now
          PeerReviewMailer.status(self).deliver
          self.finished = true
          self.save
          self.peer_review_solutions.where(:feedback_returned => false).each do |solution|
            solution.return_feedback
          end
        end
      end
    end
  end

  def participants
    @assignments = self.peer_review_assignments.where(:participant => true)
    # @assignments.each do |a|
    #   participants = a.user
    # end
    return @assignments
  end



  #CLASS Methods
  #################

  def self.finish
    self.where(:finished => false).each do |pr|
      pr.check_if_feedback_is_complete
    end
  end

  def self.start_feedbacks
    self.where(:reviewing => false).each do |pr|
      if pr.peer_review_solutions.count == pr.peer_review_assignments.count
        pr.start_feedbacks
      elsif pr.solution_due <= Time.now
        pr.start_feedbacks
      end
    end
  end

  protected


  def timeliness_given
    if created_at.nil?
      errors.add(:solution_due, 'should be in the future') if solution_due.nil? || solution_due < Time.now
    else
      errors.add(:solution_due, 'should be in the future') if solution_due.nil? || solution_due < created_at
    end
    errors.add(:feedback_due, 'should be after due date of solution') if feedback_due.nil? || feedback_due < solution_due
  end


end
