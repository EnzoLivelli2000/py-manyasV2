import 'package:bloc_provider/bloc_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manyas_v2/Party/ui/screens/prueba_party.dart';
import 'package:manyas_v2/Post/model/post_model.dart';
import 'package:manyas_v2/Post/ui/widgets/card_image.dart';
import 'package:manyas_v2/Post/ui/widgets/post_design.dart';
import 'package:manyas_v2/Post/ui/widgets/post_friend_design.dart';
import 'package:manyas_v2/Storie/ui/screens/prueba_storie.dart';
import 'package:manyas_v2/User/bloc/user_bloc.dart';
import 'package:manyas_v2/User/model/user_model.dart';

class HomeContent extends StatelessWidget {
  UserBloc userBloc;
  UserModel userModel;
  int index;

  HomeContent(this.userModel, this.index);

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);
    switch (index) {
      case 0:
        return PostContentAux();
        //PostDesign(postModel2, userModel);
        break;
      case 1:
        return PruebaStorie();
        break;
      case 2:
        return PruebaParty();
        break;
    }
  }

  Widget PostContentAux() {
    return StreamBuilder(
      stream: userBloc.myFriendsListStream1,
      builder: (context, AsyncSnapshot<List<DocumentReference>> snapshot) {
        final posts = snapshot.data ?? [];
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container(
              margin: EdgeInsets.only(top: 120),
              alignment: Alignment.center,
              child: Text(
                'Loading ...',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          case ConnectionState.none:
            return Container(
              margin: EdgeInsets.only(top: 120),
              alignment: Alignment.center,
              child: Text(
                'Loading ...',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          case ConnectionState.done:
            print('snapshot -> ${snapshot}');
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (_, i){
                return FutureBuilder<List<PostFriendDesign>>(
                  future: userBloc.buildPosts(posts[i], userModel), // function where you call your api
                  builder: (BuildContext context, AsyncSnapshot<List<PostFriendDesign>> snapshot) {  // AsyncSnapshot<Your object type>
                    if( snapshot.connectionState == ConnectionState.waiting){
                      return Container(
                        margin: EdgeInsets.only(top: 120),
                        alignment: Alignment.center,
                        child: Text(
                          '',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25.0,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }else{
                      if (snapshot.hasError)
                        return Container(
                          margin: EdgeInsets.only(top: 120),
                          alignment: Alignment.center,
                          child: Text(
                            '',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25.0,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      else {
                        return Column(
                          children: snapshot.data,
                        );
                      }
                        return Center(child: new Text('${snapshot.data}'));  // snapshot.data  :- get your object which is pass from your downloadData() function
                    }
                  },
                );
              },
            );
            break;
          case ConnectionState.active:
            print('snapshot -> ${snapshot}');
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (_, i){
                return FutureBuilder<List<PostFriendDesign>>(
                  future: userBloc.buildPosts(posts[i], userModel), // function where you call your api
                  builder: (BuildContext context, AsyncSnapshot<List<PostFriendDesign>> snapshot) {  // AsyncSnapshot<Your object type>
                    if( snapshot.connectionState == ConnectionState.waiting){
                      return Container(
                        margin: EdgeInsets.only(top: 120),
                        alignment: Alignment.center,
                        child: Text(
                          '',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25.0,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }else{
                      if (snapshot.hasError)
                        return Container(
                          margin: EdgeInsets.only(top: 120),
                          alignment: Alignment.center,
                          child: Text(
                            '',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25.0,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      else {
                        return Column(
                          children: snapshot.data,
                        );
                      }
                      return Center(child: new Text('${snapshot.data}'));  // snapshot.data  :- get your object which is pass from your downloadData() function
                    }
                  },
                );
              },
            );
            break;
          default:
            return CircularProgressIndicator();
        }
      },
    );
  }

  Widget PostContent() {
    return StreamBuilder<List<DocumentSnapshot>>(
      stream: FirebaseFirestore.instance.collection('users').document(userModel.uid).snapshots().asyncMap((snap) async {
        List<String> groceryListsArr = snap.data()['myFriends'];
        var groceryList = <DocumentSnapshot>[];
        for (var groceryPath in groceryListsArr) {
          groceryList.add(await FirebaseFirestore.instance.document(groceryPath).get());
        }
        print('groceryList ----------> ${groceryList}');
        return groceryList;
      }),
      builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container(
              margin: EdgeInsets.only(top: 120),
              alignment: Alignment.center,
              child: Text(
                'Loading ...',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          case ConnectionState.none:
            return Container(
              margin: EdgeInsets.only(top: 120),
              alignment: Alignment.center,
              child: Text(
                'Loading ...',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          case ConnectionState.done:
           /* return Column(
              children: userBloc.buildPostsEE(snapshot.data,userModel)
            );*/
            //return listViewPosts(userBloc.buildMyFriendPosts2(snapshot.data.documents, userModel), userModel);
            break;
          case ConnectionState.active:
            /*return Column(
                children: userBloc.buildPostsEE(snapshot.data,userModel)
            );*/
            //return listViewPosts(userBloc.buildMyFriendPosts2(snapshot.data.documents, userModel), userModel);
            break;
          default:
            return CircularProgressIndicator();
        }
      },
    );
  }

  Widget listViewPosts(List<PostModel> posts, UserModel usermodel){

    return ListView(
      padding: EdgeInsets.all(10.0),
      scrollDirection: Axis.vertical,
      children: posts.map((post){
        return GestureDetector(
          onTap: (){
            print("CLICK PLACE: ${post.pid}");
            //userBloc.placeSelectedSink.add(place);
          },
          child: PostFriendDesign(
              PostModel(
                  description: post.description,
                  V_I: post.V_I,
                  likes: post.likes,
                  location: post.location,
                  status: post.status,
                  dateTimeid: post.dateTimeid,
              ),
              userModel)
        );
      }).toList(),
    );
  }
}
