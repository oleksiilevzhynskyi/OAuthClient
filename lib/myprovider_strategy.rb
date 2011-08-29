require 'omniauth/core'
module OmniAuth
  module Strategies
    class Myprovider
      include OmniAuth::Strategy

      # receive parameters from the strategy declaration and save them
      def initialize(app, client_id=nil, client_secret=nil, options={}, &block)
        @secret = client_secret
        @client_id = client_id
        client_options = {
          :site => "http://localhost:3333",
          :authorize_url => "http://localhost:3333/oauth/autorize",
          :token_url => "http://localhost:3333/oauth/access_token"
        }
        @auth_redirect = "http://localhost:3333/oauth/autorize"
        super(app, :myprovider, client_id, client_secret, client_options, &block)

        #super(app, :myprovider, options)
      end

      # redirect to the Myprovider website
      def request_phase
        r = Rack::Response.new
        r.redirect @auth_redirect + "?oauth=#{@client_id + Digest::SHA1.hexdigest(@secret)};callback_url=http://localhost:3000/users/auth/myprovider/callback"
        r.finish
      end

      def callback_phase
        uid, username, token = request.params["uid"], request.params["username"], request.params["token"]
        sha1 = Digest::SHA1.hexdigest("#{@secret}, #{uid}, #{username}")
        p sha1
        # check if the request comes from Myprovider or not
	      if sha1 == token
          @uid, @username = uid, username
          # OmniAuth takes care of the rest
          super
        else
	        # OmniAuth takes care of the rest
          fail!(:invalid_credentials)
        end
       end

      def build_access_token
        @access_token = ::OAuth2::AccessToken.new(client, myprovider_session['access_token'], {:mode => :query, :param_name => 'access_token'})
      end


      # normalize user's data according to http://github.com/intridea/omniauth/wiki/Auth-Hash-Schema
      def auth_hash
        OmniAuth::Utils.deep_merge(super(), {
          'uid' => @uid,
          'user_info' => {
            'name'     => @username,
            'nickname' => @username,
          }
        })
      end
    end
  end
end

