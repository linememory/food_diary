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
