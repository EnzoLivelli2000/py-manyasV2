import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:manyas_v2/Party/ui/screens/prueba_party.dart';
import 'package:manyas_v2/Post/ui/screens/home_posts.dart';
import 'package:manyas_v2/User/bloc/user_bloc.dart';
import 'package:manyas_v2/User/ui/screens/profile_screen.dart';
import 'package:manyas_v2/User/ui/screens/search_people_screen.dart';

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
                      child: HomePost(),
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