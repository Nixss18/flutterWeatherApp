import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQFLite {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initDb();
      return _db;
    } else {
      return _db;
    }
  }

  initDb() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'favoriteCity.db');
    Database cityDB = await openDatabase(path, onCreate: _onCreate);
    return cityDB;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE favoriteCities (id INTEGER PRIMARY KEY, cityName TEXT, lat DOUBLE, lon DOUBLE)');
  }

  //to be continued
}
