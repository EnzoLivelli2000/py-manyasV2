import 'package:bloc_provider/bloc_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:manyas_v2/User/model/user_model.dart';
import 'package:manyas_v2/User/repository/auth_repository.dart';

class UserBloc implements Bloc{

  final _auth_repository = AuthRepository();
  Stream<User> streamFirebae = FirebaseAuth.instance.authStateChanges();
  Stream<User> get authStatus => streamFirebae;

  //Caso 1 Sign In a la aplicacion con Google
  Future<UserCredential> signIn(){
    return _auth_repository.signInFirebase();
  }

  //Case 2. Registrar usuario en base de datos
  final _cloudFirestoreRepository = CloudFirestoreRepository();

  void updateUserData(UserModel user) => _cloudFirestoreRepository.updateUserDataFirestore(user);

  @override
  void dispose() {
    // TODO: implement dispose
  }
}