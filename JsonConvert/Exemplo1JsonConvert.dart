//Exemplo de Convert Json

import 'dart:convert';

void main() {
  String dbJson = '''{
            "id":1,
            "nome": "João",
            "login": "joao_user",
            "ativo": true,
            "senha": 1234
                }''';

  Map<String,dynamic> usuario = json.decode(dbJson);

  print(usuario["login"]); //joao_user

  //Mudar a senha do usuário para 1111

  usuario["senha"] = 1111;

  //Fazer o encode

  dbJson = json.encode(usuario);

  //printar o json

  print(dbJson);
}