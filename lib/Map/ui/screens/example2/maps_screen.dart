import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapsScreen extends StatefulWidget {
  final String partyNumber;
  final String userId;

  MapsScreen({Key key, this.partyNumber, this.userId});

  static MaterialPageRoute route(String partyNumber, String userID) {
    return MaterialPageRoute(builder: (context) {
      return MapsScreen(
        partyNumber: partyNumber,
        userId: userID,
      );
    });
  }

  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class Person {
  final String id;
  final LatLng position;
  final String name;
  final bool isMe;

  Person(this.id, this.position, this.name, this.isMe);
}

class _MapsScreenState extends State<MapsScreen> {
  GoogleMapController _mapController;
  Location _location = Location();
  StreamSubscription<LocationData> subscription;
  StreamSubscription<QuerySnapshot> documentSubscription;
  List<Person> people = List();
  Set<Marker> markers = Set();
  var partyID;

  //LatLng target;
  LatLng target;

  final LatLng fromPoint = LatLng(-12.211151, -77.015562);
  final LatLng toPoint = LatLng(-12.209442, -77.023802);

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  _initLocation() async {
    var _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    var _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print('No Permission');
        return;
      }
    }


    QuerySnapshot qs = await Firestore.instance
        .collection('parties').where('codeParty', isEqualTo: widget.partyNumber).get();

    qs.docs.forEach((party) {
      partyID = party.data()['pid'];
    });

    var party = await Firestore.instance
        .collection('parties')
        .doc(partyID)
        .collection('partyTarget_people')
        .document(widget.partyNumber)
        .get();

    target = LatLng(party['target'].latitude, party['target'].longitude);

    documentSubscription = Firestore.instance
        .collection('parties')
        .doc(partyID)
        .collection('partyTarget_people')
        .document(widget.partyNumber)
        .collection('people')
        .snapshots()
        .listen((event) {
      people = event.documents
          .map(
            (e) =>
            Person(
              e.id,
              LatLng(e['lat'], e['lng']),
              e['name'],
              e.documentID == partyID
              //e.documentID == widget.userId,
            ),
      )
          .toList();
      _createMarkers();
    });

    subscription = _location.onLocationChanged.listen((LocationData event) {
      if (_mapController != null) {
        double minX = people.isEmpty
            ? 0
            : people.map((e) => e.position.latitude).reduce(math.min);
        double minY = people.isEmpty
            ? 0
            : people.map((e) => e.position.longitude).reduce(math.min);
        double maxX = people.isEmpty
            ? 0
            : people.map((e) => e.position.latitude).reduce(math.max);
        double maxY = people.isEmpty
            ? 0
            : people.map((e) => e.position.longitude).reduce(math.max);

        if(target != null){
          minX = math.min(minX, target.latitude);
          minY = math.min(minY, target.longitude);
          maxX = math.max(maxX, target.latitude);
          maxY = math.max(maxY, target.longitude);
        }

        minX = math.min(minX, event.latitude);
        minY = math.min(minY, event.longitude);
        maxX = math.max(maxX, event.latitude);
        maxY = math.max(maxY, event.longitude);

        LatLngBounds bounds = LatLngBounds(
            southwest: LatLng(minX, minY), northeast: LatLng(maxX, maxY));
        _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
      }

      Firestore.instance
          .collection('parties')
          .doc(partyID)
          .collection('partyTarget_people')
          .document(widget.partyNumber)
          .collection('people')
          .document(widget.userId)
          .set({
        'lat': event.latitude,
        'lng': event.longitude,
        'name': 'EL',
      });

      print(
          'Current Location: LAT->${event.latitude} LONG->${event.longitude}');
    });
  }

  @override
  void didUpdateWidget(MapsScreen oldWidget) {
    if (oldWidget.userId != widget.userId) {
      Firestore.instance
          .collection('parties')
          .doc(partyID)
          .collection('partyTarget_people')
          .document(widget.partyNumber)
          .collection('people')
          .document(oldWidget.userId)
          .delete();
    }
  }

  @override
  void dispose() {
    if (subscription != null) {
      subscription.cancel();
    }
    if (documentSubscription != null) {
      documentSubscription.cancel();
    }
    Firestore.instance
        .collection('parties')
        .doc(partyID)
        .collection('partyTarget_people')
        .document(widget.partyNumber)
        .collection('people')
        .document(widget.userId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('See you Here'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(-12.210092, -77.021177),
          zoom: 50,
        ),
        zoomGesturesEnabled: true,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        onMapCreated: (controller) => _mapController = controller,
        markers: markers,
      ),
    );
  }

  void _createMarkers() async{
    Set<Marker> newMarkers = Set();

    await Future.forEach(people, (person) async {
      var bitmapData = await _createAvatar(100, 100, person.name, color: person.isMe ? Colors.orange : Colors.blue);
      var bitmapDescriptor = BitmapDescriptor.fromBytes(bitmapData);

      var marker = Marker(
        markerId: MarkerId(person.id),
        position: person.position,
        icon: bitmapDescriptor,
        anchor: Offset(0.5,0.5),
      );
      newMarkers.add(marker);
    });

    /*List<Marker> markers = people
        .map((e) =>
        Marker(
          markerId: MarkerId(e.id),
          position: e.position,
        ))
        .toList();*/


    if(target != null) {
      newMarkers.add(Marker(
          markerId: MarkerId('target'),
          position: target,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)));
    }


    setState(() {
      markers = newMarkers;
    });
  }

  Future<Uint8List> _createAvatar(int width, int height, String name,
      {Color color = Colors.blue}) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()
      ..color = color;

    //Draw circle
    canvas.drawOval(
        Rect.fromCircle(
            center: Offset(width * 0.5, height * 0.5),
            radius: math.min(width * 0.5, height * 0.5)
        ),
        paint
    );

    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: name,
      style: TextStyle(fontSize: 50.0, color: Colors.white),
    );
    painter.layout();
    painter.paint(
        canvas,
        Offset((width * 0.5) - painter.width * 0.5,
            (height * 0.5) - painter.height * 0.5));

    //Create image data
    final img = await pictureRecorder.endRecording().toImage(width, height);
    final data = await img.toByteData(format: ImageByteFormat.png);
    return data.buffer.asUint8List();
  }
}
