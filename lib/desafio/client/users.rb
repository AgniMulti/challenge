module Desafio
  class Client

    # Metodos para API de Users
    #
    # @see https://developer.github.com/v3/users/
    module Users


      # Obter access_token.
      #
      # https://developer.github.com/v3/oauth/#web-application-flow
      # @example
      #   Desafio.exchange_code_for_token('aaaa', 'xxxx', 'yyyy', {:accept => 'application/json'})
      def exchange_code_for_token(code, app_id = client_id, app_secret = client_secret, options = {})
        options = options.merge({
          :code => code,
          :client_id => app_id,
          :client_secret => app_secret,
          :headers => {
            :content_type => 'application/json',
            :accept       => 'application/json'
          }
        })

        post "#{web_endpoint}login/oauth/access_token", options
      end


      # https://developer.github.com/v3/users/emails/#list-email-addresses-for-a-user
      # @example
      #   @client.emails
      def emails(options = {})
        paginate "user/emails", options
      end
    end

    private
    def user_path(user, path)
      if user == login && user_authenticated?
        "user/#{path}"
      else
        "#{User.path user}/#{path}"
      end
    end
  end
end
