import 'package:flutter/material.dart';
import 'package:manyas_v2/Party/ui/screens/prueba_party.dart';
import 'package:manyas_v2/Post/ui/screens/prueba_post.dart';
import 'package:manyas_v2/Storie/ui/screens/prueba_storie.dart';
import 'package:manyas_v2/User/model/user_model.dart';
import 'package:manyas_v2/User/ui/screens/profile_content.dart';

class ChoosePost extends StatefulWidget {
  final UserModel userModel;

  const ChoosePost({Key key, this.userModel}) : super(key: key);

  @override
  _ChoosePostState createState() => _ChoosePostState();
}

class _ChoosePostState extends State<ChoosePost> {
  UserModel userModel;

  _ChoosePostState({this.userModel});

  int indexTap = 0;

  void onTapTapped(int index) {
    setState(() {
      indexTap = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetsChildren = [
      //ProfileContent(widget.userModel),
      PruebaStorie(),
      PruebaParty(),
    ];
    return Row(
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
            child: Text('Storie',
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
    );
  }
}
