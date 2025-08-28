class UserModel {
  //atributos
  final String? id; // pode ser nulo inicialmente
  final String name;
  final String email;
  //construtor
  UserModel({
    this.id,
    required this.name,
    required this.email
  });

  //métodos
  //toJson => OBJ => MAP
  Map<String,dynamic> toJson() => {
    "id":id,
    "name":name,
    "email":email
    };

  //fromJson MAP => OBJ
  factory UserModel.fromJson(Map<String,dynamic> json) => UserModel(
    id: json["id"].toString(),
    name: json["name"].toString(), 
    email: json["email"].toString());
}