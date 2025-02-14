import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:notesapp/auth/auth.dart';
import 'package:notesapp/auth/auth_helper.dart';
import 'package:notesapp/pages/profile_page.dart';
import 'package:notesapp/services/firedatabase.dart';
import 'package:notesapp/services/hivedatabase.dart';

class HomePage extends StatefulWidget {
  final bool isGuest;
  const HomePage({super.key, this.isGuest = false});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Firedatabase firedatabase = Firedatabase();
  final Hivedatabase hivedatabase = Hivedatabase();
  final _noteController = TextEditingController();

  final Box _notesBox = Hive.box('notes');

  void addNote() {
    addNote1({'content': _noteController.text});

    _noteController.clear();
  }

  // FALTA AGREGAR CRUD WITH HIVE !!!f slkajflks

  Future<void> addNote1(Map<String, dynamic> content) async {
    // Map<String, dynamic> note = {
    //   // 'id': DateTime.now().millisecondsSinceEpoch.toString(), // Unique ID
    //   'content': content,
    //   // 'timestamp': DateTime.now(),
    // };
    await _notesBox.add(content['content']);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Column(
        children: [
          // notes
          _notes(),
        ],
      ),
      floatingActionButton: _floatingActionButton(context),
    );
  }

  Widget _notes() {
    if (!widget.isGuest) {
      return _firebaseNoteStream();
    } else {
      return StreamBuilder(
        stream: hivedatabase.getNotesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final localnotes = snapshot.data!;
            return ListView.builder(
              itemCount: localnotes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(localnotes[index]['content']),
                );
              },
            );
          } else {
            return Center(
              child: Text('No Data found!'),
            );
          }
        },
      );
    }
  }

  Expanded _firebaseNoteStream() {
    return Expanded(
      child: StreamBuilder(
        stream: firedatabase.getNotesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final usernotes = snapshot.data!.docs;
            return ListView.builder(
              itemCount: usernotes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(usernotes[index]['note']),
                );
              },
            );
          } else {
            return Center(
              child: Text('No Data Found'),
            );
          }
        },
      ),
    );
  }

  FloatingActionButton _floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return SingleChildScrollView(
              child: AlertDialog(
                title: Text('Add Note'),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _noteController.clear();
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          addNote();
                          Navigator.of(context).pop();
                        },
                        child: Text('Add'),
                      ),
                    ],
                  ),
                ],
                content: Container(
                  child: Column(
                    children: [
                      Container(
                        child: TextField(
                          controller: _noteController,
                          maxLines: null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      backgroundColor: Colors.grey[700],
      child: Icon(Icons.add),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      elevation: 1,
      title: Text(
        'Notes\n' + (widget.isGuest ? 'Local' : 'Firebase'),
        textAlign: TextAlign.center,
      ),
      centerTitle: true,
      leading: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProfilePage(),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(10),
          child: SvgPicture.asset(
            'assets/icons/lolsvg.svg',
            color: Colors.white,
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (widget.isGuest) {
              AuthHelper.setGuestMode(false);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => AuthPage(),
                ),
              );
            } else {
              FirebaseAuth.instance.signOut();
            }
          },
          child: Icon(
            Icons.exit_to_app,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
