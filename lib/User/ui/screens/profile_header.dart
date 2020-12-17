import 'package:flutter/material.dart';
import 'package:manyas_v2/User/model/user_model.dart';
import 'package:manyas_v2/User/ui/widgets/button_bar.dart';
import 'package:manyas_v2/User/ui/widgets/choose_post.dart';
import 'package:manyas_v2/User/ui/widgets/user_info.dart';

class ProfileHeader extends StatelessWidget {
  UserModel userModel;
  int indexTap;

  ProfileHeader({Key key, this.userModel, this.indexTap});
  @override
  Widget build(BuildContext context) {
    return showProfileData(userModel, indexTap);
  }
}

Widget showProfileData(UserModel userModel, int indexTap){
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
            title
          ],
        ),
        UserInfo(userModel: userModel,),
        ButtonsBar(indexTap: indexTap),
        //ChoosePost(),
      ],
    ),
  );
}
