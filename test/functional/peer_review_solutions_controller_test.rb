require 'test_helper'

class PeerReviewSolutionsControllerTest < ActionController::TestCase
  setup do
    @peer_review_solution = peer_review_solutions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:peer_review_solutions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create peer_review_solution" do
    assert_difference('PeerReviewSolution.count') do
      post :create, :peer_review_solution => @peer_review_solution.attributes
    end

    assert_redirected_to peer_review_solution_path(assigns(:peer_review_solution))
  end

  test "should show peer_review_solution" do
    get :show, :id => @peer_review_solution.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @peer_review_solution.to_param
    assert_response :success
  end

  test "should update peer_review_solution" do
    put :update, :id => @peer_review_solution.to_param, :peer_review_solution => @peer_review_solution.attributes
    assert_redirected_to peer_review_solution_path(assigns(:peer_review_solution))
  end

  test "should destroy peer_review_solution" do
    assert_difference('PeerReviewSolution.count', -1) do
      delete :destroy, :id => @peer_review_solution.to_param
    end

    assert_redirected_to peer_review_solutions_path
  end
end
