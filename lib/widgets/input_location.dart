import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputLocation extends StatelessWidget {
  final String hintText;
  final IconData iconData;
  final VoidCallback onPressed;

  InputLocation({
    Key key,
    @required this.hintText,
    @required this.iconData,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.only(right: 20, left: 20, top: 12, bottom: 12),
        margin: EdgeInsets.only(right: 20, left: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              hintText,
              style: TextStyle(
                fontSize: 15.0,
                fontFamily: 'Lato',
                color: Colors.black45,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(Icons.add_location_alt_outlined, color:Colors.deepOrangeAccent,),
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 10,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),

      ),
    );
  }
}
