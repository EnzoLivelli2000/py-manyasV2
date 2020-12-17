import 'package:flutter/cupertino.dart';

class PostModel {
  final String description;

  //final String lastTimePost;
  final String V_I;
  final String location;
  /*final String user_liked_id;
  final String user_owner_id;*/

  bool status;
  int likes;
  String pid;

  PostModel({
      @required this.description,
      @required this.location,
      @required this.V_I,
      this.likes,
      this.status,
      this.pid
      //this.lastTimePost,
      /*this.user_liked_id,
      this.user_owner_id*/
  });
}
