import 'package:bloc_provider/bloc_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:flutter/material.dart';
import 'package:manyas_v2/User/bloc/user_bloc.dart';
import 'package:manyas_v2/User/model/user_model.dart';
import 'package:manyas_v2/User/ui/screens/profile_friend_content.dart';
import 'package:manyas_v2/User/ui/widgets/user_info.dart';
import 'package:manyas_v2/widgets/background3.dart';
import 'package:manyas_v2/widgets/button_x.dart';
import 'package:manyas_v2/widgets/button_white.dart';

class ProfileFriendScreen extends StatefulWidget {
  UserModel userModel;

  ProfileFriendScreen({Key key, @required this.userModel});

  @override
  _ProfileFriendScreenState createState() => _ProfileFriendScreenState();
}

class _ProfileFriendScreenState extends State<ProfileFriendScreen> {
  int indexTap = 0;
  UserBloc userBloc;
  bool colorFollowButton = false;
  bool isFollowedX = false;

  @override
  void initState() {
    // TODO: implement initState
    getColorFollowButton();
    super.initState();
  }

  void onTapTapped(int index) {
    setState(() {
      indexTap = index;
    });
  }

  Future<bool> onFollowButtonTapped(bool isFollowedX) async{
    print('se presionó el botón de like ${isFollowedX}');
    String uidCurrentUser = await firebaseAuth.FirebaseAuth.instance.currentUser.uid;
    colorFollowButton = await userBloc.SALVADORALIST(uidCurrentUser, widget.userModel);
    return !isFollowedX;
  }

  bool getColorFollowButton() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _asyncColorFollowButton();
    });
  }

  _asyncColorFollowButton() async {
    String uidCurrentUser = await firebaseAuth.FirebaseAuth.instance.currentUser.uid;
    bool aux = await userBloc.ColorFollowButton(uidCurrentUser, widget.userModel);
    print('aux ${aux}');

    if (aux == null) {
      if (mounted) {
        setState(() {
          colorFollowButton = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          colorFollowButton = aux;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);
    return Stack(children: <Widget>[
      Background3(),
      ListView(
        children: <Widget>[
          showProfileHeader(widget.userModel, indexTap),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              followButton(widget.userModel, colorFollowButton),
              messageButton(widget.userModel),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 40),
                child: GestureDetector(
                  onTap: () {
                    onTapTapped(0);
                    print('se solicita visualizar un post');
                  },
                  child: Text(
                    'Post',
                    style: TextStyle(
                      fontSize: 19.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Lato',
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 35, left: 40, bottom: 40),
                child: GestureDetector(
                  onTap: () {
                    onTapTapped(1);
                    print('se solicita visualizar un Event');
                  },
                  child: Text(
                    'Storie',
                    style: TextStyle(
                      fontSize: 19.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Lato',
                      decoration: TextDecoration.none,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 40),
                child: GestureDetector(
                    onTap: () {
                      onTapTapped(2);
                      print('se solicita visualizar las Stories');
                    },
                    child: Text('Event',
                        style: TextStyle(
                          fontSize: 19.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'Lato',
                          decoration: TextDecoration.none,
                        ))),
              ),
            ],
          ),
          ProfileFriendContent(widget.userModel, indexTap),
        ],
      )
    ]);
  }

  Widget followButton(UserModel userModel, bool colorFollowButton) {
    return Container(
      margin: EdgeInsets.only(bottom: 35, right: 10),
      child: ButtonX(
        onPressed: () async{
          print('se presionó el nuevo botón de FOLLOW');
          await onFollowButtonTapped(isFollowedX);
          //await getLengthFollow();
          getColorFollowButton();
          print('El valor de like (SALIDA) ${colorFollowButton}');
          /*print('follow');
          userBloc.updateFriendsList(userModel);
          getColorFollowButton();*/
        },
        titleButton: 'follow',
        height: 30,
        width: 90,
        buttonColor: colorFollowButton == false ? Color(0xFF3EF850):Colors.grey,
      ),
    );
  }

  Widget messageButton(UserModel userModel) {
    return Container(
      margin: EdgeInsets.only(bottom: 35, left: 10),
      child: ButtonX(
        onPressed: () {
          print('message');
          userBloc.deleteFriendsList(userModel);
        },
        titleButton: 'Message',
        height: 30,
        width: 90,
        buttonColor: Color(0xFFE9E9E9),
        titleColor: Color(0xFF000000),
      ),
    );
  }

  Widget showProfileHeader(UserModel userModel, int indexTap) {
    final title = Text(
      'Profile',
      style: TextStyle(
        fontFamily: 'Lato',
        color: Color(0xFFF87125),
        fontWeight: FontWeight.bold,
        fontSize: 30,
        decoration: TextDecoration.none,
      ),
    );

    return Container(
      margin: EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          top: 50.0
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_left,
                  color: Colors.orange,
                  size: 35,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title
            ],
          ),
          UserInfo(userModel: userModel,),
        ],
      ),
    );
  }

}


