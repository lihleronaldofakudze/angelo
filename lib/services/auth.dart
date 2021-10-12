import 'package:angelo/models/CurrentUser.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CurrentUser? _userFromFirebase(User? user) {
    return user != null ? CurrentUser(uid: user.uid, email: user.email) : null;
  }

  Stream<CurrentUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  Future? register({required String email, required String password}) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      return _userFromFirebase(user);
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future? login({required String email, required String password}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;
      return _userFromFirebase(user);
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future? logout() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error);
      return null;
    }
  }
}
