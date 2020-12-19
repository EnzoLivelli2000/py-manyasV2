import 'package:flutter/material.dart';

class Background2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return BackgroundColor (screenWidth, screenHeight);

  }
}

Widget BackgroundColor (screenWidth, screenHeight){
  return Container(
    width: screenWidth,
    height: screenHeight,
    decoration: BoxDecoration(
      gradient: LinearGradient(
          colors: [
            Color(0xFFF87125),
            Color(0xFFE04316)
          ],
          begin: FractionalOffset(0.2, 0.0),
          end: FractionalOffset(1.0, 0.6),
          stops: [0.0, 0.6],
          tileMode: TileMode.clamp
      ),
      //borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight:Radius.circular(20)),
    ),
  );
}
