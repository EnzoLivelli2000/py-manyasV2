import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:manyas_v2/Comment/model/model_comment.dart';
import 'package:manyas_v2/Comment/ui/widgets/other_comments_widget.dart';
import 'package:manyas_v2/Party/model/party_model.dart';
import 'package:manyas_v2/Party/ui/widgets/party_design.dart';
import 'package:manyas_v2/Party/ui/widgets/party_friend_design.dart';
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

  Future<bool> updateLikeData(String COLLECTION, String pUid, bool isLiked, String uID) => _cloudFirestoreAPI.updateLikeData(COLLECTION, pUid, isLiked, uID);

  Future<bool> ColorLikeButton(String COLLECTION, String pUid, String uID) =>_cloudFirestoreAPI.ColorLikeButton(COLLECTION, pUid, uID);

  Future<int> LengthLikes(String COLLECTION, String pUid) => _cloudFirestoreAPI.LengthLikes(COLLECTION, pUid);

  Future<bool> SALVADORALIST(String uID, UserModel userModel) => _cloudFirestoreAPI.SALVADORALIST(uID, userModel);

  Future<bool> ColorFollowButton(String CurrentUId, UserModel userModel) async => _cloudFirestoreAPI.ColorFollowButton(CurrentUId, userModel);


  /*PARTIES*********************************************************************************************************************************************************************************/

  Future<void> updatePartyData(PartyModel party, var partyNumber, GeoPoint target) => _cloudFirestoreAPI.updatePartyData(party, partyNumber, target);

  List<PartyDesign> buildMyParties(List<DocumentSnapshot> placesListSnapshot,
      UserModel userModel) => _cloudFirestoreAPI.buildMyParties(placesListSnapshot, userModel);

  Future<void> deleteParty(PartyModel partyModel) => _cloudFirestoreAPI.deleteParty(partyModel);

  Future<List<PartyFriendDesign>> buildParties(
      List<DocumentReference> myfriendsList, UserModel userModel) => _cloudFirestoreAPI.buildParties(myfriendsList, userModel);

  List<PartyFriendDesign> buildMyFriendParties(
      List<DocumentSnapshot> postListSnapshot, UserModel userModel) => _cloudFirestoreAPI.buildMyFriendParties(postListSnapshot, userModel);


/*COMMENT*********************************************************************************************************************************************************************************/

  Future<void> sendComment(CommentModel comment, String type_post, String postID) => _cloudFirestoreAPI.sendComment(comment, type_post, postID);

  Future<int> commentLength(PartyModel party) => _cloudFirestoreAPI.commentLength(party);

  Future<void> deleteComments(String postID) => _cloudFirestoreAPI.deleteComments(postID);

  Future<List<OtherCommentWidget>> buildComments(PartyModel partyModel, UserModel userModel) => _cloudFirestoreAPI.buildComments(partyModel, userModel);
}