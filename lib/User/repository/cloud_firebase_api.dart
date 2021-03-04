import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:manyas_v2/Party/model/party_model.dart';
import 'package:manyas_v2/Party/ui/widgets/party_design.dart';
import 'package:manyas_v2/Party/ui/widgets/party_friend_design.dart';
import 'package:manyas_v2/Post/model/post_model.dart';
import 'package:manyas_v2/Post/ui/widgets/post_design.dart';
import 'package:manyas_v2/Post/ui/widgets/post_friend_design.dart';
import 'package:manyas_v2/User/model/user_model.dart';
import 'package:manyas_v2/User/ui/widgets/search_people_widget.dart';

class CloudFirestoreAPI {
  final String USERS = 'users';
  final String POSTS = 'posts';
  final String PARTIES = 'parties';

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void updateUserData(UserModel user) async {
    DocumentReference ref = _db.collection(USERS).doc(user.uid);
    DocumentSnapshot documentSnapshot = await ref.get();
    if(documentSnapshot.data()['uid'] != null || documentSnapshot.data()['uid'] != '') {
      return await ref.update({
        'lastSignIn': DateTime.now(),
      });
    }else{
      return await ref.set({
        'uid': user.uid,
        'name': user.name,
        'email': user.email,
        'photoURL': user.photoURL,
        'lastSignIn': DateTime.now(),
      });
    }
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
              dateTimeid: p.data()['dateTimeid'],
              pid: p.data()['pid']),
          userModel));
    });

    profilePost.sort(
            (a, b) => b.postModel.dateTimeid.compareTo(a.postModel.dateTimeid));

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

    profilePost.sort(
            (a, b) => b.postModel.dateTimeid.compareTo(a.postModel.dateTimeid));

    return profilePost;
  }

  Future<void> deletePost(PostModel postModel) async {
    String uid = await _auth.currentUser.uid;
    QuerySnapshot querySnapshot = await Firestore.instance.collection(POSTS).getDocuments();
    print('querySnapshot : ${querySnapshot}');
    //var postToDelete = querySnapshot.documents.where((element) => element.data()['pid'] == postModel.pid);

    Iterable<QueryDocumentSnapshot> aux = querySnapshot.documents.where((element) {return element.id.contains(postModel.pid);});
    print('xrp PUMP :( : ${aux.isEmpty}');

    aux.forEach((element) async {
      final String pid = element.data()['pid'];
      CollectionReference postRef = _db.collection(POSTS);
      DocumentReference refUsers = _db.collection(USERS).doc(uid);

      print('pid xrp ${pid}');

      await postRef
          .doc(pid)
          .delete()
          .then((value) => print('se borró el post en la collection POSTS'))
          .catchError((onError) =>
          print(
              'Error al borrar el post, cloudFirebase API: ${onError}'));

      await refUsers
          .updateData({
        'myPosts': FieldValue.arrayRemove([_db.doc('${POSTS}/${pid}')]),
      }).then((value) =>
          print('se borró el post -> (${pid}) en la lista de usuario -> (${refUsers.id})'))
          .catchError((onError) => print('Error ${onError}'));
    });
  }

  List<SearchPeopleWidget> filterAllUsers(
      List<DocumentSnapshot> peopleListSnapshot, String filterPerson) {
    List<SearchPeopleWidget> listPeopleWidget = List<SearchPeopleWidget>();
    print('filterPerson: ${filterPerson} - peopleListSnapshot: ${peopleListSnapshot}');

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
              uid: p.data()['uid']),)
        );
      });
    return listPeopleWidget;
  }

  Future<void> updateFollowersList(String uidFriend, UserModel model) async {
    DocumentReference refFriend = _db.collection(USERS).doc(model.uid);

    if (model.uid.toString() != uidFriend) {
      await refFriend.updateData({
        'myFollowers': FieldValue.arrayUnion([_db.doc('${USERS}/${uidFriend}')]),
      });
    }else{
      print('NO puedes autoseguirte');
    }
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

    if(uid != model.uid ){
      await refUser.update({
        'myFriends': FieldValue.arrayUnion([_db.doc('${USERS}/${model.uid}')]),
      }).then((value) {
        updateFollowersList(uid, model);
        incrementFollowersLength(model);
        print('Se agrego ${model.name} a la lista de amigos de ${refUser}');
      });
    }else{
      print('NO puedes autoseguirte');
    }
  }

  Future<void> deleteFriendsList(UserModel model) async {
    String uid = await _auth.currentUser.uid;
    DocumentReference refUser = _db.collection(USERS).doc(uid);
    DocumentReference refFriend = _db.collection(USERS).doc(model.uid);

    if(uid != model.uid ) {
      await refUser.update({
        'myFriends': FieldValue.arrayRemove([_db.doc('${USERS}/${model.uid}')]),
      }).then((value) {
        deleteFollowersList(uid, model);
        decrementFollowersLength(model);
        print('Se eliminó ${model.name} de la lista de amigos de ${refUser}');
      });
    }else{
      print('NO puedes autoseguirte');
    }

  }

  Future<bool> SALVADORALIST(String CurrentUId, UserModel userModel) async {
    DocumentReference refUser = _db.collection(USERS).doc(CurrentUId);
    DocumentSnapshot documentSnapshot = await refUser.get();

    List aux = documentSnapshot.data()['myFriends'];
    Iterable<dynamic> visibleUIDs = [];

    /*bool x = aux.contains(Firestore.instance
        .document("${CloudFirestoreAPI().USERS}/${uID}")
        .toString());
    print('xxx ${x}');*/

    /*if (aux != null) {
      visibleUIDs = aux.where((UserID) {
        String aux1 = UserID.toString();
        String aux2 = Firestore.instance
            .document("${CloudFirestoreAPI().USERS}/${CurrentUId}")
            .toString();
        print('aux1: ${aux1}, aux2: ${aux2}');
        return aux1.contains(aux2);
      });
    }*/

    if(aux != null) {
      visibleUIDs = aux.where((element) {
            return element.toString().contains(Firestore.instance.document("${CloudFirestoreAPI().USERS}/${userModel.uid}").toString());
          });
    }

    print('el valor de visibleUIDs es: ${visibleUIDs}');

    if(aux != null){
      if (visibleUIDs.isEmpty) {
        print('entro el update friend');
        await updateFriendsList(userModel);
        return true;
      } else {
        print('entro el delete friend');
        await deleteFriendsList(userModel);
        return false;
      }
    }else{
      refUser.update({
        'myFriends': [],
        'myFollowers': []
      });
      print('Se creo en la base de datos un par de listas de myFriends y myFollowers de este usuario');
      return true;
    }
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
              uid: ds.data()['uid'],
            )));
      });
    }

    profilePost.sort(
            (a, b) => b.postModel.dateTimeid.compareTo(a.postModel.dateTimeid));
    return profilePost;
  }

  List<PostFriendDesign> buildPosts1(List<DocumentReference> myfriendsList,
      UserModel userModel) {
    List<PostFriendDesign> profilePost = List<PostFriendDesign>();

    for (int i = 0; i < myfriendsList.length; i++) {
      print('myfriendsList.length : ${myfriendsList.length}');
      print('ID myfriendsList : ${myfriendsList[i].id}');
      DocumentReference refUser = _db.collection(USERS).doc(
          myfriendsList[i].id);
      DocumentSnapshot ds; // =  refUser.get();

      QuerySnapshot qs = _db
          .collection(POSTS)
          .where("userOwner",
          isEqualTo: Firestore.instance.document(
              "${CloudFirestoreAPI().USERS}/${myfriendsList[i].id}"))
          .get() as QuerySnapshot;

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

  Future<bool> updateLikeData(String COLLECTION , String pUid, bool isLiked,
      String uID) async {
    DocumentReference refPosts = _db.collection(COLLECTION).doc((pUid));
    DocumentSnapshot documentSnapshot = await refPosts.get();

    List aux = documentSnapshot.data()['UsersLiked'];
    Iterable<dynamic> visibleUIDs = [];

    //print('esto esss 1 ${ Firestore.instance.document("${CloudFirestoreAPI().USERS}/${userModel.uid}") }');
    print('esto aux 2 ${aux}');

    if (aux != null) {
      visibleUIDs = aux.where((UserID) {
        String aux1 = UserID.toString();
        String aux2 = Firestore.instance
            .document("${CloudFirestoreAPI().USERS}/${uID}")
            .toString();
        return aux1.contains(aux2);
      });
    }

    //print('visibleUIDs ${visibleUIDs}');

    if (isLiked != true && visibleUIDs.isEmpty || aux == null) {
      await refPosts.update({
        'likes': documentSnapshot.data()['likes'] + 1,
      }).then((value) {
        refPosts.updateData({
          'UsersLiked': FieldValue.arrayUnion([_db.doc('${USERS}/${uID}')]),
        });
      });
      return true;
    } else {
      await refPosts.update({
        'likes': documentSnapshot.data()['likes'] - 1,
      }).then((value) {
        refPosts.updateData({
          'UsersLiked': FieldValue.arrayRemove([_db.doc('${USERS}/${uID}')]),
        });
      });
    }
    return true;

    /*else {
    if(post.likes <= 0){
    //esto es una medida de seguridad
    await refPosts.update({
    'likes': 0,
    }).then((value) {
    refPosts.updateData({
    'UsersLiked': FieldValue.arrayRemove([_db.doc('${USERS}/${uID}')]),
    });
    });
    }
    }*/
  }

  Future<bool> ColorLikeButton(String COLLECTION, String pUid, String uID) async {
    DocumentReference refPosts = _db.collection(COLLECTION).doc((pUid));
    DocumentSnapshot documentSnapshot = await refPosts.get();

    List aux = documentSnapshot.data()['UsersLiked'];
    Iterable<dynamic> visibleUIDs = [];

    //print('esto esss 1 ${ Firestore.instance.document("${CloudFirestoreAPI().USERS}/${userModel.uid}") }');
    //print('esto esss 2 ${aux}');

    if (aux != null) {
      visibleUIDs = aux.where((UserID) {
        String aux1 = UserID.toString();
        String aux2 = Firestore.instance
            .document("${CloudFirestoreAPI().USERS}/${uID}")
            .toString();
        return aux1.contains(aux2);
      });
    }

    if (visibleUIDs.isEmpty || aux == null) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> ColorFollowButton(String CurrentUId, UserModel userModel) async {
      DocumentReference refUser = _db.collection(USERS).doc(CurrentUId);
      DocumentSnapshot documentSnapshot = await refUser.get();

      List aux = documentSnapshot.data()['myFriends'];
      Iterable<dynamic> visibleUIDs = [];

      /*bool x = aux.contains(Firestore.instance
        .document("${CloudFirestoreAPI().USERS}/${uID}")
        .toString());
    print('xxx ${x}');*/

      /*if (aux != null) {
      visibleUIDs = aux.where((UserID) {
        String aux1 = UserID.toString();
        String aux2 = Firestore.instance
            .document("${CloudFirestoreAPI().USERS}/${CurrentUId}")
            .toString();
        print('aux1: ${aux1}, aux2: ${aux2}');
        return aux1.contains(aux2);
      });
    }*/

      if(aux != null) {
        visibleUIDs = aux.where((element) {
          return element.toString().contains(Firestore.instance.document("${CloudFirestoreAPI().USERS}/${userModel.uid}").toString());
        });
      }

      print('el valor de visibleUIDs es: ${visibleUIDs}');

      if(aux != null){
        if (visibleUIDs.isEmpty) {
          return false;
        } else {
          return true;
        }
      }else{
        print('ocurrio un error al presionasr el botn de follow');
        return null;
      }

  }

  Future<int> LengthLikes(String COLLECTION, String pUid) async {
    DocumentReference refPosts = _db.collection(COLLECTION).doc((pUid));
    DocumentSnapshot documentSnapshot = await refPosts.get();

    return documentSnapshot.data()['likes'];
  }


  /*PARTIES*********************************************************************************************************************************************************************************/


  Future<void> updatePartyData(PartyModel party, var partyNumber, GeoPoint target) async {
    CollectionReference refPosts = _db.collection(PARTIES);

    String uid = await _auth.currentUser.uid;

    await refPosts.add({
      'dateTimeNow': party.dateTimeNow,
      'Partydate': party.Partydate,
      'PartyTime': party.PartyTime,
      'title': party.title,
      'description': party.description,
      'urlImage': party.V_I,
      'Userlocation': 'Esto aún tengo que arreglar',
      'price': party.price,
      'isAdult' : party.isAdult,
      'userOwner': _db.doc('${USERS}/${uid}'), //este dato se carga al añadir este documento a la colección
      'status': party.status,
      'likes': party.likes,
    }).then((DocumentReference dr) {
      dr.get().then((DocumentSnapshot snapshot) async {

        await Firestore.instance
            .collection(PARTIES)
            .doc(snapshot.id)
            .collection('partyTarget_people')
            .document(partyNumber)
            .setData({
          'target': GeoPoint(target.latitude, target.longitude)
        });

        DocumentReference refUsers = _db.collection(USERS).doc(uid);

        refUsers.updateData({
          'myParties':
          FieldValue.arrayUnion([_db.doc('${PARTIES}/${snapshot.id}')]),
        });
        DocumentReference partyUpdate = _db.collection(PARTIES).doc(snapshot.id);
        partyUpdate.updateData({
          'pid': snapshot.id,
          'PartyLocation': GeoPoint(target.latitude, target.longitude),
          'codeParty' : partyNumber
        });
      });
    });
  }

  List<PartyDesign> buildMyParties(List<DocumentSnapshot> placesListSnapshot,
      UserModel userModel) {
    List<PartyDesign> profileParty = List<PartyDesign>();
    placesListSnapshot.forEach((p) {
      print('party p :> ${p}');
      profileParty.add(PartyDesign(
          PartyModel(
              dateTimeNow: p.data()['dateTimeNow'],
              Partydate: p.data()['Partydate'],
              Partylocation: p.data()['PartyLocation'],
              PartyTime: p.data()['PartyTime'],
              title: p.data()['title'],
              description: p.data()['description'],
              V_I: p.data()['urlImage'],
              Userlocation: p.data()['Userlocation'],
              price: p.data()['price'],
              isAdult: p.data()['isAdult'],
              likes : p.data()['likes'],
              pid: p.data()['pid'],
              status: p.data()['status'],
              codeParty: p.data()['codeParty'],
              //codeParty: p.reference.collection('partyTarget_people').id
            ),
          userModel));
    });

    profileParty.sort(
            (a, b) => b.partyModel.dateTimeNow.compareTo(a.partyModel.dateTimeNow));

    return profileParty;
  }

  Future<void> deleteParty(PartyModel partyModel) async {
    String uid = await _auth.currentUser.uid;
    QuerySnapshot querySnapshot = await Firestore.instance.collection(PARTIES).getDocuments();

    Iterable<QueryDocumentSnapshot> aux = querySnapshot.documents.where((element) {return element.id.contains(partyModel.pid);});

    aux.forEach((element) async {
      final String pid = element.data()['pid'];
      final String targetid = element.data()['codeParty'];
      //final String targetid = element.reference.collection('partyTarget_people').id;
      CollectionReference partyRef = _db.collection(PARTIES);
      DocumentReference refUsers = _db.collection(USERS).doc(uid);

      print('targetID ${targetid}');

      await partyRef
          .doc(pid)
          .delete()
          .then((value) => print('se borró la party en la collection PARTIES'))
          .catchError((onError) =>
          print(
              'Error al borrar el party, cloudFirebase API: ${onError}'));

      await partyRef
          .doc(pid)
          .collection('partyTarget_people')
          .doc(targetid) //Nos falta el IDparty
          .delete()
          .then((value) => print('se borró la partyTarget en la collection PARTIES'))
          .catchError((onError) =>
          print(
              'Error al borrar el partyTarget, cloudFirebase API: ${onError}'));

      await refUsers
          .updateData({
        'myParties': FieldValue.arrayRemove([_db.doc('${PARTIES}/${pid}')]),
      }).then((value) =>
          print('se borró el post -> (${pid}) en la lista de usuario -> (${refUsers.id})'))
          .catchError((onError) => print('Error ${onError}'));
    });
  }

  Future<List<PartyFriendDesign>> buildParties(
      List<DocumentReference> myfriendsList, UserModel userModel) async {
    List<PartyFriendDesign> profileParty = List<PartyFriendDesign>();

    for (int i = 0; i < myfriendsList.length; i++) {
      print('myfriendsList.length : ${myfriendsList.length}');
      print('ID myfriendsList : ${myfriendsList[i].id}');
      DocumentReference refUser =
      _db.collection(USERS).doc(myfriendsList[i].id);
      DocumentSnapshot ds = await refUser.get();

      QuerySnapshot qs = await _db
          .collection(PARTIES)
          .where("userOwner",
          isEqualTo: Firestore.instance.document(
              "${CloudFirestoreAPI().USERS}/${myfriendsList[i].id}"))
          .get();

      qs.docs.forEach((party) {
        profileParty.add(PartyFriendDesign(
            PartyModel(
              dateTimeNow: party.data()['dateTimeNow'],
              Partydate: party.data()['Partydate'],
              Partylocation: party.data()['PartyLocation'],
              PartyTime: party.data()['PartyTime'],
              title: party.data()['title'],
              description: party.data()['description'],
              V_I: party.data()['urlImage'],
              Userlocation: party.data()['Userlocation'],
              price: party.data()['price'],
              isAdult: party.data()['isAdult'],
              likes : party.data()['likes'],
              pid: party.data()['pid'],
              status: party.data()['status'],
            ),
            UserModel(
              photoURL: ds.data()['photoURL'],
              name: ds.data()['name'],
              email: ds.data()['email'],
              uid: ds.data()['uid'],
            )));
      });
    }

    profileParty.sort(
            (a, b) => b.partyModel.dateTimeNow.compareTo(a.partyModel.dateTimeNow));
    return profileParty;
  }

  List<PartyFriendDesign> buildMyFriendParties(
      List<DocumentSnapshot> postListSnapshot, UserModel userModel) {
    List<PartyFriendDesign> profileParties = List<PartyFriendDesign>();
    postListSnapshot.forEach((party) {
      profileParties.add(PartyFriendDesign(
          PartyModel(
            dateTimeNow: party.data()['dateTimeNow'],
            Partydate: party.data()['Partydate'],
            Partylocation: party.data()['PartyLocation'],
            PartyTime: party.data()['PartyTime'],
            title: party.data()['title'],
            description: party.data()['description'],
            V_I: party.data()['urlImage'],
            Userlocation: party.data()['Userlocation'],
            price: party.data()['price'],
            isAdult: party.data()['isAdult'],
            likes : party.data()['likes'],
            pid: party.data()['pid'],
            status: party.data()['status'],
          ),
          userModel));
    });

    profileParties.sort(
            (a, b) => b.partyModel.dateTimeNow.compareTo(a.partyModel.dateTimeNow));

    return profileParties;
  }
}
