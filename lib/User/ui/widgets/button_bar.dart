import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:manyas_v2/User/ui/widgets/circle_button.dart';

class ButtonsBar extends StatelessWidget {
  //UserBloc userBloc;

  @override
  Widget build(BuildContext context) {
//    userBloc = BlocProvider.of(context);

    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 0.0,
            vertical: 10.0
        ),
        child: Row(
          children: <Widget>[
            //CircleButton(true, Icons.turned_in_not, 20.0, Color.fromRGBO(255, 255, 255, 1)),
            // Cambiaremos la contraseña o datos de configuración
            CircleButton(true, Icons.vpn_key, 20.0, Color.fromRGBO(255, 255, 255, 0.8),Color(0xFFF87125),
                    () => {}),
            // Añadiremos un nuevo post,party,storie
            CircleButton(false, Icons.add, 40.0, Color(0xFFF87125),Colors.white,
                    () {
                  /*ImagePicker.pickImage(source: ImageSource.camera).then((File image){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) => AddPlaceScreen(image: image)));
                  }).catchError((onError) => print(onError));*/

                }),
            // Cerrar sesión
            CircleButton(true, Icons.exit_to_app, 20.0, Color.fromRGBO(255, 255, 255, 0.8),Color(0xFFF87125),
                    () => {
                  //userBloc.signOut()
                }),
            //CircleButton(true, Icons.person, 20.0, Color.fromRGBO(255, 255, 255, 0.6))
          ],
        )
    );
  }

}