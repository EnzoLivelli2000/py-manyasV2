import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      'lastSignIn': DateTime.now()
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
          'myPosts': FieldValue.arrayUnion([_db.doc('${USERS}/${snapshot.id}')]),
        });
        DocumentReference postUpdate = _db.collection(POSTS).doc(snapshot.id);
        postUpdate.updateData({
          'pid': snapshot.id,
        });
      });
    });
  }

  List<PostDesign> buildMyPosts(List<DocumentSnapshot> placesListSnapshot,
      UserModel userModel) {
    List<PostDesign> profilePost = List<PostDesign>();
    placesListSnapshot.forEach((p) {
      profilePost.add(PostDesign(
          PostModel(
            location: p.data()['location'],
            description: p.data()['description'],
            V_I: p.data()['urlImage'],
            likes: p.data()['likes'],
            status: p.data()['status'],
            dateTimeid: p.data()['dateTimeid']
          ),
          userModel));
    });
    return profilePost;
  }

  List<PostFriendDesign> buildMyFriendPosts(List<DocumentSnapshot> placesListSnapshot,
      UserModel userModel) {
    List<PostFriendDesign> profilePost = List<PostFriendDesign>();
    placesListSnapshot.forEach((p) {
      profilePost.add(PostFriendDesign(
          PostModel(
              location: p.data()['location'],
              description: p.data()['description'],
              V_I: p.data()['urlImage'],
              likes: p.data()['likes'],
              status: p.data()['status'],
              dateTimeid: p.data()['dateTimeid']
          ),
          userModel));
    });
    return profilePost;
  }

  Future<void> deletePost(PostModel postModel) async {
    String uid = await _auth.currentUser.uid;
    QuerySnapshot querySnapshot = await Firestore.instance.collection(POSTS)
        .getDocuments();
    print('querySnapshot : ${querySnapshot}');
    //var postToDelete = querySnapshot.documents.where((element) => element.data()['pid'] == postModel.pid);
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      var a = querySnapshot.documents[i];
      print('Firebase: ${a.data()['dateTimeid']}  PostModel: ${postModel.dateTimeid}');
      if (a.data()['dateTimeid'] == postModel.dateTimeid) {
        CollectionReference postRef = _db.collection(POSTS);
        await postRef.doc(a.data()['pid']).delete().
        then((value) =>
            print('se borró el post en la collection POSTS')
        ).
        catchError((onError) =>
            print('Error al borrar el post, cloudFirebase API: ${onError}'));
        DocumentReference refUsers = _db.collection(USERS).doc(uid);
        await refUsers.updateData({
          'myPosts': FieldValue.arrayRemove([_db.doc('${USERS}/${a.data()['pid']}')]),
        }).then((value) =>
            print('se borró el post -> (${a.data()['pid']}) en la lista de usuario -> (${refUsers.id})')

        ).
        catchError((onError) => print('Error ${onError}'));
      }else{
        print('no se encontró el post que desea borrar');
      }
    }
  }
  
  List<SearchPeopleWidget> filterAllUsers(List<DocumentSnapshot> peopleListSnapshot, String filterPerson)  {
    List<SearchPeopleWidget> listPeopleWidget= List<SearchPeopleWidget>();
    print('filterPerson: ${filterPerson} - peopleListSnapshot: ${peopleListSnapshot}');

    peopleListSnapshot.where((value) =>
        value['name'].toLowerCase().contains(filterPerson.toLowerCase()))
        .forEach((p) {
      listPeopleWidget.add(SearchPeopleWidget(
        userModel: UserModel(
            email: p.data()['email'],
            followers: p.data()['followers'],
            name: p.data()['name'],
            photoURL: p.data()['photoURL'],
            uid: p.data()['uid']
        ),
      ));
    });
    return listPeopleWidget;
  }
}
