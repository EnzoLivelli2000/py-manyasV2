import 'package:bloc_provider/bloc_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manyas_v2/User/bloc/user_bloc.dart';
import 'package:manyas_v2/User/model/user_model.dart';

class SearchPerson extends StatefulWidget {
  String controllerFilterProduct;

  SearchPerson({Key key, this.controllerFilterProduct});

  @override
  _SearchPersonState createState() => _SearchPersonState();
}

class _SearchPersonState extends State<SearchPerson> {
  UserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);
    return StreamBuilder(
        stream: userBloc.peopleStream,
        builder: (context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            //print("-> ${snapshot.data.documents}");
              return ListView(
                children: userBloc.filterAllUsers(snapshot.data.documents, widget.controllerFilterProduct),
              );
            case ConnectionState.done:
              return ListView(
                children: userBloc.filterAllUsers(snapshot.data.documents, widget.controllerFilterProduct),
              );
            default:
              return Center(child: CircularProgressIndicator());
          }
        },
      );
  }
}
