import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:raktkhoj/components/ripple_indicator.dart';
import 'package:raktkhoj/screens/Chat/chat_list_screen.dart';
import 'package:raktkhoj/screens/admin.dart';
import 'package:raktkhoj/screens/doctor_oriented_pages/add_events.dart';
import 'package:raktkhoj/screens/doctor_oriented_pages/doctors_list.dart';
import 'package:raktkhoj/screens/home/map_view.dart';
import 'package:raktkhoj/screens/nearby_hospitals/nearby_hospital_screen.dart';
import 'package:raktkhoj/services/localization_service.dart';
import 'package:raktkhoj/screens/splash_screen.dart';
import 'package:raktkhoj/user_oriented_pages/be_a_donor.dart';
import 'package:raktkhoj/user_oriented_pages/page_guide.dart';

import '../../Colors.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      _child = _myWidget();
    });
  }

//loading user details
  Future<void> _loadCurrentUser() async {
    User _currentUser;
    _currentUser = await FirebaseAuth.instance.currentUser;
    setState(() {
      currentUser =_currentUser;
    });



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

  @override
  Future<void> initState() {
     super.initState();
    _child = RippleIndicator("");
     _loadCurrentUser();
     _fetchUserInfo();
     language = LocalizationService().getCurrentLang();
     _getAdmin();

  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, //top bar color
      systemNavigationBarColor: Colors.white, //bottom bar color
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return _child;
  }
  Widget _myWidget() {
    // print("admin:$admin");
    // print("current:${currentUser.uid}");

    return FutureBuilder(
        future: _getAdmin(),
      builder: (context, snapshot) {
      return Scaffold(
      backgroundColor: kMainRed,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          'Home'.tr,
          style: TextStyle(
            fontSize: 20.0,
            fontFamily: "SouthernAire",
            color: Colors.white,
          ),
        ),
        actions: [

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
                                padding: const EdgeInsets.all(1.0),
                                child: SafeArea(
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


            ListTile(
              title: Text("Add events"),
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
          child: MapView(),
        ),
      ),
    );
  }
    );
  }
}