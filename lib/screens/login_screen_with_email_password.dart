import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manyas_v2/Post/model/post_model.dart';
import 'package:manyas_v2/Post/ui/widgets/card_image.dart';
import 'package:manyas_v2/User/bloc/user_bloc.dart';
import 'package:manyas_v2/User/model/user_model.dart';
import 'package:manyas_v2/screens/button_navigation_bar_principal_menu.dart';
import 'package:manyas_v2/widgets/background2.dart';
import 'package:manyas_v2/widgets/button_orange.dart';
import 'package:manyas_v2/widgets/text_input.dart';
import 'package:manyas_v2/widgets/title_header.dart';
import 'package:manyas_v2/widgets/title_input_location.dart';
import 'package:firebase_storage/firebase_storage.dart';

class LoginScreenWithEmailPassword extends StatefulWidget {
  @override
  _LoginScreenWithEmailPasswordState createState() =>
      _LoginScreenWithEmailPasswordState();
}

class _LoginScreenWithEmailPasswordState
    extends State<LoginScreenWithEmailPassword> {
  final _controllerEmail = TextEditingController();
  final _controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserBloc userBloc = BlocProvider.of<UserBloc>(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Background2(),
          Row(
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
                    title: 'Log in !',
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 60, bottom: 20),
            child: ListView(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 30.0, bottom: 10.0),
                    child: TextInput(
                      hintText: 'Email',
                      controller: _controllerEmail,
                    )),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: TextInput(
                    hintText: 'Password',
                    controller: _controllerPassword,
                  ),
                ),
                Container(
                  child: ButtonOrange(
                    titleButton: 'Log in',
                    onPressed: () async {
                      await userBloc
                          .signInEmailPassword(
                              _controllerEmail.text, _controllerPassword.text)
                          .then((UserCredential userC) {
                        userBloc.updateUserData(UserModel(
                          uid: userC.user.uid,
                          name: userC.user.displayName,
                          email: userC.user.email,
                          photoURL: userC.user.photoURL,
                        ));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ButtonNavigationBarPrincipalMenu()));
                      }).catchError((e) => print(
                              'El error al hacer Sign in with Email and Password -> ${e.toString()}'));
                      print('se presionó -> Sign in with Email and Password ');
                    },
                    width: 230,
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
