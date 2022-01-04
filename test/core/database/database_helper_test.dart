import 'package:flutter_test/flutter_test.dart';
import 'package:food_diary/core/database/database_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  group('database helper', () {
    test('should get the DatabaseHelper singleton', () async {
      // arrange
      DatabaseHelper databaseHelper = DatabaseHelper();
      // assert
      expect(databaseHelper, DatabaseHelper());
    });
  });
}
