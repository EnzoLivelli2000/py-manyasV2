import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manyas_v2/Party/ui/screens/add_party_screen2.dart';
import 'package:manyas_v2/Post/model/post_model.dart';
import 'package:manyas_v2/Post/ui/widgets/card_image.dart';
import 'package:manyas_v2/User/bloc/user_bloc.dart';
import 'package:manyas_v2/widgets/background1.dart';
import 'package:manyas_v2/widgets/button_orange.dart';
import 'package:manyas_v2/widgets/text_input.dart';
import 'package:manyas_v2/widgets/title_header.dart';
import 'package:manyas_v2/widgets/title_input_location.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddPartyScreen1 extends StatefulWidget {
  File image;

  AddPartyScreen1({Key key, @required this.image});

  @override
  _AddPartyScreen1State createState() => _AddPartyScreen1State();
}

class _AddPartyScreen1State extends State<AddPartyScreen1> {
  final _controllerTitleParty = TextEditingController();
  final _controllerDescriptionParty = TextEditingController();
  final _controllerLocationParty = TextEditingController();
  bool fullSize = false;

  @override
  Widget build(BuildContext context) {
    UserBloc userBloc = BlocProvider.of<UserBloc>(context);

    if(widget.image.path == null){
      print('Entro a widget.image.path == null');
      Navigator.of(context).pop();
    }else{
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
                    margin: EdgeInsets.only(top: 30.0, bottom: 10.0, right: 17, left: 17),
                    alignment: Alignment.center,
                    child: CardImageWithFabIcon(
                      pathImage: widget.image.path,
                      iconData: Icons.camera_alt,
                      width: 380.0,
                      height: 250.0,
                      left: 0,
                      internet: false,
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 20.0, bottom: 10.0),
                      child: TextInput(
                        hintText: 'Title',
                        inputType: TextInputType.multiline,
                        maxLines: 1,
                        controller: _controllerTitleParty,
                      )),
                  Container(
                      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: TextInput(
                        hintText: 'Description',
                        inputType: TextInputType.multiline,
                        maxLines: 6,
                        controller: _controllerDescriptionParty,
                      )),
                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: TextInputLocation(
                      hintText: 'Add your party location',
                      iconData: Icons.location_on,
                      controller: _controllerLocationParty,
                    ),
                  ),
                  Container(
                    child: ButtonOrange(
                      titleButton: 'Next',
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) => AddPartyScreen2(image: widget.image,controllerTitleParty: _controllerTitleParty.text,controllerDescriptionParty: _controllerDescriptionParty.text,controllerLocationParty: _controllerLocationParty.text
                            )));
                      },
                      //width: 5,
                      height: 70,
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
