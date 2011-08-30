require 'omniauth/core'

module OmniAuth
  module Strategies
    class Myprovider < OmniAuth::Strategies::OAuth2
       # receive parameters from the strategy declaration and save them
      def initialize(app, client_id=nil, client_secret=nil, options={}, &block)
        client_options = {
          :site => "http://localhost:3333",
          :authorize_url => "http://localhost:3333/oauth/autorize",
          :token_url => "http://localhost:3333/oauth/access_token"
        }
        super(app, :myprovider, client_id, client_secret, client_options, &block)
      end

      # redirect to the Myprovider website
      def request_phase
        super
      end

      #TODO: implement check if the request comes from Myprovider or not
      def callback_phase
        super
      end

      def build_access_token
        super
        #@access_token = ::OAuth2::AccessToken.new(client, myprovider_session['access_token'], {:mode => :query, :param_name => 'access_token'})
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

