import 'package:bloc_provider/bloc_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manyas_v2/User/bloc/user_bloc.dart';
import 'package:manyas_v2/User/model/user_model.dart';

class UserInfo extends StatefulWidget {
  UserModel userModel;

  UserInfo({Key key, this.userModel});

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  UserBloc userBloc;

  int friendsLength;
  int followLength;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _asyncLengthFriends();
      _asyncLengthFollowers();
    });
  }

  void getLengthFriends() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      _asyncLengthFriends();
    });
  }

  _asyncLengthFriends() async{
    DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(widget.userModel.uid);
    DocumentSnapshot documentSnapshot = await userRef.get();
    List aux = documentSnapshot.data()['myFriends'];

    if(aux == null){
      friendsLength = 0;
    }else{
      setState(() {
        friendsLength = aux.length;
      });
    }
  }

  void getLengthFollowers() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      _asyncLengthFollowers();
    });
  }

  _asyncLengthFollowers() async{
    DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(widget.userModel.uid);
    DocumentSnapshot documentSnapshot = await userRef.get();
    List aux = documentSnapshot.data()['myFollowers'];

    if(aux == null){
      setState(() {
        followLength = 0;
      });
    }
    else{
      setState(() {
        followLength = aux.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);
    getLengthFriends();
    getLengthFollowers();
    final userPhoto = Container(
      width: 90.0,
      height: 90.0,
      margin: EdgeInsets.only(right: 20.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          shape: BoxShape.rectangle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(widget.userModel.photoURL),
          )
      ),
    );
    final userInfo = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
          Container(
              padding: new EdgeInsets.only(right: 13.0),
                child: Text(
                    widget.userModel.name,
                    maxLines: 1,
                    //softWrap: false,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      fontSize: 19.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Lato',
                      decoration: TextDecoration.none,
                    )
                ),
          ),
        Text(
            widget.userModel.email,
            style: TextStyle(
                fontSize: 15.0,
                color: Colors.black26,
                fontFamily: 'Lato',
                decoration: TextDecoration.none,
            )
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 4),
                child: Text(
                    '${friendsLength == null? 0: friendsLength} Friends',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black26,
                      fontFamily: 'Lato',
                      decoration: TextDecoration.none,
                    )
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 4),
                child: Text(
                    '${followLength == null? 0: followLength} Followers',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black26,
                      fontFamily: 'Lato',
                      decoration: TextDecoration.none,
                    )
                ),
              ),
            ],
          ),
        )
      ],
    );
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 0.0
      ),
      child: Row(
        children: <Widget>[
          userPhoto,
          userInfo,
        ],
      ),
    );
  }
}
