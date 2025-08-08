//Exemplo de Convert Json

import 'dart:convert';

void main() {
  //Texto em formato json
  String dbJson = '''{
            "id":1,
            "nome": "João",
            "login": "joao_user",
            "ativo": true,
            "senha": 1234
                }''';

  //Convertendo texto json -> Map Dart 
  Map<String,dynamic> usuario = json.decode(dbJson);

  print(usuario["login"]); //joao_user

  //Mudar a senha do usuário para 1111

  usuario["senha"] = 1111;

  //Fazer o encode -> Map Dart -> Texto Json 

  dbJson = json.encode(usuario);

  //printar o json

  print(dbJson);
}