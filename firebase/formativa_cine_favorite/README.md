# Cine Favorite (Formativa)

Construir um aplicativo do zero - O Cinefavorite que permitirá criar uma conta e buscar filmes em uma API e montar uma galeria pessoal de filmes favoritos, com poster e nota avaliativa do usuário para o filme

## Objetivos
- Criar uma galeria personalisada por usuário de filmes favoritos
- Conectar o app com uma API (base de dados) de filmes (TMDE)
- Permitir a criação de contas para cada usuário
- Listar filmes por uma palavra-chave

## Levantamento de Requisitos do Projeto
- ## Funcionais

- ### Não Funcionais

## Recursos do Projeto
- Linguagem de programação: Flutter/Dart
- API TMDB: Base de dados para filmes
- Firebase: Authentication/FireStore
- Figma: Prototipagem
- VSCode
- GitHub

## Diagramas
1. Classe
Demonstrar o funcionamento das entidades do sistema

- Usuário (User): Classe já modelada pelo FirebaseAuth
    - Atributos: email, senha, uid
    - Métodos: login, registrar, logout

- Filmes Favoritos (FavoriteMovie): Classe Modelada pelo DEV
    - Atributos: id, titulo, PosterPath, Nota
    - Métodos: adicionar, remover, listar, atualizarNota (CRUD)

```mermaid

    classDiagram
        class User{
            +String uid
            +String email
            +String password
            +createUser()
            +login()
            +logout()
        }

        class FavoriteMovie{
            +int id
            +String title
            +String posterPath
            +double Rating 
            +addFavorite()
            +removeFavorite()
            +updateMovieRating()
            +getFavoriteMovies()
        }

        User "1"--"1+" FavoriteMovie: "select"

```

2. ### Uso
Ação que os atores podem fazer
- Usuário (User):
    - Registrar
    - Login
    - Logout
    - Procurar filmes na API
    - Salvar filmes aos favoritos
    - Dar nota aos filmes favoritos
    - Remover filme dos favoritos

```mermaid

    graph TD
        subgraph "Ações"
            ac1([Registrar])
            ac2([Login])
            ac3([Logout])
            ac4([SearchMovies])
            ac5([AddFavoriteMovie])
            ac6([UpdateRatingMovie])
            ac7([RemoveFavoriteMovie])
        end

        user([Usuário])

        user --> ac1
        user --> ac2

        ac1 --> ac2
        ac2 --> ac3
        ac2 --> ac4
        ac2 --> ac5
        ac2 --> ac6
        ac2 --> ac7

```
