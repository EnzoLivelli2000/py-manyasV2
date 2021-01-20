import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:manyas_v2/User/bloc/user_bloc.dart';
import 'package:manyas_v2/User/model/user_model.dart';
import 'package:manyas_v2/User/ui/screens/profile_friend_content.dart';
import 'package:manyas_v2/User/ui/widgets/user_info.dart';
import 'package:manyas_v2/screens/home_content.dart';
import 'package:manyas_v2/screens/home_content_prueba.dart';
import 'package:manyas_v2/widgets/background3.dart';
import 'package:manyas_v2/widgets/button_x.dart';
import 'package:manyas_v2/widgets/button_white.dart';

//CAPAZ ESTO LO VAYA A BORRAR

class HomePosts extends StatefulWidget {
  UserModel userModel;

  HomePosts({Key key, @required this.userModel});

  @override
  _HomePostsState createState() => _HomePostsState();
}

class _HomePostsState extends State<HomePosts> {
  int indexTap = 0;
  UserBloc userBloc;

  void onTapTapped(int index) {
    setState(() {
      indexTap = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);
    return Stack(children: <Widget>[
      //Background3(),
      ListView(
        children: <Widget>[
          //showProfileHeader(widget.userModel, indexTap),
//        ChoosePost(userModel: userAux),
          /*Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              followButton(widget.userModel),
              messageButton(widget.userModel),
            ],
          ),*/
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: GestureDetector(
                  onTap: () {
                    onTapTapped(0);
                    print('se solicita visualizar los post de mis amigos');
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
                    print('se solicita visualizar los Storie´s de mis amigos');
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
                      print('se solicita visualizar las Event de mis amigos');
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
          HomeContent(widget.userModel, indexTap),
        ],
      )
    ]);
  }

  /*void onTapFollow(String titleFollow, bool auxPiv, UserModel userModel) {
    if (auxPiv != true) {
      setState(() {
        titleFollow = 'unfollow';
      });
      userBloc.deleteFriendsList(userModel);
    }else{
      setState(() {
        titleFollow = 'follow';
      });
      userBloc.updateFriendsList(userModel);
    }
  }*/

  Widget followButton(UserModel userModel) {
    return Container(
      margin: EdgeInsets.only(bottom: 35, right: 10),
      child: ButtonX(
        onPressed: () {
          print('follow');
          userBloc.updateFriendsList(userModel);
        },
        titleButton: 'follow',
        height: 30,
        width: 90,
        buttonColor: Color(0xFF3EF850),
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


