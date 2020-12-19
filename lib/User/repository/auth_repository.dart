import 'package:firebase_auth/firebase_auth.dart';
import 'package:manyas_v2/User/repository/Firebase_auth_api.dart';

class AuthRepository{
  final _firebaseAuthAPI = FirebaseAuthAPI();
  Future<UserCredential> signInFirebase() => _firebaseAuthAPI.signInGoogle();
  signInWithGoogle() => _firebaseAuthAPI.signInWithGoogle();

  Future<UserCredential> signInEmailPassword(String _email, String _password) => _firebaseAuthAPI.signInEmailPassword( _email, _password);


  signOut() => _firebaseAuthAPI.signOut();
}