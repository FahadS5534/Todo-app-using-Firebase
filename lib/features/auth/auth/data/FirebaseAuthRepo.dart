import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/features/auth/auth/domain/AppUser.dart';

class Firebaseauthrepo {
  final auth = FirebaseAuth.instance;
  final firebase = FirebaseFirestore.instance;
  Future<AppUser?> loginUser(String email, String password) async {
    UserCredential userCredential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    return AppUser("", email, userCredential.user!.uid);
  }

  Future<AppUser?> signUpUser(
      String name, String email, String password) async {
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);

    await firebase.collection('users').doc(userCredential.user!.uid).set({
      'name': name,
      'email': email,
      'uid': userCredential.user!.uid,
    });

    return AppUser(name, email, userCredential.user!.uid);
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<bool> isLoggedIn() async {
    User? user = auth.currentUser;
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<AppUser?> getCurrentUser() async {
    User? user = auth.currentUser;
    if (user != null) {
      return AppUser("", user.email!, user.uid);
    } else {
      return null;
    }
  }
}
