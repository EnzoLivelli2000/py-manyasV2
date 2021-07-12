import 'dart:io';

import 'package:address_search_field/address_search_field.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:manyas_v2/Map/ui/screens/example2/maps_screen.dart';
import 'package:manyas_v2/Party/ui/screens/add_party_screen2.dart';
import 'package:manyas_v2/User/bloc/user_bloc.dart';
import 'package:manyas_v2/User/model/user_model.dart';
import 'package:manyas_v2/widgets/text_input.dart';

class CreatePartyScreen extends StatefulWidget {
  File image;
  String controllerTitleParty;
  String controllerDescriptionParty;
  bool fullSize = false;

  CreatePartyScreen(
      {Key key,
        this.image,
        this.controllerTitleParty,
        this.controllerDescriptionParty,
      });

  @override
  _CreatePartyScreenState createState() => _CreatePartyScreenState();
}

class _CreatePartyScreenState extends State<CreatePartyScreen> {
  final LatLng fromPoint = LatLng(-12.211151, -77.015562);

  //Coords _coordsfromPoint = Coords(-12.211151, -77.015562);
  //Coords _coordstoPoint = Coords(-12.209442, -77.023802);

  final origCtrl = TextEditingController();

  final destCtrl = TextEditingController();

  final polylines = Set<Polyline>();

  // final markers = Set<Marker>();

  final geoMethods = GeoMethods(
    googleApiKey: 'AIzaSyCMiZ5rfHCJ1kfZ-m_KmJ6CXbH8rKH8zcw',
    language: 'es-419',
    country: 'pe', /// commented for use case
    countryCodes: [
      /// to autocomplete addresses from multicountry
      'ec', //ecuador
      'co', //colombia
      'ar', //argentina
      'br', //brazil
      'pe', // peru
    ],
  );
  GoogleMapController _controller;
  Set<Marker> markers = Set();
  LatLng target = LatLng(0, 0);

  @override
  Widget build(BuildContext context) {
    UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    if (widget.image.path == null) {
      print('Entro a widget.image.path == null');
      Navigator.of(context).pop();
      return StreamBuilder(
        stream: userBloc.authStatus,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                ],
              );
            case ConnectionState.none:
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                ],
              );
            case ConnectionState.active:
              return showData(snapshot);
            case ConnectionState.done:
              return showData(snapshot);
            default:
          }
        },
      );
    } else {
      return StreamBuilder(
        stream: userBloc.authStatus,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                ],
              );
            case ConnectionState.none:
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                ],
              );
            case ConnectionState.active:
              return showData(snapshot);
            case ConnectionState.done:
              return showData(snapshot);
            default:
          }
        },
      );
    };
  }

  Scaffold showData(AsyncSnapshot snapshot) {
    var userAux = UserModel(
      uid: snapshot.data.uid,
      name: snapshot.data.displayName,
      email: snapshot.data.email,
      photoURL: snapshot.data.photoUrl,
      // followers: snapshot.data.followers,
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Plugin example app'),
      ),
      body: Container(
        child: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: GoogleMap(
                  ////compassEnabled: true,
                  //myLocationEnabled: true,
                  //myLocationButtonEnabled: true,
                  ////rotateGesturesEnabled: true,
                  zoomGesturesEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: fromPoint,
                    zoom: 14.5,
                  ),
                  onMapCreated: (GoogleMapController controller) =>
                  _controller = controller,
                  ////polylines: polylines,
                  markers: markers,
                ),
              ),
              RouteSearchBox(
                /// we need to specify a countryCode to get routes because countryCode parameter was commented
                geoMethods: geoMethods.copyWith(countryCodeParam: 'pe'),
                originCtrl: origCtrl,
                destinationCtrl: destCtrl,
                builder: (context, originBuilder, destinationBuilder,
                    {waypointBuilder, getDirections, relocate, waypointsMgr}) {
                  if (origCtrl.text.isEmpty) {
                    relocate(AddressId.origin, fromPoint.toCoords());
                  }
                  return Positioned(
                    top: 8,
                    left: 12,
                    right: 12,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      //color: Colors.white,
                      height: 50.0,
                      child: Column(
                        children: [
                          TextField(
                            controller: origCtrl,
                            onTap: () => showDialog(
                              context: context,
                              builder: (context) => originBuilder.buildDefault(
                                builder: AddressDialogBuilder(),
                                onDone: (address) {
                                  print(
                                      'Latitude de la fiesta ${address.coords.latitude}');
                                  print(
                                      'Longitude de la fiesta ${address.coords.longitude}');

                                  target = LatLng(address.coords.latitude,
                                      address.coords.longitude);

                                  setState(() {
                                    markers = Set();
                                    markers.add(Marker(
                                      markerId: MarkerId('target'),
                                      position: target,
                                    ));
                                  });

                                  _controller.animateCamera(
                                      CameraUpdate.newLatLng(target));
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 25,
                left: 0,
                right: 0,
                child: FloatingActionButton(
                  onPressed: () async {
                    //UserId
                    var userId = userAux.uid;

                    //PartyNumber
                    var partyNumber = _calcPartyNumber(userId, target);

                    /*//Create a Party
                    await Firestore.instance
                        .collection('partiesExample2')
                        .document(partyNumber)
                        .setData({
                      'target': GeoPoint(target.latitude, target.longitude)
                    });*/

                    /*//Open the map
                    Navigator.of(context).push(
                        MapsScreen.route(partyNumber, userId)
                    );*/


                    //Go to the second screen -> add_party_screen2
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => AddPartyScreen2(
                              image: widget.image,
                              controllerTitleParty:
                              widget.controllerTitleParty,
                              controllerDescriptionParty:
                              widget.controllerDescriptionParty,
                              partyNumber: partyNumber,
                              target: GeoPoint(target.latitude, target.longitude),
                            )));
                  },
                  child: Icon(Icons.check),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

String _calcPartyNumber(String userId, LatLng target) {
  var tmp = "$userId;${target.latitude};${target.longitude}";
  var tmpInt = tmp.hashCode;

  var chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  var result = '';

  while (tmpInt > 0) {
    var remainder = tmpInt % 36;
    result = chars[remainder] + result;
    tmpInt = tmpInt ~/ 36;
  }
  return result;
}

class Waypoints extends StatelessWidget {
  const Waypoints(this.waypointsMgr, this.waypointBuilder);

  final WaypointsManager waypointsMgr;
  final AddressSearchBuilder waypointBuilder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.add_location_alt),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => waypointBuilder.buildDefault(
                builder: AddressDialogBuilder(),
                onDone: (address) => null,
              ),
            ),
          )
        ],
      ),
      body: ValueListenableBuilder<List<Address>>(
        valueListenable: waypointsMgr.valueNotifier,
        builder: (context, value, _) => ListView.separated(
          itemCount: value.length,
          separatorBuilder: (BuildContext context, int index) => Divider(),
          itemBuilder: (BuildContext context, int index) =>
              ListTile(title: Text(value[index].reference)),
        ),
      ),
    );
  }
}
