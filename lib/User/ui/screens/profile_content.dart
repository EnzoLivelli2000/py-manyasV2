import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:manyas_v2/Party/model/party_model.dart';
import 'package:manyas_v2/Party/ui/screens/prueba_party.dart';
import 'package:manyas_v2/Party/ui/widgets/party_design.dart';
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
                    userBloc.buildMyPosts(snapshot.data.documents, userModel));
          case ConnectionState.active:
            return Column(
                children:
                    userBloc.buildMyPosts(snapshot.data.documents, userModel));
          default:
            return CircularProgressIndicator();
        }
      },
    );
  }



  PartyModel _partyModel = new PartyModel(
      dateTimeNow: 'Justo ahora',
      Partydate: 'Lunes, 16 Nov 2021',
      Partylocation: 'Calle 33, Cedros de Villa, Chorrillos',
      PartyTime: '11:00 PM',
      title: 'Mi cumpleaños',
      description: 'Esta es mi primera fiesta, despues de la cuarentena. Los espero!!! '
          'Esta es mi primera fiesta, despues de la cuarentena. Los espero!!!'
          'Esta es mi primera fiesta, despues de la cuarentena. Los espero!!!'
          'Esta es mi primera fiesta, despues de la cuarentena. Los espero!!!',
      V_I: 'assets/images/peopleEnjoy.PNG',
      Userlocation: 'Calle 33 cedros de villa Chorrillos',
      price: '50'
  );

  Widget PartyContent() {
    return Column(
      children: [
        PartyDesign(_partyModel, userModel),
      ],
    );
  }
}
