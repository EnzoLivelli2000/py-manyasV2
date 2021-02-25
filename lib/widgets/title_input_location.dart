import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextInputLocation extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final IconData iconData;
  int textLimiting;
  final VoidCallback onPressed;

  TextInputLocation({
    Key key,
    @required this.hintText,
    @required this.iconData,
    @required this.controller,
    @required this.onPressed,
    this.textLimiting,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.only(right: 20, left: 20),
        child: TextField(
          inputFormatters: [
            LengthLimitingTextInputFormatter(textLimiting),
          ],
          controller: controller,
          style: TextStyle(
            fontSize: 15.0,
            fontFamily: 'Lato',
            color: Colors.blueGrey,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: Icon(iconData),
            fillColor: Color(0xFFFFFFFF),
            filled: true,
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFFFFFFF)),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFFFFFFF)),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
        decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black12,
                  blurRadius: 15,
                  offset: Offset(0,7)
              )
            ]
        ),
      ),
    );
  }
}
