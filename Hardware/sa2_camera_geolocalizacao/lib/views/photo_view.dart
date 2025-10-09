// galeria de imagems com localização 

import 'package:flutter/material.dart';

class PhotoView extends StatefulWidget {
  const PhotoView({super.key});

  @override
  State<PhotoView> createState() => _PhotoViewState();
}

class _PhotoViewState extends State<PhotoView> {
  List photos = []; //lista de fotos

  //método para tirar photo com localização
  void takePhoto() async {
    //chamar o controlador para tirar a foto com localização
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo View'),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: () {
              //chamar o método para tirar a foto com localização
            },
          ),
        ],
      ),
      body: //Constroi o Grid com as Imagens Tiradas
          GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: photos.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              //mostrar a foto em tela cheia com a localização
            },
            child: Image.file(
              //pega o caminho da foto e mostra na tela
              photos[index].photoPath,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}