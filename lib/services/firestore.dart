import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final CollectionReference userInfo =
      FirebaseFirestore.instance.collection('users');

  final User? currentUser = FirebaseAuth.instance.currentUser;

  Future createUser(
      String userName, String email, String password1, String password2) async {
    if (ifPasswordsEqual(password1, password2)) {
      UserCredential? userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password1,
      );

      if (userCredential.user != null) {
        await userInfo.doc(userCredential.user!.email).set({
          'username': userName,
          'email': email,
        });
      }
    }
  }

  Future getUserInfo() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.email)
        .get();
  }

  bool ifPasswordsEqual(String a, String b) {
    if (a == b) {
      return true;
    } else {
      return false;
    }
  }
}
