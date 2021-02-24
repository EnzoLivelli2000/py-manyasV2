import 'dart:math';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:manyas_v2/Map/ui/screens/example1/DirectionsProvider.dart';
import 'package:provider/provider.dart';

class MapScreen2 extends StatefulWidget {
  final LatLng fromPoint = LatLng(-12.211151, -77.015562);
  final LatLng toPoint = LatLng(-12.209442, -77.023802);

  MapScreen2();

  @override
  _MapScreen2State createState() => _MapScreen2State();
}

class _MapScreen2State extends State<MapScreen2> {
  GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    return createMap();
  }

  /*return CupertinoTabView(
  builder: (BuildContext context){
    return ChangeNotifierProvider(
      create:(_) => DirectionProvider(),
      child: MapScreen2(),
  );
  }
  );*/

  /*class CreateMap extends StatelessWidget {
    @override
    Widget build(BuildContext context){

    }
  }*/

  Scaffold createMap() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fasty - Delivery'),
      ),
      body:Consumer<DirectionProvider>(
        builder: (BuildContext context, DirectionProvider api, Widget child) {
          return GoogleMap(
          initialCameraPosition: CameraPosition(
          target: widget.fromPoint,
          zoom: 14,
          ),
          markers: _createMarkers(),
          polylines: api.currentRoute,
          onMapCreated: onMapCreated,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          );
        }
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 50),
        child: FloatingActionButton(
          child: Icon(Icons.zoom_out_map),
          onPressed: _centerView,
        ),
      ),
    );
  }

  Set<Marker> _createMarkers() {
    var tmp = Set<Marker>();

    tmp.add(Marker(
        markerId: MarkerId("fromPoint"),
        position: widget.fromPoint,
        infoWindow: InfoWindow(title: 'You are Here')
    ));

    tmp.add(Marker(
        markerId: MarkerId("toPoint"),
        position: widget.toPoint,
        infoWindow: InfoWindow(title: 'Party Here')
    ));
    return tmp;
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    _centerView();
  }

  _centerView() async{
    var api = Provider.of<DirectionProvider>(context, listen: false);

    await _mapController.getVisibleRegion();

    print('buscando direcciones');
    await api.findDirections(widget.fromPoint, widget.toPoint);

    var left = min(widget.fromPoint.latitude, widget.toPoint.latitude);
    var right = max(widget.fromPoint.latitude, widget.toPoint.latitude);
    var top = max(widget.fromPoint.longitude, widget.toPoint.longitude);
    var bottom = min(widget.fromPoint.longitude, widget.toPoint.longitude);

    api.currentRoute.first.points.forEach((point) {
      left = min(left, point.latitude);
      right = max(right, point.latitude);
      top = max(top, point.longitude);
      bottom = min(bottom, point.longitude);
    });

    var bounds = LatLngBounds(southwest: LatLng(left,bottom), northeast: LatLng(right, top));

    var cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 50);
    _mapController.animateCamera(cameraUpdate);
  }
}
