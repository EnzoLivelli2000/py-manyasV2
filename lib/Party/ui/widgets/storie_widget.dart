import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:manyas_v2/Post/model/post_model.dart';
import 'package:manyas_v2/User/model/user_model.dart';

class StorieWidget extends StatelessWidget {
  UserModel userModel;

  StorieWidget(this.userModel);

  @override
  Widget build(BuildContext context) {
    final photoCard = Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 15, left: 15),
      height: 220.0,
      //width: 350,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: CachedNetworkImageProvider(userModel.photoURL),
        ),
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
    );

    return Container(
      margin: EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          top: 10.0
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
             photoCard,
            ],
          ),
        ],
      ),
    );
  }
}
