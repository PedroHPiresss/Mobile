import 'package:biblioteca_app/controllers/user_controler.dart';
import 'package:biblioteca_app/models/user_model.dart';
import 'package:biblioteca_app/views/user/user_list_view.dart';
import 'package:flutter/material.dart';

class UserFormView extends StatefulWidget {
  //atributo
  final UserModel? user; //Pode ser nulo

  const UserFormView({super.key, this.user});

  @override
  State<UserFormView> createState() => _UserFormViewState();
}

class _UserFormViewState extends State<UserFormView> {
  //atributos
  final _formkey = GlobalKey<FormState>(); //Armazenar as informações do form
  final _controller = UserControler();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //Se for edição de usuário existente
    if(widget.user !=null){
    _nameController.text = widget.user!.name;
    _emailController.text = widget.user!.email;
    }
  }

  void _save() async{
    if(_formkey.currentState!.validate()){
      final user = UserModel(
        name: _nameController.text,
        email: _emailController.text);
      await _controller.create(user);
      Navigator.pop(context);
      Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (context)=> UserListView()));
    }
  }

  void _update() async{
    if(_formkey.currentState!.validate()){
      final user = UserModel(
        id: widget.user?.id,
        name: _nameController.text,
        email: _emailController.text);
      await _controller.update(user);
      Navigator.pop(context);
      Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (context)=> UserListView()));
    }
  }

  //build da tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(
        widget.user == null ? "Novo Usuário" : "Editar Usuário"
      ),),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Nome"),
                validator: (value) => value!.isEmpty? "Informe o nome": null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
                validator: (value) => value!.isEmpty? "Informe o email": null,
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: widget.user == null ? _save : _update,
                child: Text(widget.user == null ? "Salvar" : "Atualizar"))
            ],
          )),),
    );
  }
}