import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import'package:google_maps_webservice/directions.dart';

class DirectionProvider extends ChangeNotifier {
  GoogleMapsDirections directionsApi = GoogleMapsDirections(
    apiKey:'AIzaSyANy_bFo3_RvGM1oP2K-M6Qrkq1o6uLIZg'
  );

  Set<maps.Polyline> _route = Set();

  Set<maps.Polyline> get currentRoute => _route;

  findDirections(maps.LatLng from, maps.LatLng to) async{
    var origin = Location(from.latitude, from.longitude);
    var destination = Location(to.latitude, to.longitude);

    var result = await directionsApi.directionsWithLocation(origin, destination, travelMode: TravelMode.walking);

    Set<maps.Polyline> newRoute = Set();

    if(result.isOkay){
      var route = result.routes[0];
      var leg = route.legs[0];

      List<maps.LatLng> points = [];

      leg.steps.forEach((step) {
        points.add(maps.LatLng(step.startLocation.lat, step.startLocation.lng));
        points.add(maps.LatLng(step.endLocation.lat, step.endLocation.lng));
      });

      var line = maps.Polyline(
        points: points,
        polylineId: maps.PolylineId('Best route'),
        color: Colors.orange,
        width: 4,
      );
      newRoute.add(line);

      print(line);

      _route = newRoute;
      notifyListeners();
    }else{
      print('ERROR ${result.errorMessage}');
    }
  }
}