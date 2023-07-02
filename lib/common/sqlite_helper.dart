import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:u_philosophy/model/note.dart';

class SQLiteHelper {
  static Database? _database;
  static get getDatabase async {
    if (_database != null) return _database;
    _database = await initDataBase();
    return _database;
  }

  static Future<Database> initDataBase() async {
    String path = p.join(await getDatabasesPath(), 'note_database.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  static Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE notes (
      id INTEGER PRIMARY KEY,
      date TEXT,
      title TEXT,
      content TEXT
    )
    ''');
  }

  static Future insertNote(Note note) async {
    Database db = await getDatabase;

    await db.insert('notes', note.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Note>> loadNotes() async {
    Database db = await getDatabase;

    List<Map> maps = await db.query('notes');
    return List.generate(
        maps.length,
        (index) => Note(
            id: maps[index]['id'],
            date: maps[index]['date'],
            title: maps[index]['title'],
            content: maps[index]['content']));
  }

  static Future updateNote(Note newNote) async {
    Database db = await getDatabase;

    await db.update('notes', newNote.toJson(),
        where: "id=?", whereArgs: [newNote.id]);
  }
}
