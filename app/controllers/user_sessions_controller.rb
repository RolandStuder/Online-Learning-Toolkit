class UserSessionsController < ApplicationController
  # before_action :require_no_user, <img src="http://www.dixis.com/wp-includes/images/smilies/icon_surprised.gif" alt=":o" class="wp-smiley"> nly => [:new, :create]
  # before_action :require_user, <img src="http://www.dixis.com/wp-includes/images/smilies/icon_surprised.gif" alt=":o" class="wp-smiley"> nly => :destroy

  def new
    @user_session = UserSession.new
    session[:user_id] = User.first.id
    @current_user = User.find(session[:user_id])
    @assignments = @current_user.peer_review_assignments.all
  end

  def create
    # @user_session = UserSession.new(params[:user_session])
    # if @user_session.save
    #   flash[:notice] = "Login successful!"
    #   redirect_back_or_default users_url
    # else
    #   render :action => :new
    # end
  end

  def destroy
    # current_user_session.destroy
    # flash[:notice] = "Logout successful!"
    # redirect_back_or_default new_user_session_url
  end

  def test
    @token = params[:token]
    session.destroy
    UserSession.new
    session[:user_id] = User.find_by_persistence_token(@token).id
  end

end
