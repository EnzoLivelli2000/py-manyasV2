import 'package:flutter/material.dart';
import 'package:manyas_v2/User/model/user_model.dart';
import 'package:manyas_v2/User/ui/screens/profile_friend_content.dart';
import 'package:manyas_v2/User/ui/widgets/user_info.dart';
import 'package:manyas_v2/widgets/background3.dart';

class ProfileFriendScreen extends StatefulWidget {
  UserModel userModel;

  ProfileFriendScreen({Key key, @required this.userModel});

  @override
  _ProfileFriendScreenState createState() => _ProfileFriendScreenState();
}

class _ProfileFriendScreenState extends State<ProfileFriendScreen> {
  int indexTap = 0;

  void onTapTapped(int index) {
    setState(() {
      indexTap = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Background3(),
      ListView(
        children: <Widget>[
          showProfileHeader(widget.userModel, indexTap),
//        ChoosePost(userModel: userAux),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
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
                margin: EdgeInsets.only(right: 35, left: 40),
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
                //margin: EdgeInsets.only(right: 25, left: 25),
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

  Widget showProfileHeader(UserModel userModel, int indexTap){
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
                  size: 45,
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


