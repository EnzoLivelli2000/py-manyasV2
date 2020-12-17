import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:manyas_v2/Post/model/post_model.dart';
import 'package:manyas_v2/Post/ui/widgets/post_design.dart';
import 'package:manyas_v2/User/model/user_model.dart';

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
    }).then((DocumentReference dr) {
      dr.get().then((DocumentSnapshot snapshot) {
        DocumentReference refUsers = _db.collection(USERS).doc(uid);
        refUsers.updateData({
          'myPosts':
              FieldValue.arrayUnion([_db.doc('${USERS}/${snapshot.id}')]),
        });
        DocumentReference refPost = _db.collection(POSTS).doc(snapshot.id);
        refPost.updateData({
          'pid': snapshot.id,
        });
        post.pid = snapshot.id;
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
          ),
          userModel));
    });
    return profilePost;
  }

  Future<void> deletePost(PostModel postModel) async {
    String uid = await _auth.currentUser.uid;

    DocumentReference documentReference =
        await Firestore.instance.collection(POSTS).doc(postModel.pid);
    DocumentReference refUsers = _db.collection(USERS).doc(uid);
    CollectionReference postRef = _db.collection(POSTS);
    documentReference.get().then((DocumentSnapshot snapshot) {
      postRef
          .doc(snapshot.id)
          .delete()
          .then((v) => print('Se borró el producto'))
          .catchError((onError) => print('Error ${onError}'));

      refUsers
          .updateData({
            'myPosts': FieldValue.arrayRemove(
                [_db.doc('${USERS}/${snapshot.data()['pid']}')]),
          })
          .then((value) => print('se borró el producto de la lista del usuario correspondiente'))
          .catchError((onError) => print('Error ${onError}'));
    });
  }
}
