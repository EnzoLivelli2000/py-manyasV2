import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:manyas_v2/Party/ui/screens/prueba_party.dart';
import 'package:manyas_v2/Post/model/post_model.dart';
import 'package:manyas_v2/Post/ui/widgets/post_design.dart';
import 'package:manyas_v2/Storie/ui/screens/prueba_storie.dart';
import 'package:manyas_v2/User/bloc/user_bloc.dart';
import 'package:manyas_v2/User/model/user_model.dart';

class ProfileContent extends StatelessWidget {
  UserBloc userBloc;
  UserModel userModel;
  int index;

  ProfileContent(this.userModel, this.index);

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);
    switch (index) {
      case 0:
        return StreamBuilder(
          stream: userBloc.myPostsListStream(userModel.uid),
          builder: (context, AsyncSnapshot snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.waiting:
                return CircularProgressIndicator();
              case ConnectionState.done:
                return Column(
                    children: userBloc.buildMyPosts(snapshot.data.documents, userModel)
                );
              case ConnectionState.active:
                return Column(
                    children: userBloc.buildMyPosts(snapshot.data.documents, userModel)
                );
              case ConnectionState.none:
              default:
                return CircularProgressIndicator();
            }
          },
        );
        //PostDesign(postModel2, userModel);
        break;
      case 1:
        return PruebaStorie();
        break;
      case 2:
        return PruebaParty();
        break;
    }
  }
}
