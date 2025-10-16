import 'package:geolocator/geolocator.dart';

class LocationController {
  // Coordenadas do local dea trabalho exemplo
  static const double workplaceLatitude = -23.5505;
  static const double workplaceLongitude = -46.6333;
  static const double maxDistance = 100.0; // 100 metrosssss

  Future<bool> isWithinWorkplace() async {
    // verifica se a localizaçao ta ligada e da um toque no cara
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Serviço de localização desabilitado');
    }

    // varifiCar permisaao
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permissão de localização negada');
      }
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition();

    // Calcular distancia
    double distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      workplaceLatitude,
      workplaceLongitude,
    );

    return distance <= maxDistance;
  }

  Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition();
  }
}
