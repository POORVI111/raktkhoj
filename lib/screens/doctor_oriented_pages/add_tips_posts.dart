import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:raktkhoj/components/cached_image.dart';
import 'package:zefyr/zefyr.dart';

class CreatePost extends StatefulWidget {


  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {

  ZefyrController _controller;
  TextEditingController titleController = TextEditingController();
  FocusNode _focusNode;
  User user;
  String displayName;
  String username;
  String noticeText;
  String profilePhoto;
  String mediaURL;
  int mediaType = 0; // 0 for none, 1 for image, 2 for video
  File media;
  //List<RadioButtonData> radioButtonDataList;
  String community;
  int selectedId = -1;
  List listOfMedia;
  String fileName;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ZefyrField editor;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    //displayName = username = user.displayName;
    //getNameFromSharedPreference();
    mediaType = 0;
    final document = _loadDocument();
    _controller = ZefyrController(document);
    _focusNode = FocusNode();
    noticeText = "Add media to your post";
    //radioButtonDataList = [];
    listOfMedia = [];
    //fetching data of user from firebase
    FirebaseFirestore.instance.collection("User Details").doc(user.uid).get().then((value){
      //print(value.data());
      this.setState(() {
        username=value.data()["Name"].toString();
        //email=value.data()["Email"].toString();
        //dob=value.data()["Dob"].toString();
        //btype=value.data()["BloodGroup"].toString();
        //mc=value.data()["Condition"].toString();
        //contact=value.data()["Contact"].toString();
        //height=value.data()["Height"];
        profilePhoto=value.data()['ProfilePhoto'];

        //weight=value.data()["Weight"] ;

        //age=value.data()["Age"];



      });

      //name=value.data()["Name"].toString();
    });
    displayName = username ;
  }

  @override
  void dispose() {
    _controller.dispose();
    titleController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  NotusDocument _loadDocument(){
    final Delta delta=Delta()..insert("Zefyr quick Start\n");
    return NotusDocument.fromDelta(delta);
  }

  // This will check if post is created correctly and then will post it
  checkPostableAndPost() {
    /*if (community == null || community.length == 0) {
      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('No communities selected.'),
      ));
      return false;
    }*/
    String title = titleController.text;
    if (title.length == 0) {

      _scaffoldKey.currentState.hideCurrentSnackBar();

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Title is empty.'),
      ));
      return false;
    }
    String content = jsonEncode(_controller.document);
    if (content.length == 0) {

      _scaffoldKey.currentState.hideCurrentSnackBar();
      
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('No text written.'),
      ));
      return false;
    }
    // ignore: deprecated_member_use
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: Duration(hours: 1),
      content: Row(
        children: <Widget>[
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
          ),
          SizedBox(
            width: 15,
          ),
          Text("Uploading...")
        ],
      ),
    ));
    addToDatabase();
    return true;
  }

  // This will add post to database
  addToDatabase() async {
    var time = DateTime.now().millisecondsSinceEpoch;
    String key = time.toString();
    final instance = FirebaseFirestore.instance;
    //mediaURL = null;
    //if (mediaType != 0) await uploadMedia(key);
    List<String> titleSearchList = List();
    String titleInLower = titleController.text.toLowerCase();
    String temp = "";
    for (int i = 0; i < titleInLower.length; i++) {
      temp = temp + titleInLower[i];
      titleSearchList.add(temp);
    }
    instance.collection('Post Details').doc(key).set({
      "creator": username,
      "creatorId":user.uid,
      //"mediaType": mediaType,
      //"mediaUrl": mediaURL,
      "title": titleController.text,
      "content": jsonEncode(_controller.document),
      //"viewers": [],
      "time": time,
      //"upvoters": [],
      //"weight": 0,
      //"downvoters": [],
      //"downvotes": 0,
      //"upvotes": 0,
      //"views": 0,
      "titleSearch": titleSearchList,
      //"commentCount": 0,
      //"lastModified": time,
      //"listOfMedia": listOfMedia,
      //"isVerified": false,
      //'reports': 0,
      //'reporters': [],
      //"community": community,
    }).then((action) async {
      debugPrint("successful posting!");

      //await sendVerificationNotifications(community, key, username);
      //await updateHotness(community, key);

      debugPrint('successful posting in user');
      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Upload complete!'),
      ));

      /*await instance.collection('users/$username/posts').doc('posted').update({
        community: FieldValue.arrayUnion([key])
      });*/
      Navigator.pop(context);
    });
  }


  Widget build(BuildContext context) {

    editor = ZefyrField(
      focusNode: _focusNode,
      controller: _controller,
      //imageDelegate: MyAppZefyrImageDelegate(),
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Enter text Here...',
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).buttonColor),
        ),
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text('Add Tips or Info',
              style: TextStyle(fontWeight: FontWeight.bold)),
          actions: <Widget>[
            FlatButton(
                child: Text('Post',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).accentColor)),
                onPressed: checkPostableAndPost)
          ]),
      body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(children: <Widget>[
            Row(children: <Widget>[
              CircleAvatar(
                  backgroundImage:
                  CachedNetworkImageProvider(profilePhoto),
                  radius: 30.0,
                  backgroundColor: Colors.grey),
              Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(displayName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0)),

                      ]))
            ]),
            TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                    hintText: 'Enter title here',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).buttonColor)))),
            SizedBox(height: 10),
            Expanded(child: ZefyrScaffold(child:editor,
              /*ZefyrEditor(
              padding: EdgeInsets.all(16),
              controller: _controller,
              focusNode: _focusNode,
            )*/))
          ])),
      //bottomNavigationBar: BottomAppBar(child: createBottomBar()),
    );
  }
  /*@override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Add Tips and Info"),
        ),
        body: Container(
          child: ZefyrScaffold(
            child: ZefyrEditor(
              padding: EdgeInsets.all(16),
              controller: _controller,
              focusNode: _focusNode,
            ),
          ),
        ),
      ),
    );
  }*/
}



