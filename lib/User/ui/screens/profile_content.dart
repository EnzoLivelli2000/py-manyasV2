import 'package:flutter/material.dart';
import 'package:manyas_v2/Party/ui/screens/prueba_party.dart';
import 'package:manyas_v2/Post/model/post_model.dart';
import 'package:manyas_v2/Post/ui/widgets/post_design.dart';
import 'package:manyas_v2/Storie/ui/screens/prueba_storie.dart';
import 'package:manyas_v2/User/model/user_model.dart';

class ProfileContent extends StatelessWidget {
  UserModel userModel;
  int index;

  ProfileContent(this.userModel, this.index);

  PostModel postModel1 = PostModel(
      V_I: 'assets/images/post_photo.PNG',
      likes: 345,
      comment: 68,
      content:
          'Esta foto fue del viaje a Cancún que hizo antes de la cuarentena. Todo allá era tam increible y maravilloso',
      lastTimePost: '5 min');

  PostModel postModel2 = PostModel(
      V_I: 'assets/images/post_photo_2.PNG',
      likes: 515,
      comment: 128,
      content:
          'Esta foto fue del viaje a Cancún que hizo antes de la cuarentena. Todo allá era tam increible y maravilloso.Esta foto fue del viaje a Cancún que hizo antes de la cuarentena. Todo allá era tam increible y maravilloso.Esta foto fue del viaje a Cancún que hizo antes de la cuarentena. Todo allá era tam increible y maravilloso.Esta foto fue del viaje a Cancún que hizo antes de la cuarentena. Todo allá era tam increible y maravilloso',
      lastTimePost: '2 dias');

  @override
  Widget build(BuildContext context) {
    switch (index) {
      case 0:
        return PostDesign(postModel2, userModel);
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
