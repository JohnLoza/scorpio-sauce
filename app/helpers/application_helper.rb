module ApplicationHelper
  def authenticate_user(session = {})
    email = session[:email]
    password = session[:password]

    user = User.find_by(email: email)
    if user and user.authenticate(password)
      return user
    else
      return nil
    end
  end

  def avatar_variant
    {
      combine_options: {
        auto_orient: true,
        gravity: "center",
        resize: "180x180^",
        crop: "180x180+0+0",
      }
    }
  end

  def thumbnail_variant
    {
      combine_options: {
        auto_orient: true,
        gravity: "center",
        resize: "640x640^",
        crop: "640x640+0+0",
      }
    }
  end
end
