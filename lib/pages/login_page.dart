import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notesapp/auth/auth.dart';
import 'package:notesapp/auth/auth_helper.dart';
import 'package:notesapp/auth/main_page.dart';
import 'package:notesapp/pages/home_page.dart';
import 'package:notesapp/services/firestore.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginPage({super.key, required this.showRegisterPage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirestoreService firestoreService = FirestoreService();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void SignIn() {
    FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MainPage(),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: Container(
                  // color: Colors.red,
                  margin: EdgeInsets.only(top: 40),
                  height: 150,
                  child: SvgPicture.asset(
                    'assets/icons/lolsvg.svg',
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 40),
              Text(
                'Sign In',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
              SizedBox(height: 20),

              // Email Textfield
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      spreadRadius: 0,
                      color: Colors.grey.withOpacity(0.11),
                    )
                  ],
                ),
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _emailController,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Email',
                    fillColor: Colors.grey[600],
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),

              // Password Textfield
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      spreadRadius: 0,
                      color: Colors.grey.withOpacity(0.11),
                    )
                  ],
                ),
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _passwordController,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    fillColor: Colors.grey[600],
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // Sign In button

              GestureDetector(
                onTap: SignIn,
                child: Container(
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade300,
                  ),
                  child: Center(
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 40,
              ),

              // Sign Up

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Reset Password',
                    style: TextStyle(
                      color: Colors.blue.shade100,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 20,
              ),

              GestureDetector(
                onTap: widget.showRegisterPage,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Register Now',
                      style: TextStyle(
                        color: Colors.blue.shade100,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 30,
              ),

              GestureDetector(
                onTap: () {
                  AuthHelper.setGuestMode(true);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => MainPage(),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Continue as a Guest',
                        style: TextStyle(
                          color: Colors.blue.shade100,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
