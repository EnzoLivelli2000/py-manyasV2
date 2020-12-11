import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manyas_v2/User/ui/screens/profile_screen.dart';
import 'package:manyas_v2/widgets/background1.dart';
import 'package:manyas_v2/widgets/background2.dart';
import 'package:manyas_v2/widgets/button_orange.dart';
import 'package:manyas_v2/widgets/button_white.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                    titleButton:'Sign in with Google',
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
                      print('se presionó -> Sign in with Google ');
                      },
                    width: 230,
                    height: 70,
                  ),
                  /*ButtonWhite(
                    titleButton:'Sign up',
                    onPressed: (){print('se presionó -> Sign up ');},
                    width: 230,
                    height: 70,
                  ),*/
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
