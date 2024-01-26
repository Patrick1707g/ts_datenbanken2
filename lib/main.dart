import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ts_datenbanken2/drone.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [DroneSchema],
    directory: dir.path,
  );
  runApp(MainApp(isar: isar));
}

class MainApp extends StatefulWidget {
  final Isar isar;
  const MainApp({super.key, required this.isar});
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  List<Drone?> droneList = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController velocityController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController resolutionController = TextEditingController();
  TextEditingController imgUrlController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            ElevatedButton(
                onPressed: () async {
                  final raptor = Drone(
                      name: "raptor",
                      price: 100.00,
                      color: "black",
                      velocity: 87,
                      flightDuration: 45,
                      camResolution: 10,
                      imgUrl: "undefined");
                  await widget.isar.writeTxn(() async {
                    await widget.isar.drones.put(raptor);
                  });
                  setState(() {
                    droneList = [raptor];
                  });
                },
                child: const Text("Drohne anlegen")),
            ElevatedButton(
                onPressed: () async {
                  var currentDrone = await widget.isar.drones.get(11);
                  setState(() {
                    droneList = [currentDrone];
                  });
                },
                child: const Text("Drohne(n) anzeigen")),
            ElevatedButton(
              onPressed: () async {
                if (droneList.isNotEmpty) {
                  await widget.isar.writeTxn(() async {
                    await widget.isar.drones.delete(droneList[7]!.id);
                  });
                  setState(() {
                    droneList = [];
                  });
                }
              },
              child: const Text("Drohne löschen"),
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: colorController,
              decoration: const InputDecoration(labelText: 'Color'),
            ),
            TextField(
              controller: velocityController,
              decoration: const InputDecoration(labelText: 'Velocity'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: durationController,
              decoration: const InputDecoration(labelText: 'Flight Duration'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: resolutionController,
              decoration: const InputDecoration(labelText: 'Camera Resolution'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: imgUrlController,
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newDrone = Drone(
                  name: nameController.text,
                  price: double.tryParse(priceController.text) ?? 0.0,
                  color: colorController.text,
                  velocity: int.tryParse(velocityController.text) ?? 0,
                  flightDuration: int.tryParse(durationController.text) ?? 0,
                  camResolution: int.tryParse(resolutionController.text) ?? 0,
                  imgUrl: imgUrlController.text,
                );
                await widget.isar.writeTxn(() async {
                  await widget.isar.drones.put(newDrone);
                });
                setState(() {
                  droneList = [newDrone];
                  // Leere die TextController nach dem Hinzufügen
                  nameController.clear();
                  priceController.clear();
                  colorController.clear();
                  velocityController.clear();
                  durationController.clear();
                  resolutionController.clear();
                  imgUrlController.clear();
                });
              },
              child: const Text("Drohne anlegen"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: droneList.length,
                itemBuilder: (context, index) {
                  final drone = droneList[index];
                  return ListTile(
                    title: Text(drone?.name ?? ''),
                    subtitle: Text("Price: ${drone?.price}"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
