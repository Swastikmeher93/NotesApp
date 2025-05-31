import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  final String _notesTableName = "notes";
  final String _notesIdColumnName = "id";
  final String _notesTitleColumnName = "title";
  final String _notesContentColmnName = "content";

  DatabaseService._constructor();

  Future<Database> get database async {
      if (_db != null) return _db!;
      _db = await getDatabase();
      return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "master_db.db");
    final database = await openDatabase(
      databasePath,
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE $_notesTableName(
        $_notesIdColumnName INTEGER PRIMARY KEY,
        $_notesTitleColumnName TEXT NOT NULL,
        $_notesContentColmnName TEXT NOT NULL,
        )''');
      }
    );
    return database;
  }
  
}