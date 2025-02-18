import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:notesapp/auth/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyAqxAwMVX9ZxLbovthwVkl3sYDIn1rRRe0',
        authDomain: 'zeym-s-notes-app.firebaseapp.com',
        appId: '1:455650982872:web:cf646af459194c9d8190ad',
        messagingSenderId: '455650982872',
        projectId: 'zeym-s-notes-app',
        storageBucket: 'zeym-s-notes-app.firebasestorage.app',
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  await Hive.initFlutter();
  await Hive.openBox('notes');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Zeym's Notes App",
      theme: ThemeData.dark(),
      home: MainPage(),
    );
  }
}
