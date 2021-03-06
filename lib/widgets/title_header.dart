import 'package:flutter/material.dart';

class TitleHeader extends StatelessWidget {

  final String title;
  final Color color_title;

  TitleHeader({Key key, @required this.title, this.color_title});

  @override
  Widget build(BuildContext context) {
    double screenWidht = MediaQuery.of(context).size.width;

    return Text(
      title,
      style: TextStyle(
        color: color_title != null? color_title:Colors.white,
        fontSize: 30.0,
        fontFamily: 'Lato',
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
