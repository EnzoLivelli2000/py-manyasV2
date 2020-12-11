import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:manyas_v2/User/model/user_model.dart';

class CloudFirestoreAPI{
  final String USERS = 'users';

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void updateUserData(UserModel user) async{
    DocumentReference ref = _db.collection(USERS).doc(user.uid);
    return await ref.set({
      'uid' : user.uid,
      'name' : user.name,
      'email' : user.email,
      'photoURL' : user.photoURL,
      'lastSignIn' : DateTime.now()
    });
  }
}