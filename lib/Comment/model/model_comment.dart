import 'package:flutter/cupertino.dart';

class CommentModel {
  final String dateTimeNow;
  final String content;
  String cid;
  int likes;

  CommentModel({
    @required this.cid,
    @required this.dateTimeNow,
    @required this.content,
    this.likes,
  });
}
