

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:raktkhoj/components/cached_image.dart';
import 'package:raktkhoj/components/ripple_indicator.dart';
import 'package:raktkhoj/model/event.dart';
import 'package:raktkhoj/model/post.dart';
import 'package:raktkhoj/model/user.dart';
import 'package:raktkhoj/screens/Chat/chat_list_screen.dart';
import 'package:raktkhoj/screens/Chat/chat_screen.dart';
import 'package:raktkhoj/screens/admin.dart';
import 'package:raktkhoj/screens/doctor_oriented_pages/add_events.dart';
import 'package:raktkhoj/screens/doctor_oriented_pages/add_tips_posts.dart';
import 'package:raktkhoj/screens/doctor_oriented_pages/doctors_list.dart';
import 'package:raktkhoj/screens/nearby_hospitals/nearby_hospital_screen.dart';
import 'package:raktkhoj/screens/splash_screen.dart';
import 'package:raktkhoj/services/localization_service.dart';
import 'package:raktkhoj/user_oriented_pages/events_list.dart';
import 'package:raktkhoj/user_oriented_pages/page_guide.dart';
import 'package:raktkhoj/user_oriented_pages/top_donors_list.dart';
//import 'package:readmore/readmore.dart';


import '../Colors.dart';
import 'be_a_donor.dart';



class Additional extends StatefulWidget {


  @override
  _AdditionalState createState() => _AdditionalState();
}

class _AdditionalState extends State<Additional> {

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  User currentUser;
  String _name, _bloodgrp, _email;
  Widget _child;
  List<String> _languages = ["English","हिंदी"];
  String language;
  String admin;


  //getting user info
  Future<Null> _fetchUserInfo() async {
    Map<String, dynamic> _userInfo;
    User _currentUser = await FirebaseAuth.instance.currentUser;

    DocumentSnapshot _snapshot = await FirebaseFirestore.instance
        .collection('User Details')
        .doc(_currentUser.uid)
        .get();

    _userInfo = _snapshot.data();

    this.setState(() {
      _name = _userInfo['Name'];
      _email = _userInfo['Email'];
      _bloodgrp = _userInfo['BloodGroup'];
      //_child = _myWidget();
    });
  }


  Future<User> getCurrentUser() async {
    User currentUser;
    currentUser = await _auth.currentUser;
    return currentUser;
  }

//loading user details
  Future<void> _loadCurrentUser() async {
    User _currentUser;
    _currentUser = await FirebaseAuth.instance.currentUser;
    setState(() {
      currentUser =_currentUser;
    });



  }

  //fetch all users
  Future<List<UserModel>> fetchAllUsers(User currentUser) async {
    List<UserModel> userList = <UserModel>[];

    QuerySnapshot querySnapshot =
    await _firestore.collection("User Details").orderBy('Donations',descending: true).limit(5).get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {

        userList.add(UserModel.fromMap(querySnapshot.docs[i].data()));

    }
    return userList;
  }

  //fetch all events
  Future<List<EventModel>> fetchAllEvents(User currentUser) async {
    List<EventModel> eventList = <EventModel>[];

    QuerySnapshot querySnapshot =
    await _firestore.collection("Event Details").orderBy('eventid',descending: true).get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {

        eventList.add(EventModel.fromMap(querySnapshot.docs[i].data()));

    }
    return eventList;
  }

  //fetch all posts
  Future<List<PostModel>> fetchAllPosts(User currentUser) async {
    List<PostModel> postList = <PostModel>[];

    QuerySnapshot querySnapshot =
    await _firestore.collection("Post Details").orderBy('time',descending: true).get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {

      postList.add(PostModel.fromMap(querySnapshot.docs[i].data()));

    }



    return postList;


  }
  
  

  //loading admin details
  Future<void> _getAdmin() async
  {
    String _admin;
    await FirebaseFirestore.instance.collection('Admin').doc('AdminLogin').get().then((value) =>
    _admin=value.data()['Aid'].toString());
    this.setState(() {
      admin=_admin;

    });
    //  print("admin: $admin");
  }


  List<UserModel> userList;
  List<EventModel> eventList;
  List<PostModel> postList;
  @override
  Future<void> initState() {
    super.initState();
    _child = RippleIndicator("");
    _loadCurrentUser();
    _fetchUserInfo();
    language = LocalizationService().getCurrentLang();
    _getAdmin();
    getCurrentUser().then((User user) {
      fetchAllUsers(user).then((List<UserModel> list) {
        setState(() {
          userList = list;
        });
      });
    });
    getCurrentUser().then((User user) {
      fetchAllEvents(user).then((List<EventModel> list) {
        setState(() {
          eventList = list;
        });
      });
    });
    getCurrentUser().then((User user) {
      fetchAllPosts(user).then((List<PostModel> list) {
        setState(() {
          postList = list;
        });
      });
    });


    }




  searchEvents()
  {
    final List<EventModel> suggestionList = (eventList!=null? eventList:[]);
    return Container(
      height: 300,
      child: ListView.builder(
          itemCount: suggestionList.length,
          scrollDirection: Axis.horizontal,
          //scrollDirection: Axis.horizontal,
          itemBuilder: ((context, index)

          {

            EventModel searchedEvent = EventModel(
                eventid: suggestionList[index].eventid,
              Name: suggestionList[index].Name,
              organiserUid:suggestionList[index].organiserUid,
                time: suggestionList[index].time,
                imageUrl: suggestionList[index].imageUrl,
                date : suggestionList[index].date,

            );


            return InkWell(
              splashColor: Colors.transparent,
              //onTap: callback,
              child: SizedBox(
                width: 280,
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          const SizedBox(
                            width: 48,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: kMainRed,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(16.0)),
                              ),
                              child: Row(
                                children: <Widget>[
                                  const SizedBox(
                                    width: 48 + 24.0,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(top: 16),
                                            child: Text(
                                              searchedEvent.Name,
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                letterSpacing: 0.27,
                                                color: kDarkerGrey,
                                              ),
                                            ),
                                          ),
                                          const Expanded(
                                            child: SizedBox(),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8, bottom: 8,left:20),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: <Widget>[
                                                //SizedBox(width: 40,),
                                                Icon(Icons.calendar_today , size: 18,),
                                                Text(
                                                  searchedEvent.date,
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w200,
                                                    fontSize: 14,
                                                    letterSpacing: 0.27,
                                                    color: kLightGrey,
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8,right: 8 , left:20),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: <Widget>[
                                                //SizedBox(width: 5,),
                                                Icon(Icons.timelapse , size: 18,),

                                                Text(
                                                  searchedEvent.time,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13,
                                                    letterSpacing: 0.27,
                                                    color: kBackgroundColor,
                                                  ),
                                                ),
                                                /*Container(
                                                  decoration: BoxDecoration(
                                                    color: kBackgroundColor,
                                                    borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(
                                                            8.0)),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets.all(
                                                        4.0),
                                                    child: Icon(
                                                      Icons.add,
                                                      color:kLightGrey,
                                                    ),
                                                  ),
                                                )*/
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5, right: 8, /*left: 8*/),
                                            child: Row(

                                              children: <Widget>[
                                                SizedBox(width: 48,),
                                                Text(
                                                  "Join",
                                                  textAlign:
                                                  TextAlign.right,
                                                  style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.w200,
                                                    fontSize: 15,
                                                    //letterSpacing: 0.27,
                                                    color:kLightGrey,
                                                  ),
                                                ),
                                                /*Icon(
                                                  Icons.star,
                                                  color:kBackgroundColor,
                                                  size: 20,
                                                ),*/
                                              ],
                                            ),

                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 24, bottom: 24, left: 16),
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius:
                              const BorderRadius.all(Radius.circular(8.0)),
                              child: AspectRatio(
                                  aspectRatio: 1.0,
                                  child: CachedImage(searchedEvent.imageUrl ,)),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );

            /*return Padding(padding: const EdgeInsets.all(2.0),
              child: InkWell(onTap: (){},
                child: Container(
                  width: 100.0,
                  child: ListTile(
                    title: CachedImage(searchedEvent.imageUrl,
                      height: 70,
                      width: 60,),
                    subtitle: Container(
                      alignment: Alignment.topCenter,
                      child: Text(searchedEvent.Name),
                    ),
                  ),
                ),
              ),);*/
          })

      ),
    );
  }

  getImage(String profilePhoto)
  {
    if(profilePhoto==null)
    {
        return CircleAvatar(
          radius: 20.0,
          backgroundImage: AssetImage('images/logo.png'),
          backgroundColor: kBackgroundColor,
        );
      }
    //return CachedImage(profilePhoto, radius: 20,);
    /*return CircleAvatar(
        backgroundImage:
        CachedNetworkImageProvider(profilePhoto),
        radius: 20.0,
        );*/
    return SizedBox(
      height: 40,
      width: 40,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CachedNetworkImage(
            imageUrl: profilePhoto,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => CircleAvatar(
              radius: 45.0,
              backgroundImage: AssetImage('images/logo.png'),
              backgroundColor: kBackgroundColor,
            ),
          )),
    );
  }


  searchPosts(){
    final List<PostModel> suggestionList = (postList!=null? postList:[]);
    
    return Container(
      child: ListView.builder(
        itemCount: suggestionList.length,
        scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemBuilder: ((context, index)
          {
            PostModel searchedPost = PostModel(
                creator: suggestionList[index].creator,
                creatorId: suggestionList[index].creatorId,
                title: suggestionList[index].title,
                time: suggestionList[index].time,
                content: suggestionList[index].content,
                creatorPhoto: suggestionList[index].creatorPhoto,
            );



                  return Padding(padding: const EdgeInsets.all(8.0),
                      child: InkWell(onTap: (){},
                        child:Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          // height:DeviceSize.height(context),
                          decoration: BoxDecoration(
                            /*border: Border.all(
                                width: 3.0,
                              color: kMainRed,
                            ),*/
                            borderRadius: BorderRadius.all(
                                Radius.circular(20.0)),
                              boxShadow: [BoxShadow(blurRadius: 2,color: kLightGrey)],

                          ),
                          child: Card(
                            child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(children: <Widget>[
                                  Container(
                                    /*decoration: BoxDecoration(

                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                      border: Border.all(
                                        width: 1.0,
                                        color: kMainRed,
                                      ),
                                      //boxShadow: [BoxShadow(blurRadius: 1,color: kBackgroundColor,offset: Offset(1,3))],

                                    ),*/

                                    child: Row(
                                        children: <Widget>[
                                      getImage(searchedPost.creatorPhoto),

                                      Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(searchedPost.title,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 18.0)
                                                ),
                                                Text(searchedPost.creator,
                                                    style: TextStyle(
                                                        color: kBackgroundColor,
                                                        fontSize: 13.0),
                                                    ),

                                              ]))
                                    ]),
                                  ),
                                  SizedBox(
                                      //width: 70,
                                      child: Divider(
                                        color: Colors.black,
                                        thickness: 1,
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Expanded(
                                      child: Text(
                                        searchedPost.content
                                      ),
                                    ),
                                  )

                                ])),
                          ),
                        ),
                      ),);

          })
      ),
    );
  }




  searchTopDonors()
  {
    final List<UserModel> suggestionList = (userList!=null? userList:[]);

    return Container(
      height: 150,
      child: ListView.builder(
          itemCount: suggestionList.length,
          scrollDirection: Axis.horizontal,
          //scrollDirection: Axis.horizontal,
          itemBuilder: ((context, index)
          {
            UserModel searchedUser = UserModel(
                uid: suggestionList[index].uid,
                profilePhoto: suggestionList[index].profilePhoto,
                name: suggestionList[index].name,
                email: suggestionList[index].email);

            return Padding(padding: const EdgeInsets.all(2.0),
              child: InkWell(onTap: (){},
                child: Container(
                  width: 150.0,
                  height: 200.0,
                  child: ListTile(
                    title: CachedImage(searchedUser.profilePhoto,
                    height: 100,
                    width: 70,),
                    subtitle: Container(
                      alignment: Alignment.topCenter,
                      child: Text(searchedUser.name),
                    ),
                  ),
                ),
              ),);
          })

      ),
    );


  }

  Widget topDonors(BuildContext context){

    return StreamBuilder(
      //proper query yet has to be written
        stream:FirebaseFirestore.instance
            .collection('User Details').snapshots(),

        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

          if (snapshot.data == null) {


            return Center(child: CircularProgressIndicator());
          }


          return ListView.builder(
            padding: const EdgeInsets.only(
                top: 0, bottom: 0, right: 16, left: 16),
            itemCount: snapshot.data.docs.length,
            //scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return DonorView(snapshot.data.docs[index],context);
              //final int count = snapshot.data.docs.length > 5
              //? 5
              //  :snapshot.data.docs.length;
              /*final int count =1;
              final Animation<double> animation =
              Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: animationController,
                      curve: Interval((1 / count) * index, 1.0,
                          curve: Curves.fastOutSlowIn)));
              animationController.forward();

              return DonorView(
                snapshot: snapshot.data.docs[index],
                animation: animation,
                animationController: animationController,
//callback: widget.callBack,
              );*/
            },
          );

        });

  }

  Widget DonorView(DocumentSnapshot snapshot ,BuildContext context  ){
    UserModel _donor = UserModel.fromMap(snapshot.data());

    InkWell(
      splashColor: Colors.transparent,
      //onTap: callback,
      child: SizedBox(
        width: 280,
        child: Stack(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    width: 48,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 24, bottom: 24, left: 16),
                      child: Row(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(16.0)),
                            child: AspectRatio(
                                aspectRatio: 1.0,
                                child: CachedImage(_donor.profilePhoto , height: 70,width: 60,)),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: kMainRed,
                        borderRadius: const BorderRadius.all(
                            Radius.circular(16.0)),
                      ),
                      child: Row(
                        children: <Widget>[
                          const SizedBox(
                            width: 48 + 24.0,
                          ),
                          Expanded(
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(top: 16),
                                    child: Text(
                                      _donor.name,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        letterSpacing: 0.27,
                                        color: kDarkerGrey,
                                      ),
                                    ),
                                  ),
                                  const Expanded(
                                    child: SizedBox(),
                                  ),



                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:  AppBar(
      elevation: 0.1,
      //elevation: 0.0,
      centerTitle: true,
      backgroundColor: kMainRed,
      title: Text(
        'Raktkhoj',
        style: TextStyle(
          fontSize: 20.0,
          fontFamily: "SouthernAire",
          color: Colors.white,
        ),
      ),
      actions: [

        //new IconButton(icon: Icon(Icons.search , color: Colors.white,), onPressed: (){}),
        new IconButton(icon: Icon(Icons.chat , color: Colors.white,), onPressed: (){
          Navigator.push(context,
              MaterialPageRoute(builder: (context) =>ChatListPage()));
        }),

        //adding multi language feature

      ],
    ),

      //drawer for more options
      /*drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0.0),
          children: <Widget>[
            //showing email id , name , blood group of user here
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: kMainRed,
              ),
              accountName: Text(
                currentUser == null ? "" : _name,
                style: TextStyle(
                  fontSize: 22.0,
                ),
              ),
              accountEmail: Text(currentUser == null ? "" : _email),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  currentUser == null ? "" : _bloodgrp,
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.black54,
                    fontFamily: 'SouthernAire',
                  ),
                ),
              ),
            ),

            //option to go back to home
            ListTile(
              title: Text("Home".tr),
              leading: Icon(
                FontAwesomeIcons.home,
                color: kMainRed,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PageGuide()));
              },
            ),

            //to enter admin zone
            if(admin==currentUser.uid)
              ListTile(
                title: Text("Admin Panel".tr),
                leading: Icon(
                  FontAwesomeIcons.userShield,
                  color: kMainRed,
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Admin()));
                },
              ),

            //to enable/disable donor option
            ListTile(
              title: Text("Be a Donor".tr),
              leading: Icon(
                FontAwesomeIcons.handshake,
                color: kMainRed,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BeDonor()));
              },
            ),
            ListTile(
              title: Text("Blood Requests".tr),
              leading: Icon(
                FontAwesomeIcons.burn,
                color: kMainRed,
              ),
              onTap: () {
                //
              },
            ),

            //to check near by hospitals and their location on map
            ListTile(
              title: Text("Nearby Hospitals".tr),
              leading: Icon(
                FontAwesomeIcons.hospital,
                color: kMainRed,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NearbyHospitalPage()));
              },
            ),

            //option to chat with other users
            ListTile(
              title: Text("Chats".tr),
              leading: Icon(
                FontAwesomeIcons.comments,
                color: kMainRed,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>ChatListPage()));
              },
            ),

            //to interact with doctors in emergency conditions
            ListTile(
              title: Text("Doctors".tr),
              leading: Icon(
                FontAwesomeIcons.userNurse,
                color: kMainRed,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>DoctorsList()));
              },
            ),
            //to schedule events in emergency conditions
            ListTile(
              title: Text("add events".tr),
              leading: Icon(
                FontAwesomeIcons.userNurse,
                color: kMainRed,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>AddEvents()));
              },
            ),

            //logout functionality
            ListTile(
              title: Text("Logout".tr),
              leading: Icon(
                FontAwesomeIcons.signOutAlt,
                color: kMainRed,
              ),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SplashScreen()));
              },
            ),
          ],
        ),
      ),*/
      body: new ListView(
          children: <Widget>[
            Container(
              child: Text("Top Donors" ,
               style:TextStyle(
                   fontSize: 20,
                   fontFamily: 'nunito',
                   color: Colors.black)),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: searchTopDonors(),
            ),
            Container(
              child: Text("Events",
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'nunito',
                  color: Colors.black),),
            ),
             Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: Container(
                height: 143,
                width: double.infinity,
                child: searchEvents(),),),
            Container(
              child: Text("Tips and Information",
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'nunito',
                    color: Colors.black),),
            ),
            searchPosts(),



          ],

      ),
      floatingActionButton: FloatingActionButton(onPressed: () { Navigator.push(
        context,

        MaterialPageRoute(builder: (context) => AddTips()),
      ); },
        backgroundColor: kMainRed,
        child: const Icon(FontAwesomeIcons.feather),),

    );
  }
  /*@override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, //top bar color
      systemNavigationBarColor: Colors.white, //bottom bar color
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return _child;
  }*/

  /*Widget _myWidget() {
    // print("admin:$admin");
    // print("current:${currentUser.uid}");

    return FutureBuilder(
        future: _getAdmin(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: kMainRed,
            appBar: AppBar(
              elevation: 0.1,
              //elevation: 0.0,
              centerTitle: true,
              backgroundColor: kMainRed,
              title: Text(
                'Raktkhoj',
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: "SouthernAire",
                  color: Colors.white,
                ),
              ),
              actions: [

                new IconButton(icon: Icon(Icons.search , color: Colors.white,), onPressed: (){}),
                new IconButton(icon: Icon(Icons.chat , color: Colors.white,), onPressed: (){}),

                //adding multi language feature
                 IconButton(
                  icon: Icon(
                    FontAwesomeIcons.globe,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 1.5,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Please Select Your Language",
                                          style: TextStyle(
                                              color: kMainRed,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15)),
                                    ),
                                    Text("कृपया अपनी भाषा चुनें",
                                        style: TextStyle(
                                            color: kMainRed,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: MediaQuery.of(context).size.height /
                                          2.5,
                                      child: ListView.builder(
                                          itemCount: _languages.length,
                                          itemBuilder: (context, index) {
                                            return Column(
                                              children: [
                                                ListTile(
                                                  focusColor: Colors.blue,
                                                  hoverColor: Colors.blue,
                                                  onTap: () {
                                                    setState(()  {
                                                      language = _languages[index];
                                                      LocalizationService().changeLocale(language);
                                                      language = LocalizationService().getCurrentLang();
                                                    });
                                                  },
                                                  title: Center(
                                                      child: Text(_languages[index],
                                                        style:  TextStyle(color: language== _languages[index] ? kMainRed: Colors.black),
                                                      )),
                                                ),
                                                Divider()
                                              ],
                                            );
                                          }),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: 100,
                                        height: 50,
                                        child: RaisedButton(
                                            color: kMainRed,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(30)),
                                            child: Center(
                                              child: Text(
                                                "Ok".tr,
                                                style:
                                                TextStyle(color: Colors.white),
                                              ),
                                            ),
                                            onPressed: () {
                                              //_changelanguage(language);
                                              Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> PageGuide()));
                                            }),
                                      ),
                                    )
                                  ]));
                        });
                  },
                ),
              ],
            ),
            //drawer for more options
            drawer: Drawer(
              child: ListView(
                padding: const EdgeInsets.all(0.0),
                children: <Widget>[
                  //showing email id , name , blood group of user here
                  UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: kMainRed,
                    ),
                    accountName: Text(
                      currentUser == null ? "" : _name,
                      style: TextStyle(
                        fontSize: 22.0,
                      ),
                    ),
                    accountEmail: Text(currentUser == null ? "" : _email),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text(
                        currentUser == null ? "" : _bloodgrp,
                        style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.black54,
                          fontFamily: 'SouthernAire',
                        ),
                      ),
                    ),
                  ),

                  //option to go back to home
                  ListTile(
                    title: Text("Home".tr),
                    leading: Icon(
                      FontAwesomeIcons.home,
                      color: kMainRed,
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => PageGuide()));
                    },
                  ),

                  //to enter admin zone
                  if(admin==currentUser.uid)
                    ListTile(
                      title: Text("Admin Panel".tr),
                      leading: Icon(
                        FontAwesomeIcons.userShield,
                        color: kMainRed,
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Admin()));
                      },
                    ),

                  //to enable/disable donor option
                  ListTile(
                    title: Text("Be a Donor".tr),
                    leading: Icon(
                      FontAwesomeIcons.handshake,
                      color: kMainRed,
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => BeDonor()));
                    },
                  ),
                  ListTile(
                    title: Text("Blood Requests".tr),
                    leading: Icon(
                      FontAwesomeIcons.burn,
                      color: kMainRed,
                    ),
                    onTap: () {
                      //
                    },
                  ),

                  //to check near by hospitals and their location on map
                  ListTile(
                    title: Text("Nearby Hospitals".tr),
                    leading: Icon(
                      FontAwesomeIcons.hospital,
                      color: kMainRed,
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => NearbyHospitalPage()));
                    },
                  ),

                  //option to chat with other users
                  ListTile(
                    title: Text("Chats".tr),
                    leading: Icon(
                      FontAwesomeIcons.comments,
                      color: kMainRed,
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>ChatListPage()));
                    },
                  ),

                  //to interact with doctors in emergency conditions
                  ListTile(
                    title: Text("Doctors".tr),
                    leading: Icon(
                      FontAwesomeIcons.userNurse,
                      color: kMainRed,
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>DoctorsList()));
                    },
                  ),
                  //to schedule events in emergency conditions
                  ListTile(
                    title: Text("add events".tr),
                    leading: Icon(
                      FontAwesomeIcons.userNurse,
                      color: kMainRed,
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>AddEvents()));
                    },
                  ),

                  //logout functionality
                  ListTile(
                    title: Text("Logout".tr),
                    leading: Icon(
                      FontAwesomeIcons.signOutAlt,
                      color: kMainRed,
                    ),
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SplashScreen()));
                    },
                  ),
                ],
              ),
            ),
            body: ClipRRect(
              borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(40.0),
                  topRight: const Radius.circular(40.0)),
              child: Container(
                height: 800.0,
                width: double.infinity,
                color: Colors.white,
                child: new ListView(
                  children: <Widget>[
                    new Padding(padding: const EdgeInsets.all(8.0),
                        child: new Text('Events',style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'nunito',
                            color: Colors.black))),
                    //image carousel begins here
                    //image_carousel,
                    EventsList(),
                    //image_carousel
                    //padding widget
                    new Padding(padding: const EdgeInsets.all(8.0),
                      child: new Text('Top Donors',style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'nunito',
                            color: Colors.black))),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: searchTopDonors(),
                    ),


                    //providing horizontal list view
                     /* Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: Container(
                          height: 134,
                          width: double.infinity,
                          child:topDonors(context),
                        ),
                      ),*/
                    //TopDonorsList(),
                    //padding widget
                    new Padding(padding: const EdgeInsets.all(30.0),
                      child: new Text('Information and Tips'),),

                    //gridview
                    Container(
                      height: 320.0,
                      //to add posts done by doctors here
                      //child: Products(),
                    )

                  ],
                ),
              ),
            ),
          );
        }
    );
  }*/
}
