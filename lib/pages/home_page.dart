import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app_assignment/controllers/note_controller.dart';

class HomeScreen extends GetView<NoteController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notes',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => controller.sortBy.value = value,
            itemBuilder: (_) => [
              const PopupMenuItem(
                  value: 'updatedAt', child: Text('Sort by Date')),
              const PopupMenuItem(value: 'title', child: Text('Sort by Title')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search notes...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => controller.searchQuery.value = value,
            ),
          ),
          Expanded(
            child: Obx(() => ListView.builder(
                  itemCount: controller.notes.length,
                  itemBuilder: (_, index) {
                    final note = controller.notes[index];
                    return Dismissible(
                      key: Key(note.id.toString()),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (_) => Get.dialog<bool>(
                        AlertDialog(
                          title: const Text('Delete Note'),
                          content: const Text('Are you sure?'),
                          actions: [
                            TextButton(
                                onPressed: () => Get.back(result: false),
                                child: const Text('Cancel')),
                            TextButton(
                                onPressed: () => Get.back(result: true),
                                child: const Text('Delete')),
                          ],
                        ),
                      ),
                      onDismissed: (_) {
                        controller.deleteNote(note.id!);
                        Get.snackbar('Deleted', 'Note removed.');
                      },
                      child: ListTile(
                        title: Text(note.title),
                        subtitle: Text(
                          '${note.content.substring(0, note.content.length > 50 ? 50 : note.content.length)}...\n${controller.formatDate(note.updatedAt)}',
                        ),
                        onTap: () => Get.toNamed('/edit', arguments: note),
                      ),
                    );
                  },
                )),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/edit'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
