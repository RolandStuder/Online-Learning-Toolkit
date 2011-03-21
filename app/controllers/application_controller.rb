class ApplicationController < ActionController::Base
  protect_from_forgery
  filter_parameter_logging :password

  
  helper_method :admin?
  helper_method :current_user_session, :current_user
  
  before_filter :get_session
  before_filter :authorize, :only => :destroy
  
  
  
  def get_session
      unless params[:token].nil?
        session.destroy
        UserSession.new 
        session[:user_id] = User.find_by_persistence_token(params[:token]).id
      end
  end
  
  private
  
  def current_user_session
    logger.debug "ApplicationController::current_user_session"
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    logger.debug "ApplicationController::current_user"
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def require_user
    logger.debug "ApplicationController::require_user"
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end

  def require_no_user
    logger.debug "ApplicationController::require_no_user"
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to account_url
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
  
  protected
    
  def authorize
    authenticate_or_request_with_http_basic do |username, password|
      username == "admin" && password == "82-http-basic"
      session[:super_user] = true
    end
  end
  
  
end
