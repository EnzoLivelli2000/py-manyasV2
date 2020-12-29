import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manyas_v2/User/model/user_model.dart';

class UserInfo extends StatelessWidget {
  UserModel userModel;
  UserInfo({Key key, this.userModel});
  @override
  Widget build(BuildContext context) {
    final userPhoto = Container(
      width: 90.0,
      height: 90.0,
      margin: EdgeInsets.only(right: 20.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          shape: BoxShape.rectangle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(userModel.photoURL),
            //image: NetworkImage(user.photoURL),
          )
      ),
    );
    final userInfo = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
          Container(
             /* margin: EdgeInsets.only(
                  bottom: 5.0
              ),*/
              padding: new EdgeInsets.only(right: 13.0),
              child: Expanded(
                child: Text(
                    //userModel.name.length > 11? '${userModel.name.substring(0,15)} ...': userModel.name,
                    userModel.name,
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
              )
          ),
        Text(
            userModel.email,
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
            children: <Widget>[
              Text(
                  '${userModel.followers.toString()} Friends',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black26,
                    fontFamily: 'Lato',
                    decoration: TextDecoration.none,
                  )
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
