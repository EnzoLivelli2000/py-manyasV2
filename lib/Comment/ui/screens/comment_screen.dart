import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manyas_v2/Comment/ui/widgets/other_comments_widget.dart';
import 'package:manyas_v2/Comment/ui/widgets/user_comment_widget.dart';
import 'package:manyas_v2/Party/model/party_model.dart';
import 'package:manyas_v2/User/bloc/user_bloc.dart';
import 'package:manyas_v2/User/model/user_model.dart';
import 'package:manyas_v2/widgets/title_header.dart';

class CommentScreen extends StatefulWidget {
  PartyModel partyModel;
  UserModel userModel;

  CommentScreen({Key key, @required this.partyModel, @required this.userModel});

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  UserBloc userBloc;
  String title_screen = 'Comments';
  Color title_color = new Color(0xFFF87125);
  final _controllerComment = TextEditingController();

  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);

    return Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              TitleScreen(context, title_screen),
              UserComment(),
              Divider(
                //height: 10,
                thickness: 3,
                indent: 20,
                endIndent: 20,
                color: Color(0xFFFF8E4A),
              ),
              OtherCommentWidget(),
              OtherCommentWidget(),
              OtherCommentWidget(),
              OtherCommentWidget(),
              OtherCommentWidget(),
              OtherCommentWidget(),
              OtherCommentWidget(),
            ],
          ),
          Container(
            margin:
            EdgeInsets.only(top: 25.0, right: 10, left: 10, bottom: 60),
            child: TextField(
              controller: _controllerComment,
              style: TextStyle(color: Colors.white),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                  fillColor: Color(0xFFFF8E4A),
                  border: InputBorder.none,
                  filled: true,
                  hintText: "Search ...",
                  hintStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF8E4A)),
                    borderRadius: BorderRadius.all(Radius.circular(9)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF8E4A)),
                    borderRadius: BorderRadius.all(Radius.circular(9)),
                  ),
                  suffixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  )),
            ),
          ),
        ],
    );
  }

  Container UserComment() {
    return Container(
      //margin: EdgeInsets.only(top: 10),
      alignment: Alignment.topCenter,
      child: UserCommentWidget(
        commentDescription: widget.partyModel.description,
        photoURL: widget.userModel.photoURL,
      ),
    );
  }

  Column ListOtherComment() {
    return Column(
      children: [
        ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: 20,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return OtherCommentWidget();
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(
            //thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
        ),
      ],
    );
  }

  Container TitleScreen(BuildContext context, String title_screen) {
    return Container(
      //margin: EdgeInsets.only(bottom: 5),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 25, left: 5),
            child: SizedBox(
              height: 45.0,
              width: 45.0,
              child: IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_left,
                  color: title_color,
                  size: 45,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          Flexible(
              child: Container(
            padding: EdgeInsets.only(top: 35, left: 20, right: 10),
            child: TitleHeader(
              title: title_screen,
              color_title: title_color,
            ),
          )),
        ],
      ),
    );
  }
}
