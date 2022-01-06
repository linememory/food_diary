import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static const String _databaseName = 'food_diary';
  static const int _databaseVersion = 1;

  static const String mealTableName = 'meals';
  static const String symptomsTableName = 'symptoms';

  static const String mealIdColumn = '_id';
  static const String mealDateTimeColumn = 'date_time';
  static const String mealFoodsColumn = 'foods';

  static const String symptomsIdColumn = '_id';
  static const String symptomsDateTimeColumn = 'date_time';
  static const String symptomsSymptomColumn = 'symptom';

  DatabaseHelper._internal();
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    String path =
        join((await getApplicationSupportDirectory()).path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE $mealTableName (
          $mealIdColumn INTEGER PRIMARY KEY AUTOINCREMENT, 
          $mealDateTimeColumn INTEGER NOT NULL, 
          $mealFoodsColumn TEXT NOT NULL
          )''');
    await db.execute('''CREATE TABLE $symptomsTableName (
          $symptomsIdColumn INTEGER PRIMARY KEY AUTOINCREMENT, 
          $symptomsDateTimeColumn INTEGER NOT NULL, 
          $symptomsSymptomColumn TEXT NOT NULL)''');
  }

  Future deleteDB() async {
    Database? db = await database;
    String path = db.path;
    await db.close();
    _database = null;
    return deleteDatabase(path);
  }
}
