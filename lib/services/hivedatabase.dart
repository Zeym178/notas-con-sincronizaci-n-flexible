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

  Future<void> updateNote(var id, String title, String content) async {
    await _notesBox.putAt(
      id,
      {
        'title': title,
        'content': content,
        'timestamp': Timestamp.now().toString(),
      },
    );
    emitNotes();
  }

  Future<void> deleteNote(var id) async {
    await _notesBox.deleteAt(id);
    emitNotes();
  }

  void emitNotes() {
    final notes = _notesBox.values
        .map<Map<String, dynamic>>(
          (e) => Map<String, dynamic>.from(e),
        )
        .toList();
    _notesStreamController.add(notes);
  }

  Stream<List<Map<String, dynamic>>> getNoteStream() {
    emitNotes();
    return _notesStreamController.stream;
  }

  List<Map<String, dynamic>> getInitialNotes() {
    return _notesBox.values
        .map<Map<String, dynamic>>(
          (e) => Map<String, dynamic>.from(e),
        )
        .toList();
  }

  Future<void> clear() async {
    await _notesBox.clear();
    emitNotes();
  }

  void dispose() {
    _notesStreamController.close();
  }
}
