import 'package:flutter/material.dart';
import 'package:manyas_v2/Map/ui/screens/example1/map_screen2.dart';
import 'package:provider/provider.dart';

//import 'DeliveryScreen.dart';
import 'DirectionsProvider.dart';

//void main() => runApp(MyApp());

class MainMapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:(_) => DirectionProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MapScreen2(),
      ),
    );
  }
}

class AskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fasty - Delivery'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Desde: Pizzeria',
            ),
            Text(
              'Hasta: Roca 123',
            ),
            FlatButton(
              child: Text("Aceptar Viaje"),
              onPressed: () {
              },
            )
          ],
        ),
      ),
    );
  }
}