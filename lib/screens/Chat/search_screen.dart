/*
this is created to search users
*/


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:raktkhoj/Colors.dart';
import 'package:raktkhoj/components/cached_image.dart';
import 'package:raktkhoj/model/user.dart';
import 'package:raktkhoj/screens/Chat/chat_screen.dart';


class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User> getCurrentUser() async {
    User currentUser;
    currentUser = await _auth.currentUser;
    return currentUser;
  }

  Future<List<UserModel>> fetchAllUsers(User currentUser) async {
    List<UserModel> userList = <UserModel>[];

    QuerySnapshot querySnapshot =
    await _firestore.collection("User Details").get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != currentUser.uid) {
        userList.add(UserModel.fromMap(querySnapshot.docs[i].data()));
      }
    }
    return userList;
  }

  List<UserModel> userList;
  String query = "";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    getCurrentUser().then((User user) {
      fetchAllUsers(user).then((List<UserModel> list) {
        setState(() {
          userList = list;
        });
      });
    });
  }

  searchAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: kMainRed,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(FontAwesomeIcons.reply, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      elevation: 0,
      title: Text("Search", style: TextStyle(color: Colors.white),),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: TextField(
            controller: searchController,
            onChanged: (val) {
              setState(() {
                query = val;
              });
            },
            cursorColor: Colors.black,
            autofocus: true,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 20,
            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.close, color: Colors.black),
                onPressed: () {
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => searchController.clear());
                },
              ),
              border: InputBorder.none,
              hintText: "Type here to search",
              hintStyle: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }


//returns list view of queried users
  searchUserList(String query) {
    final List<UserModel> suggestionList = query.isEmpty
    ? (userList!=null? userList:[])
    : userList != null?
    userList.where((UserModel user) {
    if (query != null || user.email != null || user.name != null) {
    String _getUsername = user.email.toLowerCase();
    String _query = query.toLowerCase();
    String _getName = user.name.toLowerCase();
    bool matchesUsername = _getUsername.contains(_query);
    bool matchesName = _getName.contains(_query);

    return (matchesUsername || matchesName);
    } else { return false; }

    }).toList()
        : [];

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: ((context, index) {
      UserModel searchedUser = UserModel(
      uid: suggestionList[index].uid,
      profilePhoto: suggestionList[index].profilePhoto,
      name: suggestionList[index].name,
      email: suggestionList[index].email);


      return GestureDetector(
         onTap: () { Navigator.push(context,
        MaterialPageRoute(
        builder: (context) => ChatScreen(receiver: searchedUser,)));
         },
        child: Container(
        padding: EdgeInsets.symmetric(horizontal: false ? 10 : 0),
          child: Row(
          children: <Widget>[
            CachedImage(
            searchedUser.profilePhoto,
            radius: 35,
            isRound: true,
            ),
            Expanded(
              child: Container(
              margin: EdgeInsets.only(left: false ? 10 : 15),
              padding: EdgeInsets.symmetric(vertical: false ? 3 : 15),
              decoration: BoxDecoration(
              border: Border(
              bottom: BorderSide(
              width: 1,
              color:Colors.grey))),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(searchedUser.email, style: TextStyle(color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    ),
                    ),
                    SizedBox(height: 5),
                    Row(
                    children: <Widget>[
                      Text(
                      searchedUser.name,
                      style: TextStyle(color: Colors.black),
                      ),
                    ],)
                  ],),

            ],
            ),
            ),
            )
        ],
        ),
        ),


        );
      })
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: searchAppBar(context),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: searchUserList(query),
      ),
    );
  }


}
