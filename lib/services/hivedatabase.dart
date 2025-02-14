import 'package:hive/hive.dart';

class Hivedatabase {
  final Box _notesBox = Hive.box('notes');

  Future addNote(String content) async {
    // Map<String, dynamic> note = {
    //   // 'id': DateTime.now().millisecondsSinceEpoch.toString(), // Unique ID
    //   'content': content,
    //   // 'timestamp': DateTime.now(),
    // };
    return await _notesBox.add({'content': content});
  }

  List<Map<String, dynamic>> getNotes() {
    final data = _notesBox.keys.map(
      (key) {
        final item = _notesBox.get(key);
        return {
          'content': item['content'],
        };
      },
    ).toList();
    return data.reversed.toList();
  }

  Stream<List<Map<String, dynamic>>> getNotesStream() {
    return _notesBox.watch().map((_) => getNotes());
  }
}
