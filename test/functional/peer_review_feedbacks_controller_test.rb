require 'test_helper'

class PeerReviewFeedbacksControllerTest < ActionController::TestCase
  setup do
    @peer_review_feedback = peer_review_feedbacks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:peer_review_feedbacks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create peer_review_feedback" do
    assert_difference('PeerReviewFeedback.count') do
      post :create, :peer_review_feedback => @peer_review_feedback.attributes
    end

    assert_redirected_to peer_review_feedback_path(assigns(:peer_review_feedback))
  end

  test "should show peer_review_feedback" do
    get :show, :id => @peer_review_feedback.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @peer_review_feedback.to_param
    assert_response :success
  end

  test "should update peer_review_feedback" do
    put :update, :id => @peer_review_feedback.to_param, :peer_review_feedback => @peer_review_feedback.attributes
    assert_redirected_to peer_review_feedback_path(assigns(:peer_review_feedback))
  end

  test "should destroy peer_review_feedback" do
    assert_difference('PeerReviewFeedback.count', -1) do
      delete :destroy, :id => @peer_review_feedback.to_param
    end

    assert_redirected_to peer_review_feedbacks_path
  end
end
