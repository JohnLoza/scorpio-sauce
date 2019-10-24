module SessionsHelper
  def log_in(user, remember_me = "0")
    session[:user_id] = user.id
    unless remember_me.to_i.zero?
      remember(user)
    end
  end

  def remember(user)
    token = JsonWebToken.encode(user_id: user.id)
    cookies.permanent[:auth_token] = token
  end

  def current_user?(user)
    user.id == current_user.id
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find(user_id)
    elsif (auth_token = cookies[:auth_token])
      user = authenticate_user(auth_token: auth_token)

      if user
        log_in user
        @current_user = user
      else
        forget_current_user
        return
      end
    end
  end

  def logged_in?
    current_user.present?
  end

  def forget_current_user
    cookies.delete(:auth_token)
  end

  def log_out
    return unless logged_in?
    forget_current_user
    session.delete(:user_id)
    @current_user = nil
  end

  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

end
