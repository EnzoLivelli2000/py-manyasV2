import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:manyas_v2/User/bloc/user_bloc.dart';
import 'package:manyas_v2/User/model/user_model.dart';
import 'package:manyas_v2/widgets/buttons/button_x.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;

class FollowButton extends StatefulWidget {

  UserModel userModel;

  FollowButton({Key key, this.userModel});

  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  UserBloc userBloc;
  bool isFollowedX = false;
  bool colorFollowButton = false;

  _asyncColorFollowButton() async {
    String uidCurrentUser = await firebaseAuth.FirebaseAuth.instance.currentUser.uid;
    bool aux = await userBloc.ColorFollowButton(uidCurrentUser, widget.userModel);
    print('aux ${aux}');

    if (aux == null) {
      if (mounted) {
        setState(() {
          colorFollowButton = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          colorFollowButton = aux;
        });
      }
    }
  }

  bool getColorFollowButton() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _asyncColorFollowButton();
    });
  }

  Future<bool> onFollowButtonTapped(bool isFollowedX, UserModel userModel, bool colorFollowButton, UserBloc userBloc) async{
    print('se presionó el botón de like ${isFollowedX}');
    String uidCurrentUser = await firebaseAuth.FirebaseAuth.instance.currentUser.uid;
    colorFollowButton = await userBloc.SALVADORALIST(uidCurrentUser,userModel);
    return !isFollowedX;
  }

  @override
  void initState() {
    // TODO: implement initState
    getColorFollowButton();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);
    return Container(
      margin: EdgeInsets.only(bottom: 35, right: 10),
      child: ButtonX(
        onPressed: () async{
          print('se presionó el nuevo botón de FOLLOW');
          await onFollowButtonTapped(isFollowedX, widget.userModel, colorFollowButton, userBloc);
          getColorFollowButton();
          print('El valor de like (SALIDA) ${colorFollowButton}');
        },
        titleButton: 'follow',
        height: 30,
        width: 90,
        buttonColor: colorFollowButton == false ? Color(0xFF3EF850):Colors.grey,
      ),
    );
  }
}
