import 'package:hive/hive.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/history.dart';

class HistoryRepository {
  Box<History>? _historyBox;

  // Initialize the repository by opening the history box
  Future<void> init() async {
    _historyBox = await Hive.openBox<History>('history');
  }

  // Method to add a new history record
  Future<void> addHistory(History history) async {
    try {
      if (_historyBox == null) {
        throw Exception("History box has not been initialized.");
      }
      await _historyBox!.add(history);
    } catch (e) {
      throw Exception('Failed to add history: $e');
    }
  }

  // Fetch all history records
  List<History> getAllHistory() {
    if (_historyBox == null) {
      throw Exception("History box has not been initialized.");
    }
    return _historyBox!.values.toList();
  }

  // Close the history box when done
  Future<void> close() async {
    await _historyBox?.close();
  }

  History? getHistoryForOrdAndDate(String ordId, DateTime date) {
    if (_historyBox == null) return null;
    return _historyBox!.values.firstWhere(
      (history) => history.ordId == ordId && isSameDay(history.date, date),
      orElse:
          () => History(
            ordId: '',
            date: DateTime(1970, 1, 1),
            medicationId: '',
            time: '',
            status: '',
          ), // Provide a default History object
    );
  }
}
