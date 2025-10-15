import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'note.dart';
import 'main.dart';
import 'package:geolocator/geolocator.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final TextEditingController _textController = TextEditingController();
  bool _useLocation = false;
  String? _currentLocation;

  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar("Error", "Location services are disabled.");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar("Error", "Location permission denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar("Error", "Location permission permanently denied.");
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentLocation =
      "Lat: ${position.latitude}, Lon: ${position.longitude}";
    });
  }

  Future<void> _saveNote() async {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      Get.snackbar("Error", "Please enter some text.");
      return;
    }

    String? location;
    if (_useLocation) {
      await _getLocation();
      location = _currentLocation;
    }

    final newNote = Note(text: text, location: location);
    await database.noteDao.insertNote(newNote);

    Get.back();
    Get.snackbar("Saved", "Note added successfully!",
        snackPosition: SnackPosition.BOTTOM);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Note"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: "Write your note here...",
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _useLocation,
                  onChanged: (val) {
                    setState(() {
                      _useLocation = val ?? false;
                    });
                  },
                ),
                const Text("Add location"),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveNote,
              child: const Text("Save Note"),
            )
          ],
        ),
      ),
    );
  }
}
