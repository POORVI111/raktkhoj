import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddTips extends StatefulWidget {


  @override
  _AddTipsState createState() => _AddTipsState();
}

class _AddTipsState extends State<AddTips> {


  TextEditingController titleController = TextEditingController();
  TextEditingController postController = TextEditingController();

  User user;
  String displayName;
  String username;

  String profilePhoto;


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();



  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;

    //fetching data of user from firebase
    FirebaseFirestore.instance.collection("User Details").doc(user.uid).get().then((value){
      //print(value.data());
      this.setState(() {
        username=value.data()["Name"].toString();

        profilePhoto=value.data()['ProfilePhoto'];




      });


    });
    displayName = username ;
  }

  @override
  void dispose() {

    titleController.dispose();
    postController.dispose();

    super.dispose();
  }

  checkValidAndThenPost(){
    String title = titleController.text;
    if (title.length == 0) {

      _scaffoldKey.currentState.hideCurrentSnackBar();

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Title is empty.'),
      ));
      return false;
    }
    String post=postController.text;
    if(post.length==0){
      _scaffoldKey.currentState.hideCurrentSnackBar();

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Post is empty'),
      ));
      return false;
    }
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

  addToDatabase() async{
    var time = DateTime.now().millisecondsSinceEpoch;
    String key = time.toString();
    final instance = FirebaseFirestore.instance;


    instance.collection('Post Details').doc(key).set({
      "creator": username,
      "creatorId":user.uid,
      //"mediaType": mediaType,
      //"mediaUrl": mediaURL,
      "title": titleController.text,
      "content": postController.text,
      "creatorPhoto":profilePhoto,

      "time": time,

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

  @override
  Widget build(BuildContext context) {
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
                        color: Colors.white)),
                onPressed: checkValidAndThenPost)
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
                        Text(username,
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
                            color: Theme
                                .of(context)
                                .buttonColor)))),
            SizedBox(height: 10),
            Expanded(child: TextField(
              controller: postController,
              maxLines: null,
              expands: true,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: 'Add tips here',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),),
          ])),
      //bottomNavigationBar: BottomAppBar(child: createBottomBar()),
    );
  }
}

