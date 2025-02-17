import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:notesapp/auth/auth.dart';
import 'package:notesapp/auth/auth_helper.dart';
import 'package:notesapp/pages/note_page.dart';
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

  void deleteNote(var id) {
    if (widget.isGuest) {
      hivedatabase.deleteNote(id);
    } else {
      firedatabase.deleteNote(id);
    }
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
      return Expanded(
        child: StreamBuilder(
          initialData: hivedatabase.getInitialNotes(),
          stream: hivedatabase.getNoteStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final items = snapshot.data!;
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  String title = items[index]['title'];
                  String content = items[index]['content'];
                  var note_id = index;
                  return _noteWidget(note_id, title, content, index);
                },
              );
            } else {
              return Text('nose');
            }
          },
        ),
      );
    }
  }

  GestureDetector _noteWidget(var id, String title, String content, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => NotePage(
              firedatabase: firedatabase,
              hivedatabase: hivedatabase,
              isGuest: widget.isGuest,
              note: {
                'id': id,
                'title': title,
                'content': content,
              },
            ),
          ),
        );
      },
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  deleteNote(id);
                  Navigator.pop(context);
                },
                child: Container(
                  color: Colors.red,
                  height: 50,
                  child: Center(
                    child: Icon(Icons.delete),
                  ),
                ),
              ),
            );
          },
        );
      },
      child: Container(
        height: 80,
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 5,
                left: 10,
                right: 20,
              ),
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(
              thickness: 1,
              color: Colors.white.withOpacity(0.5),
              indent: 10,
              endIndent: 10,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: 5,
                  left: 10,
                  right: 20,
                ),
                child: Text(content),
              ),
            ),
          ],
        ),
      ),
    );
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
                String title = usernotes[index]['title'];
                String content = usernotes[index]['content'];
                var note_id = usernotes[index].id;
                return _noteWidget(note_id, title, content, index);
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
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => NotePage(
              firedatabase: firedatabase,
              hivedatabase: hivedatabase,
              isGuest: widget.isGuest,
              note: {
                'id': '',
                'title': '',
                'content': '',
              },
            ),
          ),
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
        ElevatedButton(
          onPressed: () async {
            await hivedatabase.clear();
          },
          child: Icon(Icons.cancel),
        ),
      ],
    );
  }
}
