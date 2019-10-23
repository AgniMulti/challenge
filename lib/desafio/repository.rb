module Desafio

  class Repository
    attr_accessor :owner, :name, :id
    NAME_WITH_OWNER_PATTERN = /\A[\w.-]+\/[\w.-]+\z/i

    def self.from_url(url)
      new URI.parse(url).path[1..-1].
        gsub(/^repos\//,'').
        split('/', 3)[0..1].
        join('/')
    end

    def initialize(repo)
      case repo
      when Integer
        @id = repo
      when NAME_WITH_OWNER_PATTERN
        @owner, @name = repo.split("/")
      when Repository
        @owner = repo.owner
        @name = repo.name
      when Hash
        @name = repo[:repo] || repo[:name]
        @owner = repo[:owner] || repo[:user] || repo[:username]
      else
        raise_invalid_repository!(repo)
      end
      if @owner && @name
        validate_owner_and_name!(repo)
      end
    end

    def slug
      "#{@owner}/#{@name}"
    end
    alias :to_s :slug

    def path
      return named_api_path if @owner && @name
      return id_api_path if @id
    end

    def self.path repo
      new(repo).path
    end

    def named_api_path
      "repos/#{slug}"
    end

    def id_api_path
      "repositories/#{@id}"
    end

    def url
      "#{Desafio.web_endpoint}#{slug}"
    end

    alias :user :owner
    alias :username :owner
    alias :repo :name

    private

      def validate_owner_and_name!(repo)
        if @owner.include?('/') || @name.include?('/') || !url.match(URI::ABS_URI)
          raise_invalid_repository!(repo)
        end
      end

      def raise_invalid_repository!(repo)
        msg = "#{repo.inspect} identificador invalido. " +
              "Use o formato user/repo (String), ou o Repositorio ID (Integer), ou o hash com :repo e :user keys"
        raise Desafio::InvalidRepository, msg
      end
  end
end
