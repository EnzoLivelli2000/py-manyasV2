import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:manyas_v2/User/bloc/user_bloc.dart';
import 'package:manyas_v2/User/model/user_model.dart';
import 'package:manyas_v2/User/ui/screens/profile_content.dart';
import 'package:manyas_v2/User/ui/screens/profile_header.dart';
import 'package:manyas_v2/User/ui/widgets/button_bar.dart';
import 'package:manyas_v2/User/ui/widgets/choose_post.dart';
import 'package:manyas_v2/widgets/background3.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int indexTap = 0;
  UserBloc userBloc;

  void onTapTapped(int index) {
    setState(() {
      indexTap = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Center(child: Text('Usuario no logueado. Haz Login', style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'Lato',
              decoration: TextDecoration.none,
            ),))],
          )
        ],
      );
      return Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              Center(child: Text('Usuario no logueado. Haz Login'))
            ],
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
        Background3(),
        ListView(
          children: <Widget>[
            ProfileHeader(userModel: userAux, indexTap: indexTap),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 40),
                  child: GestureDetector(
                    onTap: () {
                      onTapTapped(0);
                      print('se solicita mostrar los post´s');
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
                  margin: EdgeInsets.only(right: 35, left: 40, bottom: 40),
                  child: GestureDetector(
                    onTap: () {
                      onTapTapped(1);
                      print('se solicita mostrar los Stories');
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
                  margin: EdgeInsets.only(bottom: 40),
                  child: GestureDetector(
                      onTap: () {
                        onTapTapped(2);
                        print('se solicita mostrar las Event´s');
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
            ProfileContent(userAux, indexTap),
          ],
        )
      ]);
    }
  }
}
