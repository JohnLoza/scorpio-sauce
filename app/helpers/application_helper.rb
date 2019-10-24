module ApplicationHelper
  def authenticate_user(options = {})
    if options[:auth_token].nil? and options[:email].nil? and options[:password].nil?
      raise ArgumentError, "an :email and :password are required or an :auth_token"
    end

    user = nil
    if options[:auth_token].present?
      decoded_token = JsonWebToken.decode(options[:auth_token])
      return nil unless decoded_token

      user = User.find_by(id: decoded_token[:user_id])
      return nil unless user
    else
      user = User.find_by(email: options[:email])
      return nil unless user and user.authenticate(options[:password])
    end

    return user.active? ? user : nil
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

  def small_variant
    {
      combine_options: {
        auto_orient: true,
        gravity: "center",
        resize: "240x240^",
        crop: "240x240+0+0",
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
