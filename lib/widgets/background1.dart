import 'package:flutter/material.dart';

class Background1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth,
      height: screenHeight,
      color: Colors.white,
      alignment: AlignmentDirectional.topStart,
      child:BackgroundColor (screenWidth, screenHeight),
    );
  }
}

Widget BackgroundColor (screenWidth, screenHeight){
  return Container(
    width: screenWidth,
    height: screenHeight * 0.52,
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
      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight:Radius.circular(20)),
    ),
    child: FittedBox(
      fit: BoxFit.none,
      alignment: Alignment(-1.5, -0.8),
      child: Container(
        width: screenHeight,
        height: screenHeight,
        decoration: BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            borderRadius: BorderRadius.circular(screenHeight / 2)
        ),
      ),
    ),
  );
}
