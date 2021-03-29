import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manyas_v2/Comment/model/model_comment.dart';
import 'package:manyas_v2/User/bloc/user_bloc.dart';
import 'package:manyas_v2/User/model/user_model.dart';

class OtherCommentWidget extends StatelessWidget {
  String photoUrlUser;
  String commentContent;
  String dateTimeNow;
  bool isDeleteComment;
  UserModel userModel;

  OtherCommentWidget(
      {@required this.photoUrlUser,
      @required this.commentContent,
      @required this.dateTimeNow,
      @required this.isDeleteComment,
      this.userModel});

  @override
  Widget build(BuildContext context) {
    UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    return Container(
      child: Row(
        children: [
          Container(
            //alignment: ,
            width: 50.0,
            height: 50.0,
            margin:
                EdgeInsets.only(top: 15.0, bottom: 15.0, right: 8, left: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                shape: BoxShape.rectangle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(photoUrlUser),
                  //image: AssetImage('assets/images/post_photo.PNG')
                )),
          ),
          Expanded(
            child: Container(
              margin:
                  EdgeInsets.only(top: 15.0, bottom: 15.0, right: 10, left: 8),
              //alignment: Alignment.topCenter,
              child: Text(commentContent,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontFamily: 'Lato',
                    decoration: TextDecoration.none,
                  )),
            ),
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 8, right: 10),
                child: Text(dateTimeNow.toString().substring(0, 10),
                    style: TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontFamily: 'Lato',
                      decoration: TextDecoration.none,
                    )),
              ),
              !isDeleteComment?
              Container():
              Container(
                //margin: EdgeInsets.only(bottom: 10),
                  child: IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Color(0xFFFF0000),
                      size: 15,
                    ),
                    onPressed: () async {
                      print('se presionó: borrar post');
                      /*await userBloc
                      .deleteComments(partyModel)
                      .then((value) =>
                        ('se borró de manera exitosa el post selecionado '))
                      .catchError((onError) {
                        print('Error al borrar el post ${onError}');
                      });*/
                    },
                  )),
            ],
          ),

        ],
      ),
    );
  }
}
