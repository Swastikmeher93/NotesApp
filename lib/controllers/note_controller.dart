import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notes_app_assignment/models/note.dart';
import 'package:notes_app_assignment/service/database_helper.dart';

class NoteController extends GetxController {
  final db = Get.find<DatabaseService>();
  final RxList<Note> notes = <Note>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString sortBy = 'updatedAt'.obs;
  final RxBool sortAscending = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotes();
    ever(searchQuery, (_) => loadNotes());
    ever(sortBy, (_) => loadNotes());
    ever(sortAscending, (_) => loadNotes());
  }

  Future<void> loadNotes() async {
    var allNotes = await db.getAllNotes();
    allNotes = allNotes
        .where((note) =>
            note.title
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase()) ||
            note.content
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase()))
        .toList();
    allNotes.sort((a, b) {
      final int result = sortBy.value == 'title'
          ? a.title.compareTo(b.title)
          : a.updatedAt.compareTo(b.updatedAt);
      return sortAscending.value ? result : -result;
    });
    notes.assignAll(allNotes);
  }

  Future<void> addNote(String title, String content) async {
    final now = DateTime.now();
    await db.insertNote(
        Note(title: title, content: content, createdAt: now, updatedAt: now));
    await loadNotes();
  }

  Future<void> updateNote(Note note) async {
    await db.updateNote(Note(
      id: note.id,
      title: note.title,
      content: note.content,
      createdAt: note.createdAt,
      updatedAt: DateTime.now(),
    ));
    await loadNotes();
  }

  Future<void> deleteNote(int id) async {
    await db.deleteNote(id);
    await loadNotes();
  }

  String formatDate(DateTime date) =>
      DateFormat('MMM dd, yyyy HH:mm').format(date);
}
