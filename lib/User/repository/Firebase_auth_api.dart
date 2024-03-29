import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthAPI {
  static FirebaseAuth _auth = FirebaseAuth.instance; // nos permite acceder a toda las funcionalidades de firebase authentication
  GoogleSignIn googleSignIn = GoogleSignIn();

  Future<UserCredential> signInGoogle() async{
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;

    UserCredential user = await _auth.signInWithCredential(
        GoogleAuthProvider.credential(idToken: gSA.idToken, accessToken: gSA.accessToken));

    return user;
  }

  Future<UserCredential> signInEmailPassword(String _email, String _password) async{
    final UserCredential user = await _auth.createUserWithEmailAndPassword(email: _email, password: _password).catchError((onError) => print('Error al usar la funcion signInEmailPassword ${onError}'));
    return user;
  }

  signInWithGoogle() async { //video de youtube
    GoogleSignIn googleSignIn = GoogleSignIn();
    final acc = await googleSignIn.signIn();
    final auth = await acc.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken
    );
    final res = await _auth.signInWithCredential(credential);
    return res.user;

  }

  signOut() async{
    await _auth.signOut().then((value) {
      googleSignIn.signOut();
      print('Sesión cerrada');
    }).catchError((e) => print('Error al hacer Sign Out-> ${e}'));
  }
}