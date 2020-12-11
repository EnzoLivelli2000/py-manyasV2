import 'package:flutter/material.dart';

class ButtonWhite extends StatefulWidget {
  final String titleButton;
  double width = 0.0;
  double height = 0.0;
  final VoidCallback onPressed;

  ButtonWhite(
      {Key key,
      @required this.titleButton,
      @required this.onPressed,
      this.width,
      this.height});

  @override
  _ButtonWhiteState createState() => _ButtonWhiteState();
}

class _ButtonWhiteState extends State<ButtonWhite> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        margin: EdgeInsets.only(
          top: 15.0,
          right: 20.0,
          left: 30.0,
        ),
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 5), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(35.0),
          color: Colors.white,
          /*gradient: LinearGradient(
                colors: [
                  Color(0xFFF87125), //arriba
                  Color(0xFFE07E16), //abajo
                ],
                begin: FractionalOffset(0.2, 0.0),
                end: FractionalOffset(1.0, 0.6),
                stops: [0.0, 0.6],
                tileMode: TileMode.clamp
            )*/
        ),
        child: Center(
          child: Text(widget.titleButton,
              style: TextStyle(
                  fontSize: 18.0, fontFamily: 'Lato', color: Colors.black)),
        ),
      ),
    );
  }
}
