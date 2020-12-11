import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manyas_v2/Post/model/post_model.dart';
import 'package:manyas_v2/User/model/user_model.dart';

class PostDesign extends StatelessWidget {
  PostModel postModel;
  UserModel userModel;

  PostDesign(this.postModel, this.userModel);

  @override
  Widget build(BuildContext context) {
    final photoCard = Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 30, left: 30),
      height: 220.0,
      //width: 350,
      decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(postModel.V_I),
          ),
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          color: Colors.red,
          /*boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black38,
                blurRadius: 10.0,
                offset: Offset(0.0, 5.0))
          ]),*/
      ),
    );

    final userData = Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 30, left: 30),
      child: Row(
        children: <Widget>[
          Container(
            width: 50.0,
            height: 50.0,
            margin: EdgeInsets.only(right: 8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                shape: BoxShape.rectangle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(userModel.photoURL),
                  //image: NetworkImage(user.photoURL),
                )),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userModel.name,
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Lato',
                    decoration: TextDecoration.none,
                  )),
              Text(postModel.lastTimePost,
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black26,
                    fontFamily: 'Lato',
                    decoration: TextDecoration.none,
                  )),
            ],
          )
        ],
      ),
    );

    final contentPost = Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 30, left: 30),
      child: Text(postModel.content,
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            fontFamily: 'Lato',
            decoration: TextDecoration.none,
          )),
    );

    final likes_comments = Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 30, left: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          FlatButton.icon(
              onPressed: () {
                print('se presionó el botón de like');
              },
              icon: Icon(
                Icons.favorite_border,
                color: Color(0xFFF87125),
              ),
              label: Text(postModel.likes.toString())),
          FlatButton.icon(
              onPressed: () {
                print('se presionó el botón de commnent');
              },
              icon: Icon(
                Icons.comment,
                color: Color(0xFFF87125),
              ),
              label: Text(postModel.comment.toString())),
        ],
      ),
    );

    return Container(
      margin: EdgeInsets.only(top: 80.0, bottom: 10.0, right: 30, left: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          userData,
          photoCard,
          contentPost,
          likes_comments,
        ],
      ),
    );
  }
}
