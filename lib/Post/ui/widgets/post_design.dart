import 'package:bloc_provider/bloc_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:manyas_v2/Post/model/post_model.dart';
import 'package:manyas_v2/User/bloc/user_bloc.dart';
import 'package:manyas_v2/User/model/user_model.dart';

class PostDesign extends StatefulWidget {
  PostModel postModel;
  UserModel userModel;

  PostDesign(this.postModel, this.userModel);

  @override
  _PostDesignState createState() => _PostDesignState();
}

class _PostDesignState extends State<PostDesign> {
  UserBloc userBloc;

  Future<bool> onLikeButtonTapped(bool isLiked) async{
    print('se presionó el botón de like ${isLiked}');
    print('widget.postModel.pid ${widget.postModel.pid}');

    await userBloc.updateLikePostData(widget.postModel, isLiked, widget.userModel);

    return !isLiked;
  }

  @override
  Widget build(BuildContext context) {
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
                  image: NetworkImage(widget.userModel.photoURL),
                  //image: AssetImage('assets/images/post_photo.PNG')
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
      margin: EdgeInsets.only(bottom: 10.0, left: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
              Row(
                children: [
                  LikeButton(
                    //size: 25,
                    //circleColor: CircleColor(start: Color(0xffFF5733), end: Color(0xffFF4118)),
                    likeCount: widget.postModel.likes, // falta hacer la lógica para los mayores a 1K y 1M
                    onTap: onLikeButtonTapped,
                    likeBuilder: (bool isLiked) {
                      return Icon(
                        Icons.favorite,
                        color: Color(0xFFF87125),
                      );
                    },
                  ),
                  //Text('${widget.postModel.likes}'),
                ],
              ),
          FlatButton.icon(
              onPressed: () {
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

    //enum SettingOptions{userBloc.deletePost(Po)}

    final popUpMenuOption = Container(
        margin: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 15, left: 15),
        child: IconButton(
          icon: Icon(Icons.clear,color: Color(0xFFFF0000),),
          onPressed: () async {
            print('se presionó: borrar post');
            await userBloc
                .deletePost(widget.postModel)
                .then((value) =>
                    ('se borró de manera exitosa el post selecionado '))
                .catchError((onError) {
              print('Error al borrar el post ${onError}');
            });
          },
        ));

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
            children: [userData, popUpMenuOption],
          ),
          photoCard,
          contentPost,
          likes_comments,
        ],
      ),
    );
  }
}
