import 'package:geolocator/geolocator.dart';
import 'package:sa_somativa_hardware/controllers/firestore_controller.dart';
import 'package:sa_somativa_hardware/models/workplace.dart';

class LocationController {
  // Default workplace coordinates (São Paulo)
  static const double defaultWorkplaceLatitude = -23.5505;
  static const double defaultWorkplaceLongitude = -46.6333;
  static const double maxDistance = 100.0; // 100 meters

  final FirestoreController _firestoreController = FirestoreController();

  Future<bool> isWithinWorkplace() async {
    // Check if location service is enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Serviço de localização desabilitado');
    }

    // Check permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permissão de localização negada');
      }
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition();

    // Get workplace location from Firestore or use default
    Workplace? workplace = await _firestoreController.getWorkplace();
    double workplaceLat = workplace?.latitude ?? defaultWorkplaceLatitude;
    double workplaceLng = workplace?.longitude ?? defaultWorkplaceLongitude;

    // Calculate distance
    double distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      workplaceLat,
      workplaceLng,
    );

    return distance <= maxDistance;
  }

  Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition();
  }

  Future<void> setWorkplace(double latitude, double longitude, String name) async {
    Workplace workplace = Workplace(
      id: _firestoreController.currentUser!.uid,
      userId: _firestoreController.currentUser!.uid,
      latitude: latitude,
      longitude: longitude,
      name: name,
    );
    await _firestoreController.saveWorkplace(workplace);
  }

  Future<Workplace?> getWorkplace() async {
    return await _firestoreController.getWorkplace();
  }
}
