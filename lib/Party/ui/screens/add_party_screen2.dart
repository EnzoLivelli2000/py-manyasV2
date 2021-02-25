import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:manyas_v2/Party/model/party_model.dart';
import 'package:manyas_v2/Post/model/post_model.dart';
import 'package:manyas_v2/Post/ui/widgets/card_image.dart';
import 'package:manyas_v2/User/bloc/user_bloc.dart';
import 'package:manyas_v2/User/ui/screens/profile_screen.dart';
import 'package:manyas_v2/widgets/background1.dart';
import 'file:///C:/Users/USUARIO/AndroidStudioProjects/py-manyas-RicardoMarkiewicz/lib/widgets/buttons/button_orange.dart';
import 'package:manyas_v2/widgets/number_input.dart';
import 'package:manyas_v2/widgets/text_input.dart';
import 'package:manyas_v2/widgets/title_header.dart';
import 'package:manyas_v2/widgets/title_input_location.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddPartyScreen2 extends StatefulWidget {
  File image;
  String controllerTitleParty;
  String controllerDescriptionParty;

  //bool fullSize = false;
  var partyNumber;
  GeoPoint target; //ESTO VIENE A SER LOCATION PARTY

  AddPartyScreen2(
      {Key key,
      @required this.image,
      @required this.controllerTitleParty,
      @required this.controllerDescriptionParty,
      @required this.partyNumber,
      @required this.target});

  @override
  _AddPartyScreen2State createState() => _AddPartyScreen2State();
}

class _AddPartyScreen2State extends State<AddPartyScreen2> {
  final _controllerDateParty = TextEditingController();
  final _controllerTimesParty = TextEditingController();
  final _controllerPriceParty = TextEditingController();
  bool _controllerIsAdultPost = false;
  bool onlyOneClick = false;
  ValueNotifier valueNotifier = ValueNotifier('Add a Party');

  @override
  Widget build(BuildContext context) {
    UserBloc userBloc = BlocProvider.of<UserBloc>(context);

    if (widget.image.path == null) {
      print('Entro a widget.image.path == null');
      Navigator.of(context).pop();
    } else {
      return Scaffold(
        body: Stack(
          children: <Widget>[
            Background1(),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 25, left: 5),
                    child: SizedBox(
                      height: 45.0,
                      width: 45.0,
                      child: IconButton(
                        icon: Icon(
                          Icons.keyboard_arrow_left,
                          color: Colors.white,
                          size: 45,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                  Flexible(
                      child: Container(
                    padding: EdgeInsets.only(top: 35, left: 20, right: 10),
                    child: TitleHeader(
                      title: 'Add a new Party',
                    ),
                  )),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 60),
              child: ListView(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(top: 30.0, bottom: 10.0),
                      child: NunberInput(
                        hintText: 'Date Party: Example(12/09/2021)',
                        inputType: TextInputType.multiline,
                        maxLines: 1,
                        controller: _controllerDateParty,
                        textLimiting: 10,
                      )),
                  Container(
                      margin: EdgeInsets.only(top: 25.0, bottom: 10.0),
                      child: NunberInput(
                        hintText: 'Time´s Party: Example(23:00)',
                        inputType: TextInputType.multiline,
                        maxLines: 1,
                        controller: _controllerTimesParty,
                        textLimiting: 5,
                      )),
                  Container(
                      margin: EdgeInsets.only(top: 25.0, bottom: 60.0),
                      child: NunberInput(
                        hintText: 'Price: Example(50.00)',
                        inputType: TextInputType.multiline,
                        maxLines: 1,
                        controller: _controllerPriceParty,
                        textLimiting: 10,
                      )),
                  Container(
                      margin: EdgeInsets.only(
                          top: 10.0, bottom: 10.0, right: 25, left: 25),
                      child: Text(
                        'Es un hecho establecido desde hace mucho tiempo que un lector se distraerá con el contenido legible de una página cuando mire su diseño. El objetivo de usar Lorem Ipsum es que tiene una distribución de letras más o menos normal, ',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'Lato',
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  Container(
                      margin: EdgeInsets.only(
                          top: 10.0, bottom: 10.0, right: 25, left: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Image(
                            image:
                                AssetImage('assets/images/limite-de-edad.png'),
                            height: 50,
                          ),
                          CupertinoSwitch(
                            value: _controllerIsAdultPost,
                            //activeColor: Colors.orange,
                            trackColor: Colors.redAccent,
                            onChanged: (value) {
                              setState(() {
                                _controllerIsAdultPost = value;
                              });
                            },
                          ),
                        ],
                      )),
                  Container(
                    child: ValueListenableBuilder(
                      valueListenable: valueNotifier,
                      builder: (context, value, child) {
                        return ButtonOrange(
                          titleButton: value,
                          onPressed: () {
                            if (!onlyOneClick) {
                              valueNotifier.value = ' Loading ...';
                              String uid;
                              String path;
                              userBloc.currentUser().then((User user) => {
                                    if (user != null)
                                      {
                                        uid = user.uid,
                                        path =
                                            "${uid}/${DateTime.now().toString()}.jpg",
                                        //1. Firebase Storage
                                        userBloc
                                            .uploadFile(path, widget.image)
                                            .then((StorageUploadTask
                                                storageUploadTask) {
                                          storageUploadTask.onComplete.then(
                                              (StorageTaskSnapshot snapshot) {
                                            snapshot.ref
                                                .getDownloadURL()
                                                .then((urlImage) {
                                              print('URL_IMAGE: ${urlImage}');
                                              //2. Cloud Firestore
                                              userBloc
                                                  .updatePartyData(
                                                      PartyModel(
                                                        dateTimeNow:
                                                            DateTime.now()
                                                                .toString(),
                                                        Partydate:
                                                            _controllerDateParty
                                                                .text,
                                                        PartyTime:
                                                            _controllerTimesParty
                                                                .text,
                                                        title: widget
                                                            .controllerTitleParty,
                                                        description: widget
                                                            .controllerDescriptionParty,
                                                        V_I: urlImage,
                                                        Userlocation:
                                                            'esto hay que ver aún',
                                                        price:
                                                            _controllerPriceParty
                                                                .text,
                                                        isAdult:
                                                            _controllerIsAdultPost,
                                                        likes: 0,
                                                        status: true,
                                                      ),
                                                      widget.partyNumber,
                                                      widget.target)
                                                  .whenComplete(() {
                                                print('Proceso terminado');
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) {
                                                    return CupertinoTabView(
                                                        builder: (BuildContext
                                                            context) {
                                                      return BlocProvider<
                                                          UserBloc>(
                                                        creator:
                                                            (_context, _bag) =>
                                                                UserBloc(),
                                                        child: ProfileScreen(),
                                                      );
                                                    });
                                                  },
                                                ));
                                              });
                                            });
                                          });
                                        })
                                      }
                                  });
                            } else {
                              print(
                                  'Solo presione una vez el boton de subir foto maldito malparido :)');
                              Text('Cargando Imagen');
                            }
                            print('se presionó -> Subir post ');
                          },
                          width: 70,
                          height: 70,
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            //addPost(context,_controllerDescriptionPost),
          ],
        ),
      );
    }
  }
}
