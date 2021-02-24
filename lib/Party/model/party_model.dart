import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class PartyModel{
  final String dateTimeNow;
  final String Partydate;
  final GeoPoint Partylocation;
  final String PartyTime;
  final String title;
  final String description;
  final String V_I;
  final String Userlocation;
  final String price; // eseto luego lo convertimos a INT
  final bool isAdult;
  final codeParty;
  bool status;
  int likes;
  String pid;
  //String userOwner;

  PartyModel({
    @required this.dateTimeNow,
    @required this.Partydate,
    @required this.Partylocation,
    @required this.PartyTime,
    @required this.title,
    @required this.description,
    @required this.V_I,
    @required this.Userlocation,
    @required this.price,
    @required this.isAdult,
    @required this.codeParty,
    this.status,
    this.likes,
    this.pid,
  });

}