import 'package:bloc_provider/bloc_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manyas_v2/User/bloc/user_bloc.dart';
import 'package:manyas_v2/User/model/user_model.dart';
import 'package:manyas_v2/User/ui/screens/profile_screen.dart';
import 'package:manyas_v2/screens/button_navigation_bar_principal_menu.dart';
import 'package:manyas_v2/screens/login_screen_with_email_password.dart';
import 'package:manyas_v2/widgets/background1.dart';
import 'package:manyas_v2/widgets/background2.dart';
import 'package:manyas_v2/widgets/button_orange.dart';
import 'package:manyas_v2/widgets/button_white.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  Widget build(BuildContext context) {
    UserBloc userBloc = BlocProvider.of(context);
    return StreamBuilder(
      stream: userBloc.authStatus,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(!snapshot.hasData || snapshot.hasError){
          return signInGoogleUI(userBloc);
        }else{
          return ButtonNavigationBarPrincipalMenu();
        }
      },
    );
  }

  Widget signInGoogleUI(UserBloc userBloc) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Background1(),
          ListView(children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 50, bottom: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    'Get Started',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    'Start with signing up or sign in',
                    style: TextStyle(
                      fontFamily: 'Lato',
                      color: Color(0xFFFFEDE6),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Container(
                child: Image(
                  image: AssetImage('assets/images/login_image.png'),
                  height: 240,
                ),
              ),
            ),
            Center(
              child: Column(
                children: <Widget>[
                  ButtonOrange(
                    titleButton: 'Sign in with Google',
                    onPressed: () async {
                      print('se presionó -> Sign in with Google ');
                      await userBloc.signIn().then((UserCredential userC) {
                        userBloc.updateUserData(UserModel(
                          uid: userC.user.uid,
                          name: userC.user.displayName,
                          email: userC.user.email,
                          photoURL: userC.user.photoURL,
                          followers: 0
                        ));
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) => ButtonNavigationBarPrincipalMenu()));
                      }
                      ).catchError((e) => print('El error al hacer Sign in with Google -> ${e.toString()}'));
                    },
                    width: 230,
                    height: 70,
                  ),
                  ButtonWhite(
                    titleButton:'Sign up',
                    onPressed: (){
                      print('se presionó -> Sign up ');
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) => LoginScreenWithEmailPassword()));
                      },
                    width: 230,
                    height: 70,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 90),
                    child: Text(
                      'Forgot your account ?',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ])
        ],
      ),
    );
  }
}
