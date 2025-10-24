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
          SnackBar(
            content: const Text("Você não está no local de trabalho"),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
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
        SnackBar(
          content: Text("Ponto de ${type == 'entry' ? 'entrada' : 'saída'} registrado"),
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
          content: Text("Erro: $e"),
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

  void _logout() async {
    await _authController.logout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sistema de Ponto"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade700, Colors.blue.shade500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.access_time,
                size: 80,
                color: Colors.blue.shade700,
              ),
              const SizedBox(height: 20),
              Text(
                "Bem-vindo ao Sistema de Ponto",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MapView()),
                      ),
                      icon: const Icon(Icons.map),
                      label: const Text("Registrar Local"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        shadowColor: Colors.orange.shade200,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _clockIn,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.check_circle),
                      label: const Text("Bater Ponto"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        shadowColor: Colors.green.shade200,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      "Histórico de Pontos",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    StreamBuilder<List<ClockRecord>>(
                      stream: _firestoreController.getClockRecords(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<ClockRecord> records = snapshot.data!;
                          if (records.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                "Nenhum registro encontrado",
                                style: TextStyle(color: Colors.grey),
                              ),
                            );
                          }
                          return SizedBox(
                            height: 200,
                            child: ListView.builder(
                              itemCount: records.length,
                              itemBuilder: (context, index) {
                                ClockRecord record = records[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(vertical: 4),
                                  color: record.type == 'entry'
                                      ? Colors.green.shade50
                                      : Colors.red.shade50,
                                  child: ListTile(
                                    leading: Icon(
                                      record.type == 'entry'
                                          ? Icons.login
                                          : Icons.logout,
                                      color: record.type == 'entry'
                                          ? Colors.green.shade700
                                          : Colors.red.shade700,
                                    ),
                                    title: Text(
                                      "${record.type == 'entry' ? 'Entrada' : 'Saída'}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: record.type == 'entry'
                                            ? Colors.green.shade700
                                            : Colors.red.shade700,
                                      ),
                                    ),
                                    subtitle: Text("${record.date} ${record.time}"),
                                    trailing: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Lat: ${record.latitude.toStringAsFixed(4)}",
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                        Text(
                                          "Lng: ${record.longitude.toStringAsFixed(4)}",
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
