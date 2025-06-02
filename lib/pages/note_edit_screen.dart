import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app_assignment/controllers/note_controller.dart';
import 'package:notes_app_assignment/models/note.dart';

class NoteEditScreen extends StatelessWidget {
  NoteEditScreen({super.key});

  final controller = Get.find<NoteController>();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final note = Get.arguments as Note?;
    if (note != null) {
      _titleController.text = note.title;
      _contentController.text = note.content;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(note == null ? 'New Note' : 'Edit Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (note == null) {
                  controller.addNote(
                      _titleController.text, _contentController.text);
                } else {
                  controller.updateNote(Note(
                    id: note.id,
                    title: _titleController.text,
                    content: _contentController.text,
                    createdAt: note.createdAt,
                    updatedAt: DateTime.now(),
                  ));
                }
                Get.back();
                Get.snackbar(
                    'Success', 'Note ${note == null ? 'created' : 'updated'}.');
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                    labelText: 'Title', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Enter a title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    hintText: 'Content',
                    border: OutlineInputBorder()),
                maxLines: 10,
                validator: (value) => value!.isEmpty ? 'Enter content' : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
