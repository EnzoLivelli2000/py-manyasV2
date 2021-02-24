/*import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_gl/mapbox_gl.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapboxMapController mapController;
  final center = LatLng(-12.211151, -77.015562);

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    _onStyleLoaded();
  }

  void _onStyleLoaded(){
    addImageFromAsset("assetImage", "assets/images/profile_photo.PNG");
    addImageFromUrl("networkImage", "https://via.placeholder.com/50");
  }

  /// Adds an asset image to the currently displayed style
  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapController.addImage(name, list);
  }

  /// Adds a network image to the currently displayed style
  Future<void> addImageFromUrl(String name, String url) async {
    var response = await http.get(url);
    return mapController.addImage(name, response.bodyBytes);
  }

  @override
  Widget build(BuildContext context) {
    return createMap();
  }

  Scaffold createMap() {
    return Scaffold(
      //appBar: appBarTitle(),
      body: Center(
        child: MapboxMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(target: center, zoom: 14),
        ),
      ),
      floatingActionButton: Container(
        child: buttons(),
        margin: EdgeInsets.only(bottom: 50),
      ),
    );
  }

  Column buttons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        FloatingActionButton(
            backgroundColor: Color(0xFFFF8E4A),
            child: Icon(Icons.accessibility_rounded),
            onPressed: () {
              mapController.addSymbol(SymbolOptions(
                geometry: center,
                iconImage: 'assetImage',
                //iconSize: 2,
                textField: 'You´re Here',
                textOffset: Offset(0,2)
              ));
            }),
        SizedBox(height: 5),
        FloatingActionButton(
            backgroundColor: Color(0xFFFF8E4A),
            child: Icon(Icons.zoom_in),
            onPressed: () {
              mapController.animateCamera(CameraUpdate.zoomIn());
            }),
        SizedBox(height: 5),
        FloatingActionButton(
            backgroundColor: Color(0xFFFF8E4A),
            child: Icon(Icons.zoom_out),
            onPressed: () {
              mapController.animateCamera(CameraUpdate.zoomOut());
            }),
      ],
    );
  }

  PreferredSize appBarTitle() {
    return PreferredSize(
      preferredSize: Size.fromHeight(80.0),
      child: Container(
        //color: Color(0xFFFF8E4A),
        margin: EdgeInsets.only(top: 20.0, right: 10, left: 10),
        child: Center(
          child: Text(
            'Search your friends here',
            style: TextStyle(
              fontSize: 25.0,
              fontFamily: 'Lato',
              color: Colors.black38,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      //Color(0xFFe5e5e5) es un color gris q me gusta
    );
  }
}
*/

