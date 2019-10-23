module Desafio
  class Client

    # Metodos API de Busca
    #
    # https://developer.github.com/v3/search/
    module Search

      def search_code(query, options = {})
        search "search/code", query, options
      end

      # Buscar repositories
      #
      def search_repositories(query, options = {})
        search "search/repositories", query, options
      end
      alias :search_repos :search_repositories

      private

      def search(path, query, options = {})
        opts = options.merge(:q => query)
        paginate(path, opts) do |data, last_response|
          data.items.concat last_response.data.items
        end
      end
    end
  end
end
