# challenge
Criação de uma aplicação de integração com a API do GitHub (mais especificamente, o endpoint de buscas)
utilizando Ruby e Rails.

Requisitos:

1) Autenticação via JWT;
2) Listagem de todos os repositórios públicos;

3) Busca de repositórios possibilitando:
** Termo de busca textual (texto livre a ser pesquisado);
** Buscar por linguagem específica (valor padrão ‘ruby’);
** Buscar por repositórios de um usuário;
*** Ordenar via quantidade de estrelas de um repositório;
*** Ordenar via quantidade de forks de um repositório;
*** Ordenar via data de atualização;
*** Permitir ordenação ascendente e descendente;

4) Repositórios devem conter:
** Nome completo;
** Descrição;
** Quantidade de estrelas;
** Quantidade de forks;
** Nome do autor;

Descrição da solução:

Será feito uso do Desafio - Ruby toolkit for the GitHub API.

Instalação via Rubygems:

gem install Desafio
gem "Desafio", "~> 4.0"

Para usar a library no Ruby:
require 'Desafio'

mais info > http://Desafio.github.io/Desafio.rb/Desafio/Client.html
