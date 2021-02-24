import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class NunberInput extends StatelessWidget {

  final String hintText;
  final TextInputType inputType;
  final TextEditingController controller;
  int maxLines = 1;
  int textLimiting;

  NunberInput({
    Key key,
    @required this.hintText,
    @required this.inputType,
    @required this.controller,
    this.maxLines,
    this.textLimiting,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 20, left: 20),
      child: TextField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(textLimiting),
        ],
          keyboardType: TextInputType.number,
          controller: controller,
          maxLines: maxLines,
          style: TextStyle(
            fontSize: 15.0,
            fontFamily: 'Lato',
            color: Colors.blueGrey,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFFe5e5e5),
            border: InputBorder.none,
            hintText: hintText,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFe5e5e5)),
              borderRadius: BorderRadius.all(Radius.circular(9)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFe5e5e5)),
              borderRadius: BorderRadius.all(Radius.circular(9)),
            ),
          )
      ),
    );
  }
}
