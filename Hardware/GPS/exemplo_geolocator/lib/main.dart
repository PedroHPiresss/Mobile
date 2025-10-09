// exemplo de uso do GPS

import 'package:exemplo_geolocator/clima_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main(){
  runApp(MaterialApp(
    home: LocationScreen(),
  ));
}

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  //atributos
  String mensagem = "";
  final ClimaService climaService = ClimaService();
  
  //método para pegar a localização dos dispositivo
  // verificar se a localização esta liberada para uso no app
  Future<Position?> getLocation() async{
    bool serviceEnabled;
    LocationPermission permission;

    //verificar se o serviço de localização esta liberado no dispositivo 
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      throw Exception("Serviço de Localização desabilitado");
    }
    //solictar a liberação do serviço 
    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied){
        throw Exception("Permissão de Localização Negada");
      }
    }
    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  Future<String> getLocationWeather() async{
    final position = await getLocation();
    if(position == null) throw Exception("Posição nula");

    final climaPosition = await climaService.getCityWeatherByPosition(position);
    if(climaPosition == null) throw Exception("Clima nulo");

    return "${climaPosition["name"]} -- ${climaPosition["main"]["temp"] - 273} -- Sensação de: ${climaPosition["main"]["temp"]}";
  }

  @override
  void initState() {
    super.initState();
    //chamar o método ao iniciar a aplicação;
    setState(() {
      mensagem = getLocation().toString();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("GPS - Localização"),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(mensagem),
            ElevatedButton(
              onPressed: () async{
                String result = await getLocationWeather();
                setState(() {
                  mensagem = result;
                });
              }, 
              child: Text("Obter Localização"))
          ],
        ),
      ),
    );
  }
}