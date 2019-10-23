require 'Desafio/middleware/follow_redirects'
require 'Desafio/response/raise_error'
require 'Desafio/response/feed_parser'
require 'Desafio/version'

module Desafio

  module Default

    # Default API endpoint
    API_ENDPOINT = "https://api.github.com".freeze

    USER_AGENT   = "Desafio Ruby Gem #{Desafio::VERSION}".freeze

    MEDIA_TYPE   = "application/vnd.github.v3+json".freeze

    WEB_ENDPOINT = "https://github.com".freeze

    RACK_BUILDER_CLASS = defined?(Faraday::RackBuilder) ? Faraday::RackBuilder : Faraday::Builder

    MIDDLEWARE = RACK_BUILDER_CLASS.new do |builder|
      builder.use Faraday::Request::Retry, exceptions: [Desafio::ServerError]
      builder.use Desafio::Middleware::FollowRedirects
      builder.use Desafio::Response::RaiseError
      builder.use Desafio::Response::FeedParser
      builder.adapter Faraday.default_adapter
    end

    class << self

      def options
        Hash[Desafio::Configurable.keys.map{|key| [key, send(key)]}]
      end

      def access_token
        ENV['Desafio_ACCESS_TOKEN']
      end

      def api_endpoint
        ENV['Desafio_API_ENDPOINT'] || API_ENDPOINT
      end

      def auto_paginate
        ENV['Desafio_AUTO_PAGINATE']
      end

      def bearer_token
        ENV['Desafio_BEARER_TOKEN']
      end

      def client_id
        ENV['Desafio_CLIENT_ID']
      end

      def client_secret
        ENV['Desafio_SECRET']
      end

      def connection_options
        {
          :headers => {
            :accept => default_media_type,
            :user_agent => user_agent
          }
        }
      end

      def default_media_type
        ENV['Desafio_DEFAULT_MEDIA_TYPE'] || MEDIA_TYPE
      end

      def login
        ENV['Desafio_LOGIN']
      end

      def middleware
        MIDDLEWARE
      end

      def password
        ENV['Desafio_PASSWORD']
      end

      def per_page
        page_size = ENV['Desafio_PER_PAGE']

        page_size.to_i if page_size
      end

      def proxy
        ENV['Desafio_PROXY']
      end

      def ssl_verify_mode
        ENV.fetch('Desafio_SSL_VERIFY_MODE', 1).to_i
      end

      def user_agent
        ENV['Desafio_USER_AGENT'] || USER_AGENT
      end

      def web_endpoint
        ENV['Desafio_WEB_ENDPOINT'] || WEB_ENDPOINT
      end

      def netrc
        ENV['Desafio_NETRC'] || false
      end

      def netrc_file
        ENV['Desafio_NETRC_FILE'] || File.join(ENV['HOME'].to_s, '.netrc')
      end

    end
  end
end
