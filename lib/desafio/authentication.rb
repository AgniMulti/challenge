module Desafio

  # Metodos de Authentication  {Desafio::Client}
  module Authentication

    # https://developer.github.com/early-access/integrations/authentication/#as-an-integration
    def bearer_authenticated?
      !!@bearer_token
    end
    #
    # https://developer.github.com/v3/#authentication
    def user_authenticated?
      basic_authenticated? || token_authenticated?
    end
  end
end
