class AuthenticationsController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]

    logger.debug "auth:#{auth}"

    # Try to find stored authentication first
    authentication = Authentication.find_by_provider_and_uid(auth['provider'], auth['uid'])

    if authentication    # Authentication found, sign the user in.
      user = User.from_omniauth(request.env["omniauth.auth"])
      authentication.token = auth.credentials.token
      if authentication.user.nil?
        authentication.user = user
      end
      authentication.save
      logger.debug "Authentication:#{authentication.inspect}"

      flash[:notice] = "#{user.name} signed in through #{user.provider} successfully."
      sign_in_and_redirect(:user, authentication.user)
    else
      # Authentication not found, thus a new user.
      user = User.new
      user.apply_omniauth(auth)
      if user.save(validate: false)
        flash[:notice] = "Account created and signed in successfully."
        sign_in_and_redirect(:user, user)
      else
        flash[:error] = "Error while creating a user account. Please try again."
        redirect_to root_url
      end
    end
  end

  def google_oauth2
    user = User.from_omniauth(request.env["omniauth.auth"])
    if user.persisted?
      flash.notice = "Signed in Through Google!"
      sign_in_and_redirect user
    else
      session["devise.user_attributes"] = user.attributes
      flash.notice = "You are almost Done! Please provide a password to finish setting up your account"
      redirect_to new_user_registration_url
    end
  end

  def facebook
    create
  end

  def twitter
    create
  end

  def linkedin
    create
  end

  def passthru
    create
  end
end