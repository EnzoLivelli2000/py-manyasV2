import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:manyas_v2/Post/model/post_model.dart';
import 'package:manyas_v2/Post/ui/widgets/post_design.dart';
import 'package:manyas_v2/Post/ui/widgets/post_friend_design.dart';
import 'package:manyas_v2/User/model/user_model.dart';
import 'package:manyas_v2/User/ui/widgets/search_people_widget.dart';

class CloudFirestoreAPI {
  final String USERS = 'users';
  final String POSTS = 'posts';

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void updateUserData(UserModel user) async {
    DocumentReference ref = _db.collection(USERS).doc(user.uid);
    return await ref.set({
      'uid': user.uid,
      'name': user.name,
      'email': user.email,
      'photoURL': user.photoURL,
      'lastSignIn': DateTime.now(),
      'lengthFollowers': user.followers
    });
  }

  Future<void> updatePostData(PostModel post) async {
    CollectionReference refPosts = _db.collection(POSTS);

    String uid = await _auth.currentUser.uid;

    await refPosts.add({
      'urlImage': post.V_I,
      'description': post.description,
      'location': post.location,
      'likes': post.likes,
      'userOwner': _db.doc('${USERS}/${uid}'),
      'status': post.status,
      'dateTimeid': post.dateTimeid
    }).then((DocumentReference dr) {
      dr.get().then((DocumentSnapshot snapshot) {
        DocumentReference refUsers = _db.collection(USERS).doc(uid);
        refUsers.updateData({
          'myPosts':
              FieldValue.arrayUnion([_db.doc('${POSTS}/${snapshot.id}')]),
        });
        DocumentReference postUpdate = _db.collection(POSTS).doc(snapshot.id);
        postUpdate.updateData({
          'pid': snapshot.id,
        });
      });
    });
  }

  List<PostDesign> buildMyPosts(
      List<DocumentSnapshot> placesListSnapshot, UserModel userModel) {
    List<PostDesign> profilePost = List<PostDesign>();
    placesListSnapshot.forEach((p) {
      profilePost.add(PostDesign(
          PostModel(
              location: p.data()['location'],
              description: p.data()['description'],
              V_I: p.data()['urlImage'],
              likes: p.data()['likes'],
              status: p.data()['status'],
              dateTimeid: p.data()['dateTimeid'],
              pid: p.data()['pid']),
          userModel));
    });
    return profilePost;
  }

  List<PostFriendDesign> buildMyFriendPosts(
      List<DocumentSnapshot> postListSnapshot, UserModel userModel) {
    List<PostFriendDesign> profilePost = List<PostFriendDesign>();
    postListSnapshot.forEach((p) {
      profilePost.add(PostFriendDesign(
          PostModel(
              location: p.data()['location'],
              description: p.data()['description'],
              V_I: p.data()['urlImage'],
              likes: p.data()['likes'],
              status: p.data()['status'],
              dateTimeid: p.data()['dateTimeid'],
              pid: p.data()['pid']),
          userModel));
    });
    return profilePost;
  }

  Future<void> deletePost(PostModel postModel) async {
    String uid = await _auth.currentUser.uid;
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection(POSTS).getDocuments();
    print('querySnapshot : ${querySnapshot}');
    //var postToDelete = querySnapshot.documents.where((element) => element.data()['pid'] == postModel.pid);
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      var a = querySnapshot.documents[i];
      print(
          'Firebase: ${a.data()['dateTimeid']}  PostModel: ${postModel.dateTimeid}');
      if (a.data()['dateTimeid'] == postModel.dateTimeid) {
        CollectionReference postRef = _db.collection(POSTS);
        await postRef
            .doc(a.data()['pid'])
            .delete()
            .then((value) => print('se borró el post en la collection POSTS'))
            .catchError((onError) => print(
                'Error al borrar el post, cloudFirebase API: ${onError}'));
        DocumentReference refUsers = _db.collection(USERS).doc(uid);
        await refUsers
            .updateData({
              'myPosts': FieldValue.arrayRemove(
                  [_db.doc('${USERS}/${a.data()['pid']}')]),
            })
            .then((value) => print(
                'se borró el post -> (${a.data()['pid']}) en la lista de usuario -> (${refUsers.id})'))
            .catchError((onError) => print('Error ${onError}'));
      } else {
        print('no se encontró el post que desea borrar');
      }
    }
  }

  List<SearchPeopleWidget> filterAllUsers(
      List<DocumentSnapshot> peopleListSnapshot, String filterPerson) {
    List<SearchPeopleWidget> listPeopleWidget = List<SearchPeopleWidget>();
    print(
        'filterPerson: ${filterPerson} - peopleListSnapshot: ${peopleListSnapshot}');

    peopleListSnapshot
        .where((value) =>
            value['name'].toLowerCase().contains(filterPerson.toLowerCase()))
        .forEach((p) {
      listPeopleWidget.add(SearchPeopleWidget(
        userModel: UserModel(
            email: p.data()['email'],
            // followers: p.data()['followers'],
            name: p.data()['name'],
            photoURL: p.data()['photoURL'],
            uid: p.data()['uid']),
      ));
    });
    return listPeopleWidget;
  }

  Future<void> updateFollowersList(String uid, UserModel model) async {
    DocumentReference refFriend = _db.collection(USERS).doc(model.uid);
    await refFriend.updateData({
      'myFollowers': FieldValue.arrayUnion([_db.doc('${USERS}/${uid}')]),
    });
  }

  Future<void> incrementFollowersLength(UserModel model) async {
    DocumentReference refFriend = _db.collection(USERS).doc(model.uid);
    await refFriend.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        refFriend.updateData({
          'lengthFollowers': datasnapshot.data()['lengthFollowers'] + 1,
        });
      } else {
        print('ERROR: ${datasnapshot} no existe');
      }
    });
  }

  Future<void> decrementFollowersLength(UserModel model) async {
    DocumentReference refFriend = _db.collection(USERS).doc(model.uid);
    await refFriend.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        refFriend.updateData({
          'lengthFollowers': datasnapshot.data()['lengthFollowers'] - 1,
        });
      } else {
        print('ERROR: ${datasnapshot} no existe');
      }
    });
  }

  Future<void> deleteFollowersList(String uid, UserModel model) async {
    DocumentReference refFriend = _db.collection(USERS).doc(model.uid);
    await refFriend.updateData({
      'myFollowers': FieldValue.arrayRemove([_db.doc('${USERS}/${uid}')]),
    });
  }

  Future<void> updateFriendsList(UserModel model) async {
    String uid = await _auth.currentUser.uid;
    DocumentReference refUser = _db.collection(USERS).doc(uid);

    await refUser.update({
      'myFriends': FieldValue.arrayUnion([_db.doc('${USERS}/${model.uid}')]),
    }).then((value) {
      updateFollowersList(uid, model);
      incrementFollowersLength(model);
      print('Se agrego ${model.name} a la lista de amigos de ${refUser}');
    });
  }

  Future<void> deleteFriendsList(UserModel model) async {
    String uid = await _auth.currentUser.uid;
    DocumentReference refUser = _db.collection(USERS).doc(uid);
    DocumentReference refFriend = _db.collection(USERS).doc(model.uid);

    await refUser.update({
      'myFriends': FieldValue.arrayRemove([_db.doc('${USERS}/${model.uid}')]),
    }).then((value) {
      deleteFollowersList(uid, model);
      decrementFollowersLength(model);
      print('Se eliminó ${model.name} de la lista de amigos de ${refUser}');
    });
    ;
  }

  Future<List<PostFriendDesign>> buildPosts(
      List<DocumentReference> myfriendsList, UserModel userModel) async {
    List<PostFriendDesign> profilePost = List<PostFriendDesign>();

    for (int i = 0; i < myfriendsList.length; i++) {
      print('myfriendsList.length : ${myfriendsList.length}');
      print('ID myfriendsList : ${myfriendsList[i].id}');
      DocumentReference refUser =
          _db.collection(USERS).doc(myfriendsList[i].id);
      DocumentSnapshot ds = await refUser.get();

      QuerySnapshot qs = await _db
          .collection(POSTS)
          .where("userOwner",
              isEqualTo: Firestore.instance.document(
                  "${CloudFirestoreAPI().USERS}/${myfriendsList[i].id}"))
          .get();

      qs.docs.forEach((post) {
        print('${post.data()['description']}');
        profilePost.add(PostFriendDesign(
            PostModel(
                location: post.data()['location'],
                description: post.data()['description'],
                V_I: post.data()['urlImage'],
                likes: post.data()['likes'],
                status: post.data()['status'],
                dateTimeid: post.data()['dateTimeid'],
                pid: post.data()['pid']),
            UserModel(
              photoURL: ds.data()['photoURL'],
              name: ds.data()['name'],
              email: ds.data()['email'],
            )));
      });
    }

    profilePost.sort(
        (a, b) => b.postModel.dateTimeid.compareTo(a.postModel.dateTimeid));
    return profilePost;
  }

  Future<bool> updateLikePostData(PostModel post, bool isLiked, UserModel userModel) async {
    DocumentReference refPosts = _db.collection(POSTS).doc((post.pid));
    DocumentSnapshot documentSnapshot = await refPosts.get();

    List aux = documentSnapshot.data()['UsersLiked'];
    Iterable<dynamic> visibleUIDs = [];

    //print('esto esss 1 ${ Firestore.instance.document("${CloudFirestoreAPI().USERS}/${userModel.uid}") }');
    //print('esto esss 2 ${aux}');

    if(aux != null){
      visibleUIDs = aux.where((UserID) {
        String aux1 = UserID.toString();
        String aux2 = Firestore.instance
            .document("${CloudFirestoreAPI().USERS}/${userModel.uid}")
            .toString();
        return aux1.contains(aux2);
      });
    }

    //print('visibleUIDs ${visibleUIDs}');

    if (isLiked != true && visibleUIDs.isEmpty || aux == null) {
      await refPosts.update({
        'likes': post.likes + 1,
      }).then((value) {
        refPosts.updateData({
          'UsersLiked': FieldValue.arrayUnion([_db.doc('${USERS}/${userModel.uid}')]),
        });
      });
      return true;
    } else {
      if(post.likes <= 0){
        //esto es una medida de seguridad
        await refPosts.update({
          'likes': 0,
        }).then((value) {
          refPosts.updateData({
            'UsersLiked': FieldValue.arrayRemove([_db.doc('${USERS}/${userModel.uid}')]),
          });
        });
      }else{
        await refPosts.update({
          'likes': post.likes - 1,
        }).then((value) {
          refPosts.updateData({
            'UsersLiked': FieldValue.arrayRemove([_db.doc('${USERS}/${userModel.uid}')]),
          });
        });
      }
      return true;
    }
  }

  Future<bool> ColorLikeButton(PostModel post, UserModel userModel) async {
    DocumentReference refPosts = _db.collection(POSTS).doc((post.pid));
    DocumentSnapshot documentSnapshot = await refPosts.get();

    List aux = documentSnapshot.data()['UsersLiked'];
    Iterable<dynamic> visibleUIDs = [];

    //print('esto esss 1 ${ Firestore.instance.document("${CloudFirestoreAPI().USERS}/${userModel.uid}") }');
    //print('esto esss 2 ${aux}');

    if(aux != null){
      visibleUIDs = aux.where((UserID) {
        String aux1 = UserID.toString();
        String aux2 = Firestore.instance
            .document("${CloudFirestoreAPI().USERS}/${userModel.uid}")
            .toString();
        return aux1.contains(aux2);
      });
    }

    if(visibleUIDs.isEmpty || aux == null){
      return false;
    }else{
      return true;
    }
  }
}
