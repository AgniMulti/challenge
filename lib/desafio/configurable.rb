module Desafio

    module Configurable

    attr_accessor :access_token, :auto_paginate, :bearer_token, :client_id,
                  :client_secret, :default_media_type, :connection_options,
                  :middleware, :netrc, :netrc_file,
                  :per_page, :proxy, :ssl_verify_mode, :user_agent
    attr_writer :password, :web_endpoint, :api_endpoint, :login,
                :management_console_endpoint, :management_console_password

    class << self

      def keys
        @keys ||= [
          :access_token,
          :api_endpoint,
          :auto_paginate,
          :bearer_token,
          :client_id,
          :client_secret,
          :connection_options,
          :default_media_type,
          :login,
          :management_console_endpoint,
          :management_console_password,
          :middleware,
          :netrc,
          :netrc_file,
          :per_page,
          :password,
          :proxy,
          :ssl_verify_mode,
          :user_agent,
          :web_endpoint
        ]
      end
    end

    def configure
      yield self
    end

    def reset!
      Desafio::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", Desafio::Default.options[key])
      end
      self
    end
    alias setup reset!

    def same_options?(opts)
      opts.hash == options.hash
    end

    def api_endpoint
      File.join(@api_endpoint, "")
    end

    def login
      @login ||= begin
        user.login if token_authenticated?
      end
    end


    private

    def options
      Hash[Desafio::Configurable.keys.map{|key| [key, instance_variable_get(:"@#{key}")]}]
    end

    def fetch_client_id_and_secret(overrides = {})
      opts = options.merge(overrides)
      opts.values_at :client_id, :client_secret
    end
  end
end
