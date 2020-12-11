import 'package:flutter/material.dart';
import 'package:manyas_v2/User/model/user_model.dart';
import 'package:manyas_v2/User/ui/screens/profile_content.dart';
import 'package:manyas_v2/User/ui/screens/profile_header.dart';
import 'package:manyas_v2/User/ui/widgets/choose_post.dart';
import 'package:manyas_v2/widgets/background3.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

var userAux = UserModel(
  uid: 'contraseña',
  name: 'Enzo Liv',
  email: 'enzo.livelli@gmail.com',
  followers: 654,
  photoURL: 'assets/images/profile_photo.PNG',
);

class _ProfileScreenState extends State<ProfileScreen> {
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
          ProfileHeader(userModel: userAux),
//        ChoosePost(userModel: userAux),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: GestureDetector(
                  onTap: () {
                    onTapTapped(0);
                    print('se solicita crear un post');
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
                    print('se solicita crear un Event');
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
                      print('se solicita crear un Stories');
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
          ProfileContent(userAux, indexTap),
        ],
      )
    ]);
  }
}

