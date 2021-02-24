import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:manyas_v2/Map/ui/screens/example2/maps_screen.dart';
import 'package:manyas_v2/User/bloc/user_bloc.dart';
import 'package:manyas_v2/User/model/user_model.dart';

class JoinScreen extends StatefulWidget {

  @override
  _JoinScreenState createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final partyNumberController = TextEditingController();
  UserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);

    return StreamBuilder(
      stream: userBloc.authStatus,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            );
          case ConnectionState.none:
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            );
          case ConnectionState.active:
            return _scaffold(snapshot);
          case ConnectionState.done:
            return _scaffold(snapshot);
          default:
        }
      },
    );
  }

  Widget _scaffold(AsyncSnapshot snapshot) {
    var userAux = UserModel(
      uid: snapshot.data.uid,
      name: snapshot.data.displayName,
      email: snapshot.data.email,
      photoURL: snapshot.data.photoUrl,
      // followers: snapshot.data.followers,
    );

    return Scaffold(
        appBar: AppBar(
          title: Text('See you Here'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: partyNumberController,
                decoration: InputDecoration(
                  hintText: 'Party number',
                ),
              ),
              RaisedButton(
                  child: Text('Go'),
                  onPressed: () {
                    Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) =>MapsScreen(
                        partyNumber: partyNumberController.text,
                      userId: userAux.uid,
                      ),
                    ),
                    );
                  }),
            ],
          ),
        )
    );
  }
}
