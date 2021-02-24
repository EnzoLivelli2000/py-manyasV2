import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:manyas_v2/User/model/user_model.dart';
import 'package:manyas_v2/User/ui/widgets/button_bar.dart';
import 'package:manyas_v2/User/ui/widgets/choose_post.dart';
import 'package:manyas_v2/User/ui/widgets/user_info.dart';

class StorieWidget extends StatelessWidget {
  UserModel userModel;
  int indexTap;

  StorieWidget({Key key, this.userModel, this.indexTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: 50.0
          ),
          child: Row(
            children: [
              Text(
                'Home',
                style: TextStyle(
                  fontFamily: 'Lato',
                  color: Color(0xFFF87125),
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
        showProfileData(userModel, indexTap),
      ],
    );
  }
}

Widget showProfileData(UserModel userModel, int indexTap) {
  final title = Text(
    'Home',
    style: TextStyle(
      fontFamily: 'Lato',
      color: Color(0xFFF87125),
      fontWeight: FontWeight.bold,
      fontSize: 30,
      decoration: TextDecoration.none,
    ),
  );

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
        )),
  );

  return Container(
      margin: EdgeInsets.only(
        left: 20.0,
        top: 10.0,
        bottom: 20,
      ),
      height: 90,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        padding: new EdgeInsets.symmetric(vertical: 8.0),
        children: <Widget>[
          userPhoto,
          userPhoto,
          userPhoto,
          userPhoto,
          userPhoto,
        ],
      ));
}

/*
Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            title
            //TODO acá posiblemente vaya más funciones a future
          ],
        ),
        ListView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          padding: new EdgeInsets.symmetric(vertical: 8.0),
          children: [
            userPhoto,
          ],
        )
      ],
    ),
 */

/*class StorieWidget extends StatelessWidget {
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
          image: AssetImage('images/heart.png'),
          //image: CachedNetworkImageProvider(userModel.photoURL),
        ),
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
    );

    return Container(
      margin: EdgeInsets.only(
          bottom: 10,
          top: 10.0
      ),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 4,
        itemBuilder: (BuildContext buildContext, int index) {
          return ListTile(
            leading: photoCard,
          );
        }
      )
    );
  }
}*/
