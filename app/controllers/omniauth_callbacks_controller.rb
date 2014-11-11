class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :authenticate_user!, only: [:github]

  # GET /users/auth/redbooth/callback
  def redbooth
    sing_up_or_login('redbooth')
  end

  protected

  # Finds or creates user in the system based on the omniauth provider info
  # and creates also the session for that user
  #
  # @param provider [String] provider name to store the session data
  def sing_up_or_login(provider='omniauth')
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      @user.update_from_omniauth(request.env["omniauth.auth"]) unless @user.new_record?
      sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: provider.capitalize) if is_navigational_format?
    else
      session["devise.#{provider}_data"] = request.env["omniauth.auth"]
      redirect_to root_path
    end
  end
end
