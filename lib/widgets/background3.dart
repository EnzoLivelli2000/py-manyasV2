import 'package:flutter/material.dart';

class Background3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
      ),
      alignment: AlignmentDirectional.topStart,
      child:BackgroundColorWhite (screenWidth, screenHeight),
    );
  }
}

Widget BackgroundColorWhite (screenWidth, screenHeight){
  return Container(
    width: screenWidth,
    height: screenHeight * 0.52,
    //color: Colors.white,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight:Radius.circular(20)),
    ),
  );
}
