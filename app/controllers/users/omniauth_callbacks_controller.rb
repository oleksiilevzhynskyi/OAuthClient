class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def myprovider
    p current_user
    # You need to implement the method below in your model
    @user = User.find_for_myprovider_oauth(env["omniauth.auth"], current_user)
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Twitter"
      p 'user persisted!'
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.myprovider_data"] = env["omniauth.auth"]
      redirect_to new_user_session_path
    end
  end

  def passthru
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end


end

