import 'package:bloc_provider/bloc_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manyas_v2/Party/ui/screens/prueba_party.dart';
import 'package:manyas_v2/Party/ui/widgets/party_friend_design.dart';
import 'package:manyas_v2/Post/model/post_model.dart';
import 'package:manyas_v2/Post/ui/widgets/card_image.dart';
import 'package:manyas_v2/Post/ui/widgets/post_design.dart';
import 'package:manyas_v2/Post/ui/widgets/post_friend_design.dart';
import 'package:manyas_v2/Storie/ui/screens/prueba_storie.dart';
import 'package:manyas_v2/User/bloc/user_bloc.dart';
import 'package:manyas_v2/User/model/user_model.dart';

class HomeContent extends StatelessWidget {
  UserBloc userBloc;
  UserModel userModel;
  int index;

  HomeContent(this.userModel, this.index);

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);
    switch (index) {
      case 0:
        return PostContent();
        break;
      case 1:
        return PruebaStorie();
        break;
      case 2:
        return PartyContent();
        break;
    }
  }

  Widget PostContent() {
    return StreamBuilder(
      stream: userBloc.myFriendsListStream,
      builder: (context, AsyncSnapshot<List<DocumentReference>> snapshot) {
        final users = snapshot.data ?? [];
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container(
              margin: EdgeInsets.only(top: 120),
              alignment: Alignment.center,
              child: Text(
                'Loading ...',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          case ConnectionState.none:
            return Container(
              margin: EdgeInsets.only(top: 120),
              alignment: Alignment.center,
              child: Text(
                'Loading ...',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          case ConnectionState.done:
            print('snapshot -> ${snapshot}');
            return ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: 1,
              itemBuilder: (_, i){
                return FutureBuilder<List<PostFriendDesign>>(
                  future: userBloc.buildPosts(users, userModel), // function where you call your api
                  builder: (BuildContext context, AsyncSnapshot<List<PostFriendDesign>> snapshot) {  // AsyncSnapshot<Your object type>
                    if( snapshot.connectionState == ConnectionState.waiting){
                      return Container(
                        margin: EdgeInsets.only(top: 120),
                        alignment: Alignment.center,
                        child: Text(
                          'Just a minute please!',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25.0,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }else{
                      if (snapshot.hasError)
                        return Container(
                          margin: EdgeInsets.only(top: 120),
                          alignment: Alignment.center,
                          child: Text(
                            'Ups, ocurrió un error',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25.0,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      else {
                        return Column(
                          children: snapshot.data,
                        );
                      }
                    }
                  },
                );
              },
            );
            break;
          case ConnectionState.active:
            print('snapshot -> ${snapshot}');
            return ListView.builder(
              itemCount: 1,
              itemBuilder: (_, i){
                return FutureBuilder<List<PostFriendDesign>>(
                  future: userBloc.buildPosts(users, userModel), // function where you call your api
                  builder: (BuildContext context, AsyncSnapshot<List<PostFriendDesign>> snapshot) {  // AsyncSnapshot<Your object type>
                    if( snapshot.connectionState == ConnectionState.waiting){
                      return Container(
                        margin: EdgeInsets.only(top: 120),
                        alignment: Alignment.center,
                        child: Text(
                          'Just a minute please!',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25.0,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }else{
                      if (snapshot.hasError)
                        return Container(
                          margin: EdgeInsets.only(top: 120),
                          alignment: Alignment.center,
                          child: Text(
                            'Ups, ocurrió un error',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25.0,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      else {
                        return Column(
                          children: snapshot.data.toList(),
                        );
                      }
                    }
                  },
                );
              },
            );
            break;
          default:
            return CircularProgressIndicator();
        }
      },
    );
  }

  Widget PartyContent() {
    return StreamBuilder(
      stream: userBloc.myFriendsListStream,
      builder: (context, AsyncSnapshot<List<DocumentReference>> snapshot) {
        final users = snapshot.data ?? [];
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container(
              margin: EdgeInsets.only(top: 120),
              alignment: Alignment.center,
              child: Text(
                'Loading ...',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          case ConnectionState.none:
            return Container(
              margin: EdgeInsets.only(top: 120),
              alignment: Alignment.center,
              child: Text(
                'Loading ...',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          case ConnectionState.done:
            print('snapshot -> ${snapshot}');
            return ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: 1,
              itemBuilder: (_, i){
                return FutureBuilder<List<PartyFriendDesign>>(
                  future: userBloc.buildParties(users, userModel), // function where you call your api
                  builder: (BuildContext context, AsyncSnapshot<List<PartyFriendDesign>> snapshot) {  // AsyncSnapshot<Your object type>
                    if( snapshot.connectionState == ConnectionState.waiting){
                      return Container(
                        margin: EdgeInsets.only(top: 120),
                        alignment: Alignment.center,
                        child: Text(
                          'Just a minute please!',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25.0,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }else{
                      if (snapshot.hasError)
                        return Container(
                          margin: EdgeInsets.only(top: 120),
                          alignment: Alignment.center,
                          child: Text(
                            'Ups, ocurrió un error',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25.0,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      else {
                        return Column(
                          children: snapshot.data,
                        );
                      }
                    }
                  },
                );
              },
            );
            break;
          case ConnectionState.active:
            print('snapshot -> ${snapshot}');
            return ListView.builder(
              itemCount: 1,
              itemBuilder: (_, i){
                return FutureBuilder<List<PartyFriendDesign>>(
                  future: userBloc.buildParties(users, userModel), // function where you call your api
                  builder: (BuildContext context, AsyncSnapshot<List<PartyFriendDesign>> snapshot) {  // AsyncSnapshot<Your object type>
                    if( snapshot.connectionState == ConnectionState.waiting){
                      return Container(
                        margin: EdgeInsets.only(top: 120),
                        alignment: Alignment.center,
                        child: Text(
                          'Just a minute please!',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25.0,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }else{
                      if (snapshot.hasError)
                        return Container(
                          margin: EdgeInsets.only(top: 120),
                          alignment: Alignment.center,
                          child: Text(
                            'Ups, ocurrió un error',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25.0,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      else {
                        return Column(
                          children: snapshot.data.toList(),
                        );
                      }
                    }
                  },
                );
              },
            );
            break;
          default:
            return CircularProgressIndicator();
        }
      },
    );
  }
}
