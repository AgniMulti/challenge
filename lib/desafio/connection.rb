require 'sawyer'
require 'Desafio/authentication'
module Desafio

  # Camada de Network 
  module Connection

    include Desafio::Authentication

    CONVENIENCE_HEADERS = Set.new([:accept, :content_type])

    def get(url, options = {})
      request :get, url, parse_query_and_convenience_headers(options)
    end

    def post(url, options = {})
      request :post, url, options
    end

    def put(url, options = {})
      request :put, url, options
    end

    def patch(url, options = {})
      request :patch, url, options
    end

    def delete(url, options = {})
      request :delete, url, options
    end

    def head(url, options = {})
      request :head, url, parse_query_and_convenience_headers(options)
    end

    def paginate(url, options = {}, &block)
      opts = parse_query_and_convenience_headers(options)
      if @auto_paginate || @per_page
        opts[:query][:per_page] ||=  @per_page || (@auto_paginate ? 100 : nil)
      end

      data = request(:get, url, opts.dup)

      if @auto_paginate
        while @last_response.rels[:next] && rate_limit.remaining > 0
          @last_response = @last_response.rels[:next].get(:headers => opts[:headers])
          if block_given?
            yield(data, @last_response)
          else
            data.concat(@last_response.data) if @last_response.data.is_a?(Array)
          end
        end

      end

      data
    end

    def agent
      @agent ||= Sawyer::Agent.new(endpoint, sawyer_options) do |http|
        http.headers[:accept] = default_media_type
        http.headers[:content_type] = "application/json"
        http.headers[:user_agent] = user_agent
        if basic_authenticated?
          http.basic_auth(@login, @password)
        elsif token_authenticated?
          http.authorization 'token', @access_token
        elsif bearer_authenticated?
          http.authorization 'Bearer', @bearer_token
        elsif application_authenticated?
          http.params = http.params.merge application_authentication
        end
      end
    end

    def root
      get "/"
    end

    def last_response
      @last_response if defined? @last_response
    end
    

    def endpoint
      api_endpoint
    end

    private

    def reset_agent
      @agent = nil
    end

    def request(method, path, data, options = {})
      if data.is_a?(Hash)
        options[:query]   = data.delete(:query) || {}
        options[:headers] = data.delete(:headers) || {}
        if accept = data.delete(:accept)
          options[:headers][:accept] = accept
        end
      end

      @last_response = response = agent.call(method, Addressable::URI.parse(path.to_s).normalize.to_s, data, options)
      response.data
    end

    def boolean_from_response(method, path, options = {})
      request(method, path, options)
      @last_response.status == 204
    rescue Desafio::NotFound
      false
    end


    def sawyer_options
      opts = {
        :links_parser => Sawyer::LinkParsers::Simple.new
      }
      conn_opts = @connection_options
      conn_opts[:builder] = @middleware if @middleware
      conn_opts[:proxy] = @proxy if @proxy
      if conn_opts[:ssl].nil?
        conn_opts[:ssl] = { :verify_mode => @ssl_verify_mode } if @ssl_verify_mode
      else 
        if @connection_options[:ssl][:verify] == false
          conn_opts[:ssl] = { :verify_mode => 0}
        else
          conn_opts[:ssl] = { :verify_mode => @ssl_verify_mode }
        end
      end
      opts[:faraday] = Faraday.new(conn_opts)

      opts
    end

    def parse_query_and_convenience_headers(options)
      options = options.dup
      headers = options.delete(:headers) { Hash.new }
      CONVENIENCE_HEADERS.each do |h|
        if header = options.delete(h)
          headers[h] = header
        end
      end
      query = options.delete(:query)
      opts = {:query => options}
      opts[:query].merge!(query) if query && query.is_a?(Hash)
      opts[:headers] = headers unless headers.empty?

      opts
    end
  end
end
