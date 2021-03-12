import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manyas_v2/Comment/model/model_comment.dart';
import 'package:manyas_v2/User/model/user_model.dart';

class OtherCommentWidget extends StatelessWidget {
  UserModel userModel;
  String commentContent;
  String dateTimeNow;

  OtherCommentWidget({@required this.userModel, @required this.commentContent, @required this.dateTimeNow});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            //alignment: ,
            width: 50.0,
            height: 50.0,
            margin: EdgeInsets.only(top: 15.0, bottom: 15.0, right: 8, left: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                shape: BoxShape.rectangle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(userModel.photoURL),
                  //image: AssetImage('assets/images/post_photo.PNG')
                )),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 15.0, bottom: 15.0, right: 10, left: 8),
              //alignment: Alignment.topCenter,
              child: Text(commentContent,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontFamily: 'Lato',
                    decoration: TextDecoration.none,
                  )),
            ),
          ),
          Container(
            margin: EdgeInsets.only( right: 10, left: 8),
            child: Text( dateTimeNow.toString()
                .substring(0,10),
                style: TextStyle(
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontFamily: 'Lato',
                  decoration: TextDecoration.none,
                )),
          )
        ],
      ),
    );
  }
}
