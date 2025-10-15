import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'note.dart';
import 'main.dart';

class UpdateDeletePage extends StatefulWidget {
  final Note note;
  const UpdateDeletePage({super.key, required this.note});

  @override
  State<UpdateDeletePage> createState() => _UpdateDeletePageState();
}

class _UpdateDeletePageState extends State<UpdateDeletePage> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.note.text);
  }

  Future<void> _updateNote() async {
    final updatedText = _textController.text.trim();
    if (updatedText.isEmpty) {
      Get.snackbar("Error", "Note text cannot be empty");
      return;
    }

    final updatedNote = Note(
      id: widget.note.id,
      text: updatedText,
      location: widget.note.location,
    );

    await database.noteDao.updateNote(updatedNote);
    Get.back();
    Get.snackbar("Updated", "Note updated successfully",
        snackPosition: SnackPosition.BOTTOM);
  }

  Future<void> _deleteNote() async {
    await database.noteDao.deleteNote(widget.note);
    Get.back();
    Get.snackbar("Deleted", "Note deleted successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update or Delete Note"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: "Edit note text",
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            if (widget.note.location != null)
              Text("Location: ${widget.note.location!}",
                  style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _updateNote,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent),
                  child: const Text("Update"),
                ),
                ElevatedButton(
                  onPressed: _deleteNote,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent),
                  child: const Text("Delete"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
