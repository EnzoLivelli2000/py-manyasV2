import 'package:flutter/material.dart';

class ButtonX extends StatefulWidget {
  final String titleButton;
  double width = 0.0;
  double height = 0.0;
  final VoidCallback onPressed;
  Color buttonColor;
  Color titleColor;

  ButtonX({Key key, @required this.titleButton, @required this.onPressed, this.width, this.height, this.buttonColor, this.titleColor});

  @override
  _ButtonXState createState() => _ButtonXState();
}

class _ButtonXState extends State<ButtonX> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7.0),
            color: widget.buttonColor == null? Colors.white : widget.buttonColor,
        ),
        child: Center(
          child: Text(
              widget.titleButton,
              style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: 'Lato',
                  color: widget.titleColor == null? Colors.white : widget.titleColor,
              )
          ),
        ),
      ),
    );
  }
}
