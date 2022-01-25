import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static const String _databaseName = 'food_diary';
  static const int _databaseVersion = 1;

  static const String idColumn = 'id';

  static const String mealTableName = 'meals';
  static const String mealDateTimeColumn = 'date_time';
  static const String mealFoodsColumn = 'foods';

  static const String foodTableName = 'foods';
  static const String foodNameColumn = 'name';
  static const String foodAmountColumn = 'amount';
  static const String foodMealIdColumn = 'meal_id';

  static const String symptomsTableName = 'symptoms';
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
    Database db = await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
    await db.execute('PRAGMA foreign_keys = ON');
    return db;
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE $mealTableName (
          $idColumn INTEGER PRIMARY KEY AUTOINCREMENT, 
          $mealDateTimeColumn INTEGER NOT NULL
          )''');
    await db.execute('''CREATE TABLE $foodTableName (
          $idColumn INTEGER PRIMARY KEY AUTOINCREMENT, 
          $foodNameColumn TEXT NOT NULL, 
          $foodAmountColumn INTEGER NOT NULL,
          $foodMealIdColumn INTEGER NOT NULL,
          FOREIGN KEY ($foodMealIdColumn) REFERENCES $mealTableName ($idColumn)                  
           ON DELETE CASCADE ON UPDATE CASCADE)''');

    await db.execute('''CREATE TABLE $symptomsTableName (
          $idColumn INTEGER PRIMARY KEY AUTOINCREMENT, 
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

class DatabaseHelper2 {
  static Database? _database;
  static const String _databaseName = 'food_diary';
  static const int _databaseVersion = 1;

  static const String idColumn = 'id';

  static const String mealTableName = 'meals';
  static const String mealDateTimeColumn = 'date_time';
  static const String mealFoodsColumn = 'foods';

  static const String foodTableName = 'foods';
  static const String foodNameColumn = 'name';
  static const String foodAmountColumn = 'amount';
  static const String foodMealIdColumn = 'meal_id';

  static const String symptomsTableName = 'symptoms';
  static const String symptomsDateTimeColumn = 'date_time';
  static const String symptomsSymptomColumn = 'symptom';

  DatabaseHelper2._internal();
  static final DatabaseHelper2 _instance = DatabaseHelper2._internal();
  factory DatabaseHelper2() {
    return _instance;
  }

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    String path =
        join((await getApplicationSupportDirectory()).path, _databaseName);
    Database db = await openDatabase(path, version: _databaseVersion);
    await db.execute('PRAGMA foreign_keys = ON');
    return db;
  }

  Future deleteDB() async {
    Database? db = await database;
    String path = db.path;
    await db.close();
    _database = null;
    return deleteDatabase(path);
  }
}
