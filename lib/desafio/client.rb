require 'Desafio/arguments'
require 'Desafio/repo_arguments'
require 'Desafio/configurable'
require 'Desafio/authentication'
require 'Desafio/repository'
require 'Desafio/user'
require 'Desafio/client/authorizations'
require 'Desafio/client/repositories'
require 'Desafio/client/search'
require 'Desafio/client/users'
require 'ext/sawyer/relation'

module Desafio

  # Client -  GitHub API
  #
  # https://developer.github.com
  class Client

    include Desafio::Authentication
    include Desafio::Configurable
    include Desafio::Connection
    include Desafio::Client::Authorizations
    include Desafio::Client::Repositories
    include Desafio::Client::Search
    include Desafio::Client::Users

    CONVENIENCE_HEADERS = Set.new([:accept, :content_type])

    def initialize(options = {})
      Desafio::Configurable.keys.each do |key|
        value = options.key?(key) ? options[key] : Desafio.instance_variable_get(:"@#{key}")
        instance_variable_set(:"@#{key}", value)
      end

      login_from_netrc unless user_authenticated? || application_authenticated?
    end

    def inspect
      inspected = super

      inspected.gsub! @bearer_token, '********' if @bearer_token

      inspected
    end


    # Bearer Token
    #
    # JWT
    def bearer_token=(value)
      reset_agent
      @bearer_token = value
    end

    def client_without_redirects(options = {})
      conn_opts = @connection_options
      conn_opts[:url] = @api_endpoint
      conn_opts[:builder] = @middleware.dup if @middleware
      conn_opts[:proxy] = @proxy if @proxy
      conn_opts[:ssl] = { :verify_mode => @ssl_verify_mode } if @ssl_verify_mode
      conn = Faraday.new(conn_opts) do |http|
        if basic_authenticated?
          http.basic_auth(@login, @password)
        elsif token_authenticated?
          http.authorization 'token', @access_token
        elsif bearer_authenticated?
          http.authorization 'Bearer', @bearer_token
        end
        http.headers['accept'] = options[:accept] if options.key?(:accept)
      end
      conn.builder.delete(Desafio::Middleware::FollowRedirects)

      conn
    end
  end
end
