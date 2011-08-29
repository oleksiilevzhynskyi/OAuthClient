class User < ActiveRecord::Base
  devise :database_authenticatable, :omniauthable

  attr_accessible :name, :email, :login, :password, :password_confirmation, :oauth_id, :screen_name

  def self.find_for_myprovider_oauth(access_token, signed_in_resource=nil)
    data = access_token['extra']['user_hash']
    p data
    if user = User.find_by_oauth_id(data["id"])
      user
    else # Create a user with a stub password.
      user = User.create(:password => Devise.friendly_token[0,20], :name => data["name"], :oauth_id => data["id"].to_i, :screen_name => data["screen_name"])
      user.save
      user
    end
  end

end

