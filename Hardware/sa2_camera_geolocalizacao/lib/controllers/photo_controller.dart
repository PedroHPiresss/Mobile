// controlador para pegar a photo a localização

import 'dart:convert';
import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:sa2_camera_geolocalizacao/models/photo.dart';

class PhotoController {
  //método para pegar a foto com a localização

  Future<Photo> photoWithLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    final _picker = ImagePicker(); //obj controlador do uso da camera/galeria
    String photoPath = '';
    String _apiKey = 'sua_api_key_aqui';
    String cityName = '';

    //verifica se o serviço de localização está habilitado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Serviço de localização desabilitado');
    }
    //verifica a permissão de uso do serviço de localização
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permissão de localização negada');
      }
    }

    //pegar a localização atual
    Position position = await Geolocator.getCurrentPosition();
    // usar camera para tirar a foto
    // salvar a foto em um arquivo temporário
    // salvar a localização e o caminho da foto em um objeto Photo
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      // peguei da memoria e carrego para o aplicativo
      photoPath = File(pickedFile.path).toString();

      // pegar a localização atual da cidade usando WeatherAPI
      final result = await http.get(
        Uri.parse(
          'http://api.openWeathermap.org/data/2.5/weather?appid=$_apiKey&q=${position.latitude},${position.longitude}',
        ),
      );
      if (result.statusCode == 200) {
        //pegar o nome da cidade
        Map<String, dynamic> data = jsonDecode(
          result.body,
        ); //aqui você deve fazer o parse do JSON para pegar o nome da cidade
        cityName = data['name'];
      } else {
        throw Exception('Erro ao carregar a cidade');
      }
    }
    
    //criar um OBJ
    Photo photo = Photo(
      cityName: cityName,
      dateTime: DateTime.now().toString(), //converte em data 
      photoPath: photoPath,
    );
    return photo;
  }
}
