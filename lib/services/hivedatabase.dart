import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

class Hivedatabase {
  final Box _notesBox = Hive.box('notes');
  final _notesStreamController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  Future addNote(String title, String content, bool isSync) async {
    await _notesBox.add(
      {
        'title': title,
        'content': content,
        'isSync': isSync,
        'timestamp': Timestamp.now().toString(),
      },
    );
    emitNotes();
  }

  void emitNotes() {
    final notes = _notesBox.values.toList().cast<Map<String, dynamic>>();
    _notesStreamController.add(notes);
  }

  Stream<List<Map<String, dynamic>>> getNoteStream() {
    emitNotes();
    return _notesStreamController.stream;
  }

  Future<void> clear() async {
    await _notesBox.clear();
    emitNotes();
  }

  void dispose() {
    _notesStreamController.close();
  }
}
