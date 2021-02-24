import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:manyas_v2/Party/ui/screens/prueba_party.dart';
import 'package:manyas_v2/Post/model/post_model.dart';
import 'package:manyas_v2/Post/ui/widgets/post_design.dart';
import 'package:manyas_v2/Storie/ui/screens/prueba_storie.dart';
import 'package:manyas_v2/User/bloc/user_bloc.dart';
import 'package:manyas_v2/User/model/user_model.dart';

class ProfileFriendContent extends StatelessWidget {
  UserBloc userBloc;
  UserModel userModel;
  int index;

  ProfileFriendContent(this.userModel, this.index);

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);
    switch (index) {
      case 0:
        return PostContent();
        //PostDesign(postModel2, userModel);
        break;
      case 1:
        return PruebaStorie();
        break;
      case 2:
        return PartyContent();
        break;
    }
  }

  Widget PostContent() {
    return StreamBuilder(
      stream: userBloc.myPostsListStream(userModel.uid),
      builder: (context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container(
              margin: EdgeInsets.only(top: 120),
              alignment: Alignment.center,
              child: Text(
                'Loading ...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          case ConnectionState.none:
            return Container(
              margin: EdgeInsets.only(top: 120),
              alignment: Alignment.center,
              child: Text(
                'Loading ...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          case ConnectionState.done:
            return Column(
                children:
                userBloc.buildMyFriendPosts(snapshot.data.documents, userModel));
          case ConnectionState.active:
            return Column(
                children:
                userBloc.buildMyFriendPosts(snapshot.data.documents, userModel));
          default:
            return CircularProgressIndicator();
        }
      },
    );
  }

  Widget PartyContent() {
    return StreamBuilder(
      stream: userBloc.myPartiesListStream(userModel.uid),
      builder: (context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container(
              margin: EdgeInsets.only(top: 120),
              alignment: Alignment.center,
              child: Text(
                'Loading ...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          case ConnectionState.none:
            return Container(
              margin: EdgeInsets.only(top: 120),
              alignment: Alignment.center,
              child: Text(
                'Loading ...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          case ConnectionState.done:
            return Column(
                children:
                userBloc.buildMyFriendParties(snapshot.data.documents, userModel));
          case ConnectionState.active:
            return Column(
                children:
                userBloc.buildMyFriendParties(snapshot.data.documents, userModel));
          default:
            return CircularProgressIndicator();
        }
      },
    );
  }
}
