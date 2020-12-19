import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manyas_v2/Post/model/post_model.dart';
import 'package:manyas_v2/Post/ui/widgets/card_image.dart';
import 'package:manyas_v2/User/bloc/user_bloc.dart';
import 'package:manyas_v2/widgets/background1.dart';
import 'package:manyas_v2/widgets/button_orange.dart';
import 'package:manyas_v2/widgets/text_input.dart';
import 'package:manyas_v2/widgets/title_header.dart';
import 'package:manyas_v2/widgets/title_input_location.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddPostScreen extends StatefulWidget {
  File image;

  AddPostScreen({Key key, @required this.image});

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final _controllerDescriptionPost = TextEditingController();
  final _controllerLocationPost = TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserBloc userBloc = BlocProvider.of<UserBloc>(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Background1(),
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
                  title: 'Add a new Post',
                ),
              )),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 60, bottom: 20),
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
                    margin: EdgeInsets.only(top: 30.0, bottom: 10.0),
                    child: TextInput(
                      hintText: 'Description',
                      inputType: TextInputType.multiline,
                      maxLines: 6,
                      controller: _controllerDescriptionPost,
                    )),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: TextInputLocation(
                    hintText: 'Add your location',
                    iconData: Icons.location_on,
                    controller: _controllerLocationPost,
                  ),
                ),
                Container(
                  child: ButtonOrange(
                    titleButton: 'Add Post',
                    onPressed: () {
                      String uid;
                      String path;
                      userBloc.currentUser().then((User user) => {
                            if (user != null)
                              {
                                uid = user.uid,
                                path = "${uid}/${DateTime.now().toString()}.jpg",
                                //1. Firebase Storage
                                userBloc.uploadFile(path, widget.image).then((StorageUploadTask storageUploadTask){
                                storageUploadTask.onComplete.then((StorageTaskSnapshot snapshot){
                                  snapshot.ref.getDownloadURL().then((urlImage){
                                    print('URL_IMAGE: ${urlImage}');

                                  //2. Cloud Firestore
                                  userBloc.updatePostData(PostModel(
                                    description: _controllerDescriptionPost.text,
                                    location: _controllerLocationPost.text,
                                    V_I : urlImage,
                                    likes: 0,
                                    status: true,
                                    dateTimeid: DateTime.now().toString(),
                                  )).whenComplete(() {
                                    print('Proceso terminado');
                                    Navigator.pop(context);
                                  });

                                });
                            });
                          })
                              }
                          });

                      print('se presionó -> Subir post ');
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
