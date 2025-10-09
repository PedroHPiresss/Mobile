import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main(){
  runApp(MaterialApp(
    home: BluetoothScreen(),
  ));
}

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  State<BluetoothScreen> createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  //atributos
  List<ScanResult> dispositivos = [];
  bool pesquisando = false;

  void _startScan(){
    setState(() {
      dispositivos.clear();
      pesquisando = true;
    });
    FlutterBluePlus.startScan(timeout: Duration(seconds: 5));
    FlutterBluePlus.scanResults.listen((results){
      setState(() {
        dispositivos = results;
        pesquisando = false;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startScan();
  }

  void connect() {
    //connectar com o dispositivo bluetooth
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dispositivos Bluetooth"),),
      body: pesquisando 
      ? Center(child: CircularProgressIndicator(),)
      :  dispositivos.isEmpty
      ? Center(child: Text("Lista Vazia"),)
      : Expanded(
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: dispositivos.length,
          itemBuilder: (context,index){
            final device = dispositivos[index];
            return ListTile(
              title: Text(device.device.name.isEmpty ? "Dispositivo sem Nome" : device.device.name),
              subtitle: Text(device.device.id.toString()),
              trailing: Text(device.rssi.toString()), // intenidade do sinal
            );
          }))
      
      );
  }
}