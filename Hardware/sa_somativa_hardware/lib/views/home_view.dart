import 'package:flutter/material.dart';
import 'package:sa_somativa_hardware/controllers/auth_controller.dart';
import 'package:sa_somativa_hardware/controllers/firestore_controller.dart';
import 'package:sa_somativa_hardware/controllers/location_controller.dart';
import 'package:sa_somativa_hardware/models/clock_record.dart';
import 'package:sa_somativa_hardware/views/map_view.dart';
import 'package:intl/intl.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _authController = AuthController();
  final _locationController = LocationController();
  final _firestoreController = FirestoreController();
  bool _isLoading = false;

  void _clockIn() async {
    setState(() => _isLoading = true);

    try {
      // Check location
      bool isWithinWorkplace = await _locationController.isWithinWorkplace();
      if (!isWithinWorkplace) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Você não está no local de trabalho")),
        );
        return;
      }

      // Determine type (entry or exit)
      ClockRecord? lastRecord = await _firestoreController.getLastClockRecordToday();
      String type = (lastRecord == null || lastRecord.type == 'exit') ? 'entry' : 'exit';

      // Get current position
      var position = await _locationController.getCurrentPosition();

      // Create record
      String now = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      List<String> dateTime = now.split(' ');
      ClockRecord record = ClockRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: _authController.currentUser!.uid,
        type: type,
        date: dateTime[0],
        time: dateTime[1],
        latitude: position.latitude,
        longitude: position.longitude,
      );

      // Salvar no firestore
      await _firestoreController.saveClockRecord(record);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ponto de ${type == 'entry' ? 'entrada' : 'saída'} registrado")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _logout() async {
    await _authController.logout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sistema de Ponto"),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Bem-vindo ao Sistema de Ponto",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MapView()),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: const Text("Registrar Local de Trabalho"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _clockIn,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text("Bater Ponto"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              "Histórico de Pontos",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            StreamBuilder<List<ClockRecord>>(
              stream: _firestoreController.getClockRecords(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<ClockRecord> records = snapshot.data!;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: records.length,
                      itemBuilder: (context, index) {
                        ClockRecord record = records[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text("${record.type == 'entry' ? 'Entrada' : 'Saída'}"),
                            subtitle: Text("${record.date} ${record.time}"),
                            trailing: Text("Lat: ${record.latitude.toStringAsFixed(4)}\nLng: ${record.longitude.toStringAsFixed(4)}"),
                          ),
                        );
                      },
                    ),
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
