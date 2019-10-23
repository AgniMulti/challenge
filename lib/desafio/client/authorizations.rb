module Desafio
  class Client

    # Metodos para autorização API
    #
    # https://developer.github.com/v3/oauth_authorizations/#oauth-authorizations-api
    module Authorizations

      # https://developer.github.com/v3/oauth/#scopes
      def scopes(token = @access_token, options = {})
        options= options.dup
        raise ArgumentError.new("Token de acesso requerido") if token.nil?

        auth = { "Authorization" => "token #{token}" }
        headers = (options.delete(:headers) || {}).merge(auth)

        agent.call(:get, "user", :headers => headers).
          headers['X-OAuth-Scopes'].
          to_s.
          split(',').
          map(&:strip).
          sort
      end

    end
  end
end
