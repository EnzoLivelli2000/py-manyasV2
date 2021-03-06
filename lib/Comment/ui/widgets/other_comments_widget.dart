import 'package:flutter/material.dart';

class OtherCommentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            //alignment: ,
            width: 50.0,
            height: 50.0,
            margin: EdgeInsets.only(top: 15.0, bottom: 15.0, right: 8, left: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                shape: BoxShape.rectangle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  //image: NetworkImage(photoURL),
                  image: AssetImage('assets/images/post_photo.PNG')
                )),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 15.0, bottom: 15.0, right: 10, left: 8),
              //alignment: Alignment.topCenter,
              child: Text('Esto es un comentario de prueba de algunas cosas q tengo en la cabeza espero que siga dando error cuando acabe de escribir estos'),
            ),
          ),
        ],
      ),
    );
  }
}
