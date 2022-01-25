import 'package:food_diary/features/diary/domain/entities/event.dart';

abstract class EventRepository {
  Future<List<Event>> getAll();
  Future<bool> upsert(Event event);
  Future<bool> delete(int id);
}
