import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notesapp/auth/auth.dart';
import 'package:notesapp/auth/auth_helper.dart';
import 'package:notesapp/pages/home_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomePage(
            isGuest: false,
          );
        } else {
          return FutureBuilder<bool>(
            future: AuthHelper.isGuestMode(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!) {
                return HomePage(
                  isGuest: true,
                );
              } else {
                return AuthPage();
              }
            },
          );
        }
      },
    );
  }
}
