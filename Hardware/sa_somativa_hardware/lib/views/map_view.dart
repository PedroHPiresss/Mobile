import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sa_somativa_hardware/controllers/location_controller.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final _locationController = LocationController();
  final _mapController = MapController();
  LatLng? _workplaceLocation;
  LatLng? _currentLocation;
  LatLng? _selectedLocation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadWorkplaceLocation();
    _loadCurrentLocation();
  }

  void _loadWorkplaceLocation() async {
    var workplace = await _locationController.getWorkplace();
    setState(() {
      _workplaceLocation = LatLng(
        workplace?.latitude ?? LocationController.defaultWorkplaceLatitude,
        workplace?.longitude ?? LocationController.defaultWorkplaceLongitude,
      );
    });
  }

  void _loadCurrentLocation() async {
    try {
      var position = await _locationController.getCurrentPosition();
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        if (_selectedLocation == null) {
          _selectedLocation = _currentLocation;
        }
      });
    } catch (e) {
      // Handle error silently
    }
  }

  void _setWorkplaceLocation() async {
    if (_selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Selecione um local no mapa"),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _locationController.setWorkplace(
        _selectedLocation!.latitude,
        _selectedLocation!.longitude,
        "Meu Local de Trabalho"
      );
      setState(() {
        _workplaceLocation = _selectedLocation;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Local de trabalho definido"),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao definir local: $e"),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrar Local de Trabalho"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange.shade700, Colors.orange.shade500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: _workplaceLocation == null
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentLocation ?? _workplaceLocation!,
                initialZoom: 15,
                onTap: (tapPosition, point) {
                  setState(() {
                    _selectedLocation = point;
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  userAgentPackageName: "com.example.sa_somativa_hardware",
                ),
                MarkerLayer(
                  markers: [
                    // Workplace marker
                    Marker(
                      point: _workplaceLocation!,
                      width: 50,
                      height: 50,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 35,
                      ),
                    ),
                    // Current location marker (if available)
                    if (_currentLocation != null)
                      Marker(
                        point: _currentLocation!,
                        width: 50,
                        height: 50,
                        child: const Icon(
                          Icons.my_location,
                          color: Colors.blue,
                          size: 35,
                        ),
                      ),
                    // Selected location marker
                    if (_selectedLocation != null)
                      Marker(
                        point: _selectedLocation!,
                        width: 50,
                        height: 50,
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.green,
                          size: 35,
                        ),
                      ),
                  ],
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading ? null : _setWorkplaceLocation,
        backgroundColor: Colors.orange.shade600,
        foregroundColor: Colors.white,
        elevation: 6,
        child: _isLoading
            ? const CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : const Icon(Icons.save),
      ),
    );
  }
}
