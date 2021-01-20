import 'dart:io';
import 'dart:async';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:manyas_v2/Post/model/post_model.dart';
import 'package:manyas_v2/Post/repository/firebase_storage_repository.dart';
import 'package:manyas_v2/Post/ui/widgets/post_design.dart';
import 'package:manyas_v2/Post/ui/widgets/post_friend_design.dart';
import 'package:manyas_v2/User/model/user_model.dart';
import 'package:manyas_v2/User/repository/auth_repository.dart';
import 'package:manyas_v2/User/repository/cloud_firebase_api.dart';
import 'package:manyas_v2/User/repository/cloud_firebase_repository.dart';
import 'package:manyas_v2/User/ui/widgets/search_people_widget.dart';

class UserBloc implements Bloc {
  final _auth_repository = AuthRepository();
  Stream<User> streamFirebase = FirebaseAuth.instance.authStateChanges();

  Stream<User> get authStatus => streamFirebase;

  //Caso 1 Sign In a la aplicacion con Google
  Future<UserCredential> signIn() {
    return _auth_repository.signInFirebase();
  }

  Future<UserCredential> signInEmailPassword(String _email, String _password) =>
      _auth_repository.signInEmailPassword(_email, _password);

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
  void updateUserData(UserModel user) =>
      _cloudFirestoreRepository.updateUserDataFirestore(user);

  //Case 5. Registrar datos multimedia del usuario a Firebase Storage
  final _firebaseStorageRepository = FirebaseStorageRepository();

  Future<StorageUploadTask> uploadFile(String path, File image) =>
      _firebaseStorageRepository.uploadFile(path, image);

  //Case 6. Subir los datos del Post a Firebase CloudFirestore
  Future<void> updatePostData(PostModel post) =>
      _cloudFirestoreRepository.updatePostData(post);

  //Case 7. Borrar los datos de Post en Firebase CloudFirestore
  Future<void> deletePost(PostModel post) =>
      _cloudFirestoreRepository.deletePost(post);

  //Case 7. Transmitir el estado del la lista de Post
  Stream<QuerySnapshot> myPostsListStream(String uid) => Firestore.instance
      .collection(CloudFirestoreAPI().POSTS)
      .where("userOwner",
          isEqualTo: Firestore.instance
              .document("${CloudFirestoreAPI().USERS}/${uid}"))
      .snapshots();

  //Case 7.1. Construcción de los Post
  List<PostDesign> buildMyPosts(
          List<DocumentSnapshot> placesListSnapshot, UserModel userModel) =>
      _cloudFirestoreRepository.buildMyPosts(placesListSnapshot, userModel);

  //Case 8. Filtrar a los usuarios
  List<SearchPeopleWidget> filterAllUsers(
          List<DocumentSnapshot> peopleListSnapshot, String filterPerson) =>
      _cloudFirestoreRepository.filterAllUsers(
          peopleListSnapshot, filterPerson);

  //Case 8.1. Stream de mis usuarios
  Stream<QuerySnapshot> myUsersListStream() {
    return FirebaseFirestore.instance
        .collection(CloudFirestoreAPI().USERS)
        .snapshots();
  }

  //Case 8.2 Hacer un get de myUserListStream()
  Stream<QuerySnapshot> get peopleStream => myUsersListStream();

  //Case 9 Mostrar los datos del usuario amigo(en esta función se elimina la opción de borrar post)
  List<PostFriendDesign> buildMyFriendPosts(
          List<DocumentSnapshot> placesListSnapshot, UserModel userModel) =>
      _cloudFirestoreRepository.buildMyFriendPosts(
          placesListSnapshot, userModel);

  //Case 10 Añade amigos a la lista de amigos del usuario
  Future<void> updateFriendsList(UserModel model) =>
      _cloudFirestoreRepository.updateFriendsList(model);

  //Case 10.1 Añade amigos a la lista de amigos del usuario
  Future<void> deleteFriendsList(UserModel model) =>
      _cloudFirestoreRepository.deleteFriendsList(model);

  //Case 10.2 Tamaño de la lista de followers
  int lengthFollowersList(UserModel model) =>
      _cloudFirestoreRepository.lengthFollowersList(model);

  //Case10.3 Devuelve el tamaño de followers
  //Future<int> get  getLengthFollowersList => lengthFollowersList(model);

  //11. Stream para poder transmitir solo los usuario amigos
  //Stream<QuerySnapshot> postsListStream = Firestore.instance.collection(CloudFirestoreAPI().POSTS).snapshots();
  Stream<QuerySnapshot> postsListStream() =>
      Firestore.instance.collection(CloudFirestoreAPI().POSTS).snapshots();

  Stream<QuerySnapshot> get postsStream => postsListStream();

  Stream<DocumentSnapshot> myFriendsListStream(String uid) async* {
    DocumentReference userRef =
    FirebaseFirestore.instance.collection('users').doc(uid);
     await userRef.get().then((value) {
       return Firestore.instance.document(value.data()['myFriends']).snapshots();
    });
  }

  Stream <List<DocumentReference>> get myFriendsListStream1 async* {
    DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid);

    final List<DocumentReference> posts = [];
    DocumentSnapshot documentSnapshot = await userRef.get();
    List aux = documentSnapshot.data()['myFriends'];

    for(int i = 0; i < aux.length; i++ ){
       posts.add(aux[i]);

       yield posts;
    }
  }



  Future<List<PostFriendDesign>> buildPosts(
      DocumentReference userSnapshot, UserModel userModel) =>
      _cloudFirestoreRepository.buildPosts(userSnapshot, userModel);

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
