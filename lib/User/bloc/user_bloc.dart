import 'dart:io';
import 'dart:async';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:manyas_v2/Post/model/post_model.dart';
import 'package:manyas_v2/Post/repository/firebase_storage_repository.dart';
import 'package:manyas_v2/Post/ui/widgets/post_design.dart';
import 'package:manyas_v2/User/model/user_model.dart';
import 'package:manyas_v2/User/repository/auth_repository.dart';
import 'package:manyas_v2/User/repository/cloud_firebase_api.dart';
import 'package:manyas_v2/User/repository/cloud_firebase_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserBloc implements Bloc{

  final _auth_repository = AuthRepository();
  Stream<User> streamFirebase = FirebaseAuth.instance.authStateChanges();
  Stream<User> get authStatus => streamFirebase;

  //Caso 1 Sign In a la aplicacion con Google
  Future<UserCredential> signIn(){
    return _auth_repository.signInFirebase();
  }

  Future<UserCredential> signInEmailPassword(String _email, String _password) => _auth_repository.signInEmailPassword( _email, _password);
  signInWithGoogle() => _auth_repository.signInWithGoogle();

  //Case 2. Hacer Sign out
  signOut() {
    _auth_repository.signOut();
  }

  //Case 3. Devuelve el usuario actual
  Future<User> currentUser() async {
    User user = FirebaseAuth.instance.currentUser;
    return user;
  }

  //Case 4. Registrar usuario en base de datos
  final _cloudFirestoreRepository = CloudFirestoreRepository();
  //Case 4.1 Actualizar la información del usuario
  void updateUserData(UserModel user) => _cloudFirestoreRepository.updateUserDataFirestore(user);

  //Case 5. Registrar datos multimedia del usuario a Firebase Storage
  final _firebaseStorageRepository = FirebaseStorageRepository();
  Future<StorageUploadTask> uploadFile(String path, File image) => _firebaseStorageRepository.uploadFile(path, image);

  //Case 6. Subir los datos del Post a Firebase CloudFirestore
  Future<void> updatePostData(PostModel post) => _cloudFirestoreRepository.updatePostData(post);

  //Case 7. Borrar los datos de Post en Firebase CloudFirestore
  Future<void> deletePost(PostModel post) => _cloudFirestoreRepository.deletePost(post);

  //Case 7. Transmitir el estado del la lista de Post
  Stream<QuerySnapshot> myPostsListStream(String uid) =>
      Firestore.instance.collection(CloudFirestoreAPI().POSTS)
          .where("userOwner", isEqualTo: Firestore.instance.document("${CloudFirestoreAPI().USERS}/${uid}"))
          .snapshots();
  //Case 7.1. Construcción de los Post
  List<PostDesign> buildMyPosts(List<DocumentSnapshot> placesListSnapshot, UserModel userModel) => _cloudFirestoreRepository.buildMyPosts(placesListSnapshot, userModel);
  @override
  void dispose() {
    // TODO: implement dispose
  }
}