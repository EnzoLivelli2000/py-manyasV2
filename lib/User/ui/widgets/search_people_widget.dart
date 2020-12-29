import 'package:flutter/material.dart';
import 'package:manyas_v2/User/model/user_model.dart';
import 'package:manyas_v2/User/ui/screens/profile_friend_screen.dart';

class SearchPeopleWidget extends StatelessWidget {
  UserModel userModel;

  SearchPeopleWidget({Key key, this.userModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(right: 10, left: 10),
          child:showWidget()
      ),
      onTap: (){
        print('se solicitó acceder al amig@ ${userModel.name}');
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => ProfileFriendScreen(userModel: userModel)));
      },
    );
  }

  Widget showWidget() {
    return Row(
      children: <Widget>[
        Container(
            width: 45.0,
            height: 45.0,
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(userModel.photoURL),
              //image: NetworkImage(user.photoURL),
            ))),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
                userModel.name,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 19.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Lato',
                  decoration: TextDecoration.none,
                )),
            Text(userModel.email,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontFamily: 'Lato',
                  decoration: TextDecoration.none,
                )),
          ],
        )
      ],
    );
  }
}
