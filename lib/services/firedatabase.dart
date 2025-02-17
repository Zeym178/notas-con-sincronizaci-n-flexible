import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Firedatabase {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  Future addNote(String title, String note) async {
    return await users.doc(currentUser!.email).collection('notes').add({
      'user': currentUser!.email,
      'content': note,
      'title': title,
      'TimeStamp': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getNotesStream() {
    final notesStream = users
        .doc(currentUser!.email)
        .collection('notes')
        .orderBy('TimeStamp', descending: true)
        .snapshots();
    return notesStream;
  }

  Future<void> updateNote(var id, String title, String content) async {
    return await users
        .doc(currentUser!.email)
        .collection('notes')
        .doc(id)
        .update(
      {
        'title': title,
        'content': content,
        'TimeStamp': Timestamp.now(),
      },
    );
  }

  Future<void> deleteNote(var id) async {
    return await users
        .doc(currentUser!.email)
        .collection('notes')
        .doc(id)
        .delete();
  }
}
