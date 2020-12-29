import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:manyas_v2/User/bloc/user_bloc.dart';
import 'package:manyas_v2/User/ui/screens/search_person.dart';

class SearchPeopleScreen extends StatefulWidget {

  @override
  _SearchPeopleScreenState createState() => _SearchPeopleScreenState();
}

class _SearchPeopleScreenState extends State<SearchPeopleScreen> {
  //final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _controllerFilterPeople = TextEditingController();

  UserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Container(
          margin: EdgeInsets.only(top: 24.0),
          child: TextField(
            controller: _controllerFilterPeople,
            decoration: InputDecoration(
                fillColor: Color(0xFFD0D0D0),
                border: InputBorder.none,
                filled: true,
                hintText: "Search ...",
                hintStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFe5e5e5)),
                  borderRadius: BorderRadius.all(Radius.circular(9)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFe5e5e5)),
                  borderRadius: BorderRadius.all(Radius.circular(9)),
                ),
                suffixIcon: Icon(Icons.search)),
          ),
        ),
      ),
      //backgroundColor: Color(0xFFFF8E4A),
      body: Stack(
        children: <Widget>[
          StreamBuilder(
            stream: userBloc.authStatus,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                case ConnectionState.none:
                  return Center(child: CircularProgressIndicator());
                case ConnectionState.active:
                  return _controllerFilterPeople != null ||
                          _controllerFilterPeople != ''
                      ? showProfileData(
                          snapshot, _controllerFilterPeople)
                      : Stack(
                          children: <Widget>[
                            Container(child: Text('search someone'))
                          ],
                        );
                case ConnectionState.done:
                  return _controllerFilterPeople != null ||
                          _controllerFilterPeople != ''
                      ? showProfileData(
                          snapshot, _controllerFilterPeople)
                      : Stack(
                          children: <Widget>[
                            Container(child: Text('search someone'))
                          ],
                        );
                default:
                  return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }

  Widget showProfileData(
      AsyncSnapshot snapshot, TextEditingController _controllerFilterPeople) {
    if (!snapshot.hasData || snapshot.hasError) {
      return Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[Text('snapshot ERROR: ${snapshot.error}')],
          ),
        ],
      );
    } else {
      return Stack(
        children: <Widget>[
          SearchPerson(controllerFilterProduct: _controllerFilterPeople.text)
        ],
      );
    }
  }
}
