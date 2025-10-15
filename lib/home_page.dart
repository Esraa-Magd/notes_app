import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shake/shake.dart';
import 'note.dart';
import 'note_database.dart';
import 'main.dart';
import 'add_note_page.dart';
import 'update_delete_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ShakeDetector detector;

  @override
  void initState() {
    super.initState();
    detector = ShakeDetector.autoStart(
      onPhoneShake: () async {
        await database.noteDao.deleteAllNotes();
        setState(() {});
        Get.snackbar(
          "Deleted!",
          "All notes have been deleted.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      },
    );
  }

  @override
  void dispose() {
    detector.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Notes",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Note>>(
        stream: database.noteDao.getAllNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final notes = snapshot.data ?? [];

          if (notes.isEmpty) {
            return const Center(
              child: Text(
                "No notes yet",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: ListTile(
                  title: Text(
                    note.text,
                    style: const TextStyle(fontSize: 18),
                  ),
                  subtitle: Text(note.location ?? "No location"),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Get.to(() => UpdateDeletePage(note: note));
                  },

                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddNotePage());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
