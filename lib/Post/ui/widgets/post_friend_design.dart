import 'package:bloc_provider/bloc_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:manyas_v2/Post/model/post_model.dart';
import 'package:manyas_v2/User/bloc/user_bloc.dart';
import 'package:manyas_v2/User/model/user_model.dart';

class PostFriendDesign extends StatefulWidget {
  PostModel postModel;
  UserModel userModel;

  PostFriendDesign(this.postModel, this.userModel);

  @override
  _PostFriendDesignState createState() => _PostFriendDesignState();
}


class _PostFriendDesignState extends State<PostFriendDesign> {
  UserBloc userBloc;
  bool colorLikeButton = false;
  int countLikes;
  bool isLikedX = false;

  Future<bool> onLikeButtonTapped(bool isLikedX) async{
    String uidCurrentUser = await FirebaseAuth.instance.currentUser.uid;
    await userBloc.updateLikePostData(widget.postModel, isLikedX, uidCurrentUser);

    return !isLikedX;
  }

  void getColorLikeButton(){
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _asyncColorLikeButton();
    });
  }

  void getLengthLike(){
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _asyncLengthLike();
    });
  }

  _asyncColorLikeButton() async{
    String uidCurrentUser = await FirebaseAuth.instance.currentUser.uid;
    bool aux = await userBloc.ColorLikeButton(widget.postModel, uidCurrentUser);

    if(aux == null){
      if (mounted) {
        setState(() {
          colorLikeButton = false;
        });
      }
    }else{

      if (mounted) {
        setState(() {
          colorLikeButton = aux;
        });
      }
    }
  }

  _asyncLengthLike() async{
    int aux = await userBloc.LengthLikes(widget.postModel);
    if (mounted) {
      setState(() {
        countLikes = aux;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getColorLikeButton();
    getLengthLike();
    userBloc = BlocProvider.of<UserBloc>(context);

    final photoCard = Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 15, left: 15),
      height: 220.0,
      //width: 350,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: CachedNetworkImageProvider(widget.postModel.V_I),
        ),
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
    );

    final userData = Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 15, left: 15),
      child: Row(
        children: <Widget>[
          Container(
            width: 50.0,
            height: 50.0,
            margin: EdgeInsets.only(right: 8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                shape: BoxShape.rectangle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  //image: AssetImage('https://firebasestorage.googleapis.com/v0/b/crud-flutter-6c754.appspot.com/o/zXeoV02LgKgWdxFNs1Za6HSbkb72%2F2020-12-18%2018%3A40%3A09.111297.jpg?alt=media&token=92ab258d-6e45-46ca-a6bb-7b424a84e8c6'),
                  image: NetworkImage(widget.userModel.photoURL),
                )),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                //userModel.name.length > 11? '${userModel.name.substring(0,15)} ...': userModel.name,
                  widget.userModel.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Lato',
                    decoration: TextDecoration.none,
                  )),
              Text('2 days ago',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black26,
                    fontFamily: 'Lato',
                    decoration: TextDecoration.none,
                  )),
            ],
          )
        ],
      ),
    );

    final contentPost = Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 25, left: 25),
      alignment: AlignmentDirectional.bottomStart,
      child: Text(widget.postModel.description,
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            fontFamily: 'Lato',
            decoration: TextDecoration.none,
          )),
    );

    final likes_comments = Container(
      margin: EdgeInsets.only(bottom: 10.0, left: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          /*LikeButton(
            //size: 25,
            //circleColor: CircleColor(start: Color(0xffFF5733), end: Color(0xffFF4118)),
            likeCount: length, // falta hacer la lógica para los mayores a 1K y 1M
            onTap:(isLiked) {
                onLikeButtonTapped;
                getLengthLike();
            },
            likeBuilder: (bool isLiked) {
              return Icon(
                Icons.favorite,
                color: colorLikeButton != false ?Color(0xFFF87125):Colors.grey,
              );
            },
          ),*/
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.favorite, color: colorLikeButton != false ?Color(0xFFF87125):Colors.grey,),
                onPressed: () async {
                  await onLikeButtonTapped(isLikedX);
                  await getLengthLike();
                },
              ),
              Text('${countLikes}'),
            ],
          ),
          FlatButton.icon(
              onPressed: (){
                print('se presionó el botón de commnent');
              },
              icon: Icon(
                Icons.comment,
                color: Color(0xFFF87125),
              ),
              label: Text('128')),
        ],
      ),
    );

    return Container(
      margin: EdgeInsets.only(top: 30.0, bottom: 10.0, right: 15, left: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [userData],
          ),
          photoCard,
          contentPost,
          likes_comments,
        ],
      ),
    );
  }
}
