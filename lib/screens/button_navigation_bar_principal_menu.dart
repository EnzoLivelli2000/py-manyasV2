import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:manyas_v2/Map/ui/screens/example2/create_party_screen.dart';
import 'package:manyas_v2/Map/ui/screens/example2/join_screen.dart';
import 'package:manyas_v2/Map/ui/screens/map_screen.dart';
import 'package:manyas_v2/User/bloc/user_bloc.dart';
import 'package:manyas_v2/User/ui/screens/profile_screen.dart';
import 'package:manyas_v2/User/ui/screens/search_people_screen.dart';
import 'package:manyas_v2/screens/home_screen.dart';

import '../Map/ui/screens/example2/join_screen.dart';

class ButtonNavigationBarPrincipalMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      bottomNavigationBar: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home, color: Color(0xFFF87125),),
                  title: Text("Home")
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search, color: Color(0xFFF87125),),
                  title: Text("Search")
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.location_on, color: Color(0xFFF87125),),
                  title: Text("Map")
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person, color: Color(0xFFF87125),),
                  title: Text("Profile")
              ),
            ]
        ),

        tabBuilder: (BuildContext context, int index) {
          switch (index) {
            case 0:
              return CupertinoTabView(
                  builder: (BuildContext context){
                    return BlocProvider<UserBloc>(
                      creator:(_context, _bag) => UserBloc(),
                      child: HomeScreen(),
                    );
                  }
              );
              break;
            case 1:
              return CupertinoTabView(
                  builder: (BuildContext context){
                    return BlocProvider<UserBloc>(
                      creator:(_context, _bag) => UserBloc(),
                      child: SearchPeopleScreen(),
                    );
                  }
              );
              break;
            case 2:
              return CupertinoTabView(
                  builder: (BuildContext context){
                    return BlocProvider<UserBloc>(
                      creator:(_context, _bag) =>UserBloc(),
                      child: JoinScreen(), //ESTO ES EL ALGORITMO FUNCIONAL DE LAS FIESTAS
                    );
                  }
              );
              break;
            case 3:
              return CupertinoTabView(
                  builder: (BuildContext context){
                    return BlocProvider<UserBloc>(
                      creator:(_context, _bag) =>UserBloc(),
                      child: ProfileScreen(), 
                    );
                  }
              );
              break;

          }

        },
      ),
    );
  }

}