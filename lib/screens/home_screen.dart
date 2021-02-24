import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manyas_v2/Party/ui/screens/prueba_party.dart';
import 'package:manyas_v2/Party/ui/widgets/storie_widget.dart';
import 'package:manyas_v2/Storie/ui/screens/prueba_storie.dart';
import 'package:manyas_v2/User/bloc/user_bloc.dart';
import 'package:manyas_v2/User/model/user_model.dart';
import 'package:manyas_v2/User/ui/screens/profile_header.dart';
import 'package:manyas_v2/screens/home_content.dart';
import 'package:manyas_v2/widgets/background3.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserBloc userBloc;
  int indexTap = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void onTapTapped(int index) {
    setState(() {
      indexTap = index;
    });
  }

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
            return showProfileData(snapshot);

          case ConnectionState.done:
            return showProfileData(snapshot);

          default:
        }
      },
    );
  }

  Widget showProfileData(AsyncSnapshot snapshot) {
    if (!snapshot.hasData || snapshot.hasError) {
      print('No logueado');
      return Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[Text('Usuario no logueado. Haz Login')],
          ),
        ],
      );
    } else {
      print('Logueado');

      var userAux = UserModel(
        uid: snapshot.data.uid,
        name: snapshot.data.displayName,
        email: snapshot.data.email,
        photoURL: snapshot.data.photoUrl,
        // followers: snapshot.data.followers,
      );

      return Stack(children: <Widget>[
        ListView(
          children: <Widget>[
            StorieWidget(userModel: userAux, indexTap: indexTap),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 30),
                  child: GestureDetector(
                    onTap: () {
                      onTapTapped(0);
                      print('se solicita crear un post');
                    },
                    child: Text(
                      'Post',
                      style: TextStyle(
                        fontSize: 19.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Lato',
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 35, left: 40, bottom: 30),
                  child: GestureDetector(
                    onTap: () {
                      onTapTapped(1);
                      print('se solicita crear un Stories');
                    },
                    child: Text(
                      'Storie',
                      style: TextStyle(
                        fontSize: 19.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Lato',
                        decoration: TextDecoration.none,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 30),
                  child: GestureDetector(
                      onTap: () {
                        onTapTapped(2);
                        print('se solicita crear un Event´s');
                      },
                      child: Text('Event',
                          style: TextStyle(
                            fontSize: 19.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'Lato',
                            decoration: TextDecoration.none,
                          ))),
                ),
              ],
            ),
            HomeContent(userAux, indexTap),
          ],
        )
      ]);
    }
  }

}
