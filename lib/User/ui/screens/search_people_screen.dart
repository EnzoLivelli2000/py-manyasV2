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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: Container(
          margin: EdgeInsets.only(top: 25.0, right: 10, left: 10),
          child: TextField(
            controller: _controllerFilterPeople,
            style: TextStyle(color: Colors.white),
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
                fillColor: Color(0xFFFF8E4A) ,
                border: InputBorder.none,
                filled: true,
                hintText: "Search ...",
                hintStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFF8E4A)),
                  borderRadius: BorderRadius.all(Radius.circular(9)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFF8E4A) ),
                  borderRadius: BorderRadius.all(Radius.circular(9)),
                ),
                suffixIcon: Icon(Icons.search,color:Colors.white,)
            ),
          ),
        ),
          //Color(0xFFe5e5e5) es un color gris q me gusta
      ),
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
