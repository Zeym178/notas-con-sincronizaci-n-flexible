import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notesapp/pages/profile_page.dart';
import 'package:notesapp/services/firedatabase.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Firedatabase firedatabase = Firedatabase();
  final _noteController = TextEditingController();

  void addNote() {
    firedatabase.addNote(_noteController.text);
    _noteController.clear();
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

  Expanded _notes() {
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
      title: Text('Notes'),
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
          onPressed: FirebaseAuth.instance.signOut,
          child: Icon(
            Icons.exit_to_app,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
