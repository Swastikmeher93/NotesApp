import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:notes_app_assignment/models/note.dart';

class DatabaseService extends GetxService {
  Database? _database;

  Future<DatabaseService> init() async {
    await _initDatabase();
    return this;
  }

  Future<void> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'notes.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            content TEXT NOT NULL,
            createdAt TEXT NOT NULL,
            updatedAt TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> insertNote(Note note) async {
    await _database?.insert('notes', note.toMap());
  }

  Future<List<Note>> getAllNotes() async {
    final List<Map<String, dynamic>> maps =
        await _database?.query('notes') ?? [];
    return List.generate(maps.length, (i) => Note.fromMap(maps[i]));
  }

  Future<void> updateNote(Note note) async {
    await _database?.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<void> deleteNote(int id) async {
    await _database?.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
