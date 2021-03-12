import 'package:bloc_provider/bloc_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manyas_v2/Comment/model/model_comment.dart';
import 'package:manyas_v2/User/bloc/user_bloc.dart';

class SendComment extends StatefulWidget {
  TextEditingController controllerComment;
  String typePost;
  String postID;

  SendComment(
      {Key key,
      @required this.controllerComment,
      @required this.typePost,
      @required this.postID,
      });

  @override
  _SendCommentState createState() => _SendCommentState();
}

class _SendCommentState extends State<SendComment> {
  @override
  Widget build(BuildContext context) {
    UserBloc userBloc = BlocProvider.of<UserBloc>(context);

    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 5.0, right: 9, left: 9, bottom: 10.0),
      child: TextField(
        controller: widget.controllerComment,
        onSubmitted: (String value) {
          userBloc
              .sendComment(
                  CommentModel(
                      dateTimeNow: DateTime.now().toString(), content: value,likes: 0),
                  widget.typePost,
                  widget.postID)
              .then((value) {
            print('Se envió tu comentario a la base de datos CORRECTAMENTE');
            FocusScope.of(context).unfocus();
            widget.controllerComment.clear();
          }).catchError((onError) {
            print('ERROR : $onError');
          });
        },
        style: TextStyle(color: Colors.black),
        textInputAction: TextInputAction.send,
        decoration: InputDecoration(
            fillColor: Colors.white,
            border: InputBorder.none,
            filled: true,
            hintText: "You comment ...",
            hintStyle: TextStyle(color: Color(0xFFFF8E4A)),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFFF8E4A)),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            /*focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFFFF8E4A)),
                                borderRadius: BorderRadius.all(Radius.circular(9)),
                              ),*/
            suffixIcon: Icon(
              Icons.send,
              color: Color(0xFFFF8E4A),
            )),
      ),
    );
  }
}
