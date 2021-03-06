import 'package:flutter/material.dart';

class UserCommentWidget extends StatelessWidget {
  final String photoURL;
  final String commentDescription;

  UserCommentWidget({Key key, @required this.photoURL,  @required this.commentDescription});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15.0, bottom: 10.0, right: 10, left: 10),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            //alignment: ,
            width: 50.0,
            height: 50.0,
            margin: EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                shape: BoxShape.rectangle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(photoURL),
                  //image: AssetImage('assets/images/post_photo.PNG')
                )),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 8),
              //alignment: Alignment.topCenter,
              child: Text(commentDescription),
            ),
          ),
        ],
      ),
    );
  }
}
