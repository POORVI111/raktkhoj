//page to show different options to user
//to enable certain features and head towards profile thorugh this page
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raktkhoj/colors.dart';
import 'package:raktkhoj/components/cached_image.dart';
import 'package:raktkhoj/screens/doctor_oriented_pages/add_events.dart';
import 'package:raktkhoj/screens/doctor_oriented_pages/doctor_info.dart';
import 'package:raktkhoj/user_oriented_pages/be_a_donor.dart';
import 'package:raktkhoj/user_oriented_pages/my_donations.dart';
import 'package:raktkhoj/user_oriented_pages/profile.dart';

class ExtraPage extends StatefulWidget {

  @override
  _ExtraPageState createState() => _ExtraPageState();
}

class _ExtraPageState extends State<ExtraPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String username;
  String profilePhoto;
  String email;

  @override
  void initState()
  {
    final firestoreInstance =  FirebaseFirestore.instance;

    var firebaseUser =  FirebaseAuth.instance.currentUser;


    //fetching data of user from firebase
    firestoreInstance.collection("User Details").doc(firebaseUser.uid).get().then((value){
      //print(value.data());
      this.setState(() {
        username=value.data()["Name"].toString();
        email=value.data()["Email"].toString();

        profilePhoto=value.data()['ProfilePhoto'];
      });
      //name=value.data()["Name"].toString();
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,

        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(45),
              ),
            gradient: LinearGradient(
              colors: [kBackgroundColor,kMainRed, ],
              tileMode: TileMode.mirror,
              begin: Alignment.topRight,
              end: Alignment.topLeft,

            ),
          ),
          child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, bottom: 0, top: 0,right: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 50,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 90,
                                  width: 90,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white.withOpacity(0.2), width: 2)),
                                  padding: EdgeInsets.all(5.5),
                                  //color: kBackgroundColor,
                                  child: CachedImage(
                                    profilePhoto,
                                    //null,
                                    radius: 45,
                                    isRound: true,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      username!=null?username:"--",
                                      style: GoogleFonts.montserrat(
                                          fontSize: 13,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(height: 2,),
                                    Text(
                                      email!=null?email:"--",
                                      style: GoogleFonts.montserrat(
                                          fontSize: 10,letterSpacing: 1,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ],

                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 50,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            width: 100,
                            height: 100,
                            child: Center(
                              child: Card(
                                elevation: 8,
                                child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BeDonor()));
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0,
                                              bottom: 8.0,
                                              left: 20,
                                              right: 20),
                                          child: Text(
                                            'Be a Donor',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                        Icon(
                                          FontAwesomeIcons.handshake,
                                          //color: kMainRed,
                                        ),

                                      ],
                                    )),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            width: 100,
                            height: 100,
                            child: Center(
                              child: Card(
                                  elevation: 8,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Profile()));
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0,
                                              bottom: 8.0,
                                              left: 20,
                                              right: 20),
                                          child: Text(
                                            'Profile',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                        Icon(Icons.person)
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            width: 100,
                            height: 100,
                            child: Center(
                              child: Card(
                                elevation: 8,
                                child: InkWell(
                                    onTap: () {
                                      Navigator.push(context,MaterialPageRoute(
                                        builder: (context) => MenuPager(type: "donations",),
                                      ));

                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0,
                                              bottom: 8.0,
                                              left: 10,
                                              right: 10),
                                          child: Text(
                                            'Donation\n history',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                        Icon(
                                          Icons.history,
                                        ),

                                      ],
                                    )),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            width: 100,
                            height: 100,
                            child: Center(
                              child: Card(
                                  elevation: 8,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MenuPager(type: "requests",)));
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0,
                                              bottom: 8.0,
                                              left: 10,
                                              right: 10),
                                          child: Text(
                                            'Requests\nHistory',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                        Icon( Icons.subject,)
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            width: 100,
                            height: 100,
                            child: Center(
                              child: Card(
                                elevation: 8,
                                child: InkWell(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => DoctorInfo()));

                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0,
                                              bottom: 8.0,
                                              left: 10,
                                              right: 10),
                                          child: Text(
                                            'Doctors\n Hub',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                        Icon(
                                          Icons.volunteer_activism,
                                          //color: kMainRed,
                                        ),

                                      ],
                                    )),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            width: 100,
                            height: 100,
                            child: Center(
                              child: Card(
                                  elevation: 8,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddEvents()));
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0,
                                              bottom: 8.0,
                                              left: 10,
                                              right: 10),
                                          child: Text(
                                            'Add Events',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                        Icon(Icons.event),
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),


                  ],
                ),


            ),


    );
  }
}

