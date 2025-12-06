import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  AuthRepository(this._firebaseAuth, this._googleSignIn);

  //login with email and password
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      await userCredential.user!.reload();
      if (userCredential.user!.emailVerified ||
          userCredential.user!.isAnonymous) {
        User? user = _firebaseAuth.currentUser;
        return user;
      } else {
        return null;
      }
    } catch (error) {
      rethrow;
    }
  }

  //Google Sign in
  Future<User?> googleSignIn() async {
    try {
      await _googleSignIn.initialize(
        clientId:
            '276661864238-ghf97qht93fpk2mk8qhcofe6v1ph9vua.apps.googleusercontent.com',
      );
      GoogleSignInAccount account = await _googleSignIn.authenticate();
      GoogleSignInAuthentication googleUser = account.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleUser.idToken,
      );
      UserCredential userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      User? user = userCredential.user;
      if (user == null) {
        return null;
      }
      return user;
    } catch (e) {
      rethrow;
    }
  }

  //SignOut
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (error) {
      rethrow;
    }
  }

  Future<User?> checkAuthStatus() async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        await user.reload();
        if (user.emailVerified || user.isAnonymous) {
          return user;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> anonymousSignIn() async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInAnonymously();
      await userCredential.user!.reload();
      await userCredential.user!.updateDisplayName('Guest');
      User? user = _firebaseAuth.currentUser;
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPasswordRequested(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> signUpRequested(userName, email, password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user!.sendEmailVerification();
      await userCredential.user!.updateDisplayName(userName);
      await userCredential.user!
          .reload(); // Important: update reflect karne ke liye
      return 'Please check your email inbox or Spam folder to verify your email';
    } catch (e) {
      rethrow;
    }
  }
}
