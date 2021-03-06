import 'package:flutter/cupertino.dart';

class ModelComment {
  final String cid;
  final String dateTimeNow;
  final String content;
  int likes;

  ModelComment({
    @required this.cid,
    @required this.dateTimeNow,
    @required this.content,
    this.likes,
  });
}
