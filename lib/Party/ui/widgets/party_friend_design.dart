//import 'dart:html';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:like_button/like_button.dart';
import 'package:manyas_v2/Party/model/party_model.dart';
import 'package:manyas_v2/Post/model/post_model.dart';
import 'package:manyas_v2/User/bloc/user_bloc.dart';
import 'package:manyas_v2/User/model/user_model.dart';

class PartyFriendDesign extends StatefulWidget {
  PartyModel partyModel;
  UserModel userModel;

  PartyFriendDesign(this.partyModel, this.userModel);

  @override
  _PartyFriendDesignState createState() => _PartyFriendDesignState();
}

class _PartyFriendDesignState extends State<PartyFriendDesign> {
  UserBloc userBloc;
  bool colorLikeButton = false;
  int countLikes;
  bool isLikedX = false;
  String address = '';
  final String PARTIES = 'parties';


  Future<bool> onLikeButtonTapped(bool isLikedX) async{
    String uidCurrentUser = await FirebaseAuth.instance.currentUser.uid;
    await userBloc.updateLikeData(PARTIES, widget.partyModel.pid, isLikedX, uidCurrentUser);

    return !isLikedX;
  }

  void getColorLikeButton(){
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _asyncColorLikeButton();
    });
  }

  void getLengthLike(){
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _asyncLengthLike();
    });
  }

  void convertGeoPointToAddress(){
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _asyncAddress();
    });
  }

  _asyncColorLikeButton() async{
    String uidCurrentUser = await FirebaseAuth.instance.currentUser.uid;
    bool aux = await userBloc.ColorLikeButton(PARTIES, widget.partyModel.pid, uidCurrentUser);

    if(aux == null){
      if (mounted) {
        setState(() {
          colorLikeButton = false;
        });
      }
    }else{

      if (mounted) {
        setState(() {
          colorLikeButton = aux;
        });
      }
    }
  }

  _asyncLengthLike() async{
    int aux = await userBloc.LengthLikes(PARTIES, widget.partyModel.pid);
    if (mounted) {
      setState(() {
        countLikes = aux;
      });
    }
  }

  _asyncAddress()async{
    //print('latitude ${widget.partyModel.Partylocation.latitude} - longitude ${widget.partyModel.Partylocation.longitude}');
    //Coordinates coordinates = Coordinates(widget.partyModel.Partylocation.latitude, widget.partyModel.Partylocation.longitude);

    final latitude = widget.partyModel.Partylocation.latitude.toDouble();
    final longitude =widget.partyModel.Partylocation.longitude.toDouble();

    print('latitude $latitude - longitude $longitude');

    final coordinates = new Coordinates(latitude, longitude );

    var aux = await Geocoder.local.findAddressesFromCoordinates(coordinates);

      setState(() {
        address = aux.first.addressLine;
      });

  }

  @override
  void initState() {
    // TODO: implement initState
    convertGeoPointToAddress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getColorLikeButton();
    getLengthLike();
    userBloc = BlocProvider.of<UserBloc>(context);


    final userData = Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 15, left: 15),
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
                  image: NetworkImage(widget.userModel.photoURL),
                  //image: AssetImage('assets/images/post_photo.PNG')
                )),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  widget.userModel.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Lato',
                    decoration: TextDecoration.none,
                  )),
              Text( widget.partyModel.dateTimeNow.toString()
                  .substring(0,10),
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontFamily: 'Lato',
                    decoration: TextDecoration.none,
                  )),
            ],
          )
        ],
      ),
    );

    final photoCard = Stack(
      //margin: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 15, left: 15),
      children: <Widget>[
        Container(
          //padding: EdgeInsets.only(top:MediaQuery.of(context).size.height),
          height: 220.0,
          //width: 350,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              //image: CachedNetworkImageProvider(widget.partyModel.V_I),
              image: NetworkImage(widget.partyModel.V_I),
            ),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [userData],
            ),
            Container(
              margin: EdgeInsets.only(left: 15, top: 110, right: 25),
              child: Row(
                //crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.partyModel.title,
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Lato',
                        decoration: TextDecoration.none,
                      )),
                  Image(
                    image: AssetImage('assets/images/limite-de-edad.png'),
                    height: 30,
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );

    final contentPost = Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 25, left: 25),
          alignment: AlignmentDirectional.bottomStart,
          child: Text(widget.partyModel.description,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                fontFamily: 'Lato',
                decoration: TextDecoration.none,
              )),
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                  margin: EdgeInsets.only(bottom: 6.0, right: 20, left: 20),
                  //alignment: AlignmentDirectional.bottomStart,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top:5,bottom:5),
                            child: Icon(Icons.calendar_today,
                                color: Colors.grey),
                          ),
                          Text(
                            widget.partyModel.Partydate,
                            style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              fontFamily: 'Lato',
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top:5,bottom:5),
                            child: Icon(
                              Icons.location_on,
                              color: Colors.grey,
                            ),
                          ),
                          Container(
                            child: Expanded(child:Text(address,
                                style: TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  fontFamily: 'Lato',
                                  decoration: TextDecoration.none,
                                )),)
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top:5,bottom:5),
                            child: Icon(
                              Icons.access_time,
                              color: Colors.grey,
                            ),
                          ),
                          Text(widget.partyModel.PartyTime,
                              style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                fontFamily: 'Lato',
                                decoration: TextDecoration.none,
                              )),
                        ],
                      ),
                    ],
                  )),
            ),
            /*Container(
              child: Image(
                image: AssetImage('assets/images/chelas.PNG'),
                height: 120,
              ),
            ),*/
          ],
        )
      ],
    );

    final likes_comments = Container(
      margin: EdgeInsets.only(bottom: 10.0, left: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: colorLikeButton != false
                      ? Color(0xFFF87125)
                      : Colors.grey,
                ),
                onPressed: () async {
                  print('se presionó el nuevo botón de LIKE');
                  await onLikeButtonTapped(isLikedX);
                  //await getLengthLike();
                  print('El valor de like (SALIDA) ${isLikedX}');
                },
              ),
              Text('${countLikes}'),
              IconButton(
                onPressed: () {
                  print('se presionó el botón de commnent');
                },
                icon: Icon(
                  Icons.comment,
                  color: Color(0xFFF87125),
                ),
              ),
              Text('0'),
            ],
          ),
        ],
      ),
    );

    return Container(
      margin: EdgeInsets.only(top: 30.0, bottom: 10.0, right: 15, left: 15),
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
          photoCard,
          contentPost,
          likes_comments,
        ],
      ),
    );
  }
}
