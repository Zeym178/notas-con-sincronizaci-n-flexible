import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notesapp/services/firedatabase.dart';
import 'package:notesapp/services/hivedatabase.dart';

class NotePage extends StatefulWidget {
  final Map<String, dynamic> note;
  final bool isGuest;
  final Firedatabase firedatabase;
  final Hivedatabase hivedatabase;
  const NotePage(
      {super.key,
      required this.firedatabase,
      required this.hivedatabase,
      required this.isGuest,
      required this.note});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late Map<String, dynamic> note;
  late var note_id;
  late String note_title;
  late String note_content;
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  void addNote() {
    if (widget.isGuest) {
      widget.hivedatabase.addNote(
        _titleController.text,
        _contentController.text,
        false,
      );
    } else {
      widget.firedatabase.addNote(
        _titleController.text,
        _contentController.text,
      );
    }
    _contentController.clear();
    _titleController.clear();
  }

  void updateNote() {
    if (widget.isGuest) {
      widget.hivedatabase.updateNote(
        note_id,
        note_title,
        note_content,
      );
    } else {
      widget.firedatabase.updateNote(
        note_id,
        note_title,
        note_content,
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _contentController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    note = widget.note;
    note_id = note['id'];
    note_title = note['title'];
    note_content = note['content'];
    _titleController = TextEditingController(text: note_title);
    _contentController = TextEditingController(text: note_content);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Note'),
        actions: [
          GestureDetector(
            onTap: () {
              if (note_id.toString().isEmpty) {
                addNote();
              } else {
                updateNote();
              }
              Navigator.pop(context);
            },
            child: Container(
              margin: EdgeInsets.only(right: 20),
              child: Icon(
                Icons.check,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                // Title
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'Title',
                    ),
                    onChanged: (value) {
                      note_title = value;
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                // note
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _contentController,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: '...',
                    ),
                    onChanged: (value) {
                      note_content = value;
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                _optionIcon()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _optionIcon() {
    if (note_title.isEmpty) {
      return Container(
        height: 80,
        width: 80,
        color: Colors.blue,
      );
    } else {
      return Container(
        height: 80,
        width: 80,
        color: Colors.red,
      );
    }
  }
}
