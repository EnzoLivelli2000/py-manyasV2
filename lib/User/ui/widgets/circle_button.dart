import 'package:flutter/material.dart';

class CircleButton extends StatefulWidget {
  final VoidCallback onPressed;
  bool mini;
  var icon;
  double iconSize;
  var colorBack;
  var color;

  CircleButton(this.mini, this.icon, this.iconSize, this.colorBack, this.color,  @required this.onPressed);

  @override
  State<StatefulWidget> createState() {
    return _CircleButton();
  }

}

class _CircleButton extends State<CircleButton> {

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: FloatingActionButton(
          backgroundColor: widget.colorBack,
          mini: widget.mini,
          onPressed: widget.onPressed,
          child: Icon(
            widget.icon,
            size: widget.iconSize,
            color: widget.color,
          ),
          heroTag: null,
        )
    );
  }
}