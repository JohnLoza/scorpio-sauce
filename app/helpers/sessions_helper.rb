module SessionsHelper
  # Logs in the given user.
  def log_in(user, session_params = {})
    session[:user_id] = user.id
    unless session_params["remember_me"].to_i.zero?
      remember user
    end
  end # def log_in #

  # Remembers a user in a persistent session.
  def remember(user)
    token = JsonWebToken.encode(user_id: user.id)
    cookies.permanent[:auth_token] = token
  end # def remember #

  # Returns true if the given user is the current user.
  def current_user?(user)
    user.id == current_user.id
  end

  # Returns the user corresponding to the remember token cookie.
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find(user_id)
    elsif (auth_token = cookies[:auth_token])
      decoded_token = JsonWebToken.decode(auth_token)
      return nil unless decoded_token

      user = User.find(decoded_token[:user_id])
      log_in user
      @current_user = user
    end
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  # Forgets a persistent session.
  def forget_user
    cookies.delete(:auth_token)
  end

  # Logs out the current logged-in user
  def log_out
    return unless logged_in?
    forget_user
    session.delete(:user_id)
    @current_user = nil
  end # def log_out #

  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

end
