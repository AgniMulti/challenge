module Desafio
  class Client

    # Metodos para Repositories API
    #
    # https://developer.github.com/v3/repos/
    module Repositories

      # Listar repositorios de usuário
      #
      # https://developer.github.com/v3/repos/#list-your-repositories
      # https://developer.github.com/v3/repos/#list-user-repositories
      def repositories(user=nil, options = {})
        paginate "#{User.path user}/repos", options
      end
      alias :list_repositories :repositories
      alias :list_repos :repositories
      alias :repos :repositories

      # Listar todos repositorios
      #
      # @see https://developer.github.com/v3/repos/#list-all-public-repositories
      def all_repositories(options = {})
        paginate 'repositories', options
      end



      # Listar forks
      #
      # @see https://developer.github.com/v3/repos/forks/#list-forks
      # @example
      #   Desafio.forks('Desafio/Desafio.rb')
      # @example
      #   Desafio.network('Desafio/Desafio.rb')
      # @example
      #   @client.forks('Desafio/Desafio.rb')
      def forks(repo, options = {})
        paginate "#{Repository.path repo}/forks", options
      end
      alias :network :forks

    end
  end
end
