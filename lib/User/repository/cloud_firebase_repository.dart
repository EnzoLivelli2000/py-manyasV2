import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:manyas_v2/Post/model/post_model.dart';
import 'package:manyas_v2/Post/ui/widgets/post_design.dart';
import 'package:manyas_v2/Post/ui/widgets/post_friend_design.dart';
import 'package:manyas_v2/User/model/user_model.dart';
import 'package:manyas_v2/User/repository/cloud_firebase_api.dart';
import 'package:manyas_v2/User/ui/widgets/search_people_widget.dart';

class CloudFirestoreRepository {
  final _cloudFirestoreAPI = CloudFirestoreAPI();

  void updateUserDataFirestore(UserModel user) =>
      _cloudFirestoreAPI.updateUserData(user);

  Future<void> updatePostData(PostModel post) => _cloudFirestoreAPI.updatePostData(post);

  Future<void> deletePost(PostModel post) => _cloudFirestoreAPI.deletePost(post);

  List<PostDesign> buildMyPosts(List<DocumentSnapshot> placesListSnapshot, UserModel userModel) => _cloudFirestoreAPI.buildMyPosts(placesListSnapshot, userModel);

  List<PostFriendDesign> buildMyFriendPosts(List<DocumentSnapshot> placesListSnapshot, UserModel userModel) => _cloudFirestoreAPI.buildMyFriendPosts(placesListSnapshot, userModel);

  List<SearchPeopleWidget> filterAllUsers(List<DocumentSnapshot> peopleListSnapshot, String filterPerson) => _cloudFirestoreAPI.filterAllUsers(peopleListSnapshot, filterPerson);

  Future<void> updateFriendsList(UserModel model) => _cloudFirestoreAPI.updateFriendsList(model);

  Future<void> deleteFriendsList(UserModel model) => _cloudFirestoreAPI.deleteFriendsList(model);

  Future<List<PostFriendDesign>> buildPosts(List<DocumentReference> userSnapshot, UserModel userModel) => _cloudFirestoreAPI.buildPosts(userSnapshot, userModel);

  List<PostFriendDesign> buildPosts1(List<DocumentReference> userSnapshot, UserModel userModel) => _cloudFirestoreAPI.buildPosts1(userSnapshot, userModel);

  Future<bool> updateLikePostData(PostModel post, bool isLiked, String uID) => _cloudFirestoreAPI.updateLikePostData(post, isLiked, uID);

  Future<bool> ColorLikeButton(PostModel post, String uID) =>_cloudFirestoreAPI.ColorLikeButton(post, uID);

  Future<int> LengthLikes(PostModel post) => _cloudFirestoreAPI.LengthLikes(post);
}