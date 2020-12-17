import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:manyas_v2/Post/model/post_model.dart';
import 'package:manyas_v2/Post/ui/widgets/post_design.dart';
import 'package:manyas_v2/User/model/user_model.dart';
import 'package:manyas_v2/User/repository/cloud_firebase_api.dart';

class CloudFirestoreRepository {
  final _cloudFirestoreAPI = CloudFirestoreAPI();

  void updateUserDataFirestore(UserModel user) =>
      _cloudFirestoreAPI.updateUserData(user);

  Future<void> updatePostData(PostModel post) => _cloudFirestoreAPI.updatePostData(post);

  Future<void> deletePost(PostModel post) => _cloudFirestoreAPI.deletePost(post);

  List<PostDesign> buildMyPosts(List<DocumentSnapshot> placesListSnapshot, UserModel userModel) => _cloudFirestoreAPI.buildMyPosts(placesListSnapshot, userModel);
}