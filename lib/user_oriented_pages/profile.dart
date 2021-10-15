import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:redlink/compatability.dart';
//import 'package:redlink/home_page.dart';
import 'package:raktkhoj/Constants.dart';
//import 'page_guide.dart';
import 'package:raktkhoj/Colors.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:raktkhoj/screens/home/Home_screen.dart';

import 'package:raktkhoj/user_oriented_pages/faq.dart';


var _firebaseref = FirebaseDatabase().reference().child('User');

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}
var name;
var email;
var req;
var donations;
var dob;
var btype;
var mc;
var contact;
var userid;


class _ProfileState extends State<Profile> {
  int height = 173;
  int age = 20;
  int weight = 58;
  String name;
  bool showSpinner = false;

  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  bool isActive = false;
  @override
  void initState()  {


    loggedInUser=_auth.currentUser;
    super.initState();

    isActive = true;
    userid=loggedInUser.uid;

    //demo data
    name="XYZ_user";
    req="1";
    donations="0";
    dob="23/12/2001";
    btype="B+";
    mc="normal";
    contact="9140637711";

    //loggedInUser=_auth.currentUser;
    //isActive = true;
    //userid=loggedInUser.uid;
    final firestoreInstance =  FirebaseFirestore.instance;

    var firebaseUser =  FirebaseAuth.instance.currentUser;
    firestoreInstance.collection("User Details").doc(firebaseUser.uid).get().then((value){
      //print(value.data());
      this.setState(() {
        name=value.data()["Name"].toString();
        email=value.data()["Email"].toString();
        dob=value.data()["Dob"].toString();
        btype=value.data()["BloodGroup"].toString();
        mc=value.data()["Condition"].toString();
        contact=value.data()["Contact"].toString();
        height=value.data()["Height"];

        weight=value.data()["Weight"] ;

        age=value.data()["Age"];



      });
      //name=value.data()["Name"].toString();
    });
    /*_firebaseref.child("${userid}").once().then((DataSnapshot snapshot) {
      name = snapshot.value["Name"].toString();
      req = snapshot.value["Requests"].toString();
      donations = snapshot.value["Donations"].toString();
      dob = snapshot.value["Dob"].toString();
      btype = snapshot.value["BloodType"].toString();
      mc = snapshot.value["MedCondition"].toString();
      contact = snapshot.value["Phone"].toString();
      setState(() {});
    });*/



    showSpinner = false;
  }

  @override
  void dispose() {
    super.dispose();
    isActive = false;
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
              colors: [Color(0xFFE53033),Color(0xFFBC002D), ],
              tileMode: TileMode.mirror,
              begin: Alignment.topRight,
              end: Alignment.topLeft,

            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, bottom: 0, top: 0),
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
                              child: CircleAvatar(
                                radius: 45.0,
                                backgroundImage: AssetImage('images/logo.png'),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name!=null?name:"--",
                                  style: GoogleFonts.montserrat(
                                      fontSize: 13,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 2,),
                                Text(
                                  "RAKTKHOJ",
                                  style: GoogleFonts.montserrat(
                                      fontSize: 10,letterSpacing: 1,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            SizedBox(width: 75,),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RoundIconButton(icon: Icons.mode_edit, onPressed: (){
                                displayOverlay(context);
                                //EDIT PROFILE
                              }),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(children: [
                          SizedBox(width: 15,),
                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(color:Colors.white),
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Center(child: Text('${req!='null'?req:'0'} Requests',style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),)),
                            ),
                          ),
                          SizedBox(width: 15,),
                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(color:Colors.white),
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Center(child: Text('${donations!='null'?donations:'0'} Donations',style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),)),
                            ),
                          ),
                          SizedBox(width: 25,),
                        ],),
                        SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFfffffff),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(45),
                        topLeft: Radius.circular(45)),
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 7.7, top: 20),
                              child: Container(
                                height: 65,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [Color(0xFFffffff),Color(0xFFFfffff), ],
                                        tileMode: TileMode.clamp
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 10,
                                        spreadRadius: 0,
                                        offset: Offset(0, 4),
                                      )
                                    ]
                                ),
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          SizedBox(width: 15,),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Icon(
                                              Icons.calendar_today,
                                              color: Color(0xFFBC002D),
                                              size: 20,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Date of Birth',
                                                  style: kLabelTextStyle,
                                                ),
                                                SizedBox(height: 3,),
                                                Text(dob!='null'?dob:'--',
                                                  style: kNumberTextStyle,
                                                ),
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                      //SizedBox(height: 1,),

                                    ],
                                  ),
                                ),
                                //curveType: CurveType.convex,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 7.7, right: 25, top: 20),
                              child: Container(
                                height: 65,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [Color(0xFFffffff),Color(0xFFFfffff), ],
                                        tileMode: TileMode.clamp
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 10,
                                        spreadRadius: 0,
                                        offset: Offset(0, 4),
                                      )
                                    ]
                                ),
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(width: 15,),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Icon(
                                              Icons.opacity,
                                              color: Color(0xFFBC002D),
                                              size: 23,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Blood Type',
                                                  style: kLabelTextStyle,
                                                ),
                                                SizedBox(height: 3,),
                                                Text(btype!='null'?btype:'--',
                                                  style: kNumberTextStyle,
                                                ),
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                      //SizedBox(height: 1,),

                                    ],
                                  ),
                                ),
                                //curveType: CurveType.convex,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 25.0, right: 25.0, top: 20),
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [Color(0xFFffffff),Color(0xFFFfffff), ],
                                  tileMode: TileMode.clamp
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                )
                              ]
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                //crossAxisAlignment: CrossAxisAlignment.baseline,
                                //textBaseline: TextBaseline.alphabetic,
                                children: <Widget>[
                                  // Icon(Icons.height,size: 20,color: Color(0xFFBC002D),),
                                  Text(
                                    'Height : ',
                                    style: kLabelTextStyle,
                                  ),
                                  Text(
                                      //height!='null'?height:'--',
                                    height.toString(),
                                    style: kNumberTextStyle,
                                  ),
                                  Text(
                                    ' cm',
                                    style: kLabelTextStyle,
                                  ),
                                ],
                              ),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  thumbShape: RoundSliderThumbShape(
                                      enabledThumbRadius: 9.0),
                                  activeTrackColor: kMainRed,
                                  thumbColor: kMainRed,
                                  overlayColor: Color(0x222962F7),
                                  inactiveTrackColor: Colors.grey,
                                  overlayShape:
                                  RoundSliderOverlayShape(overlayRadius: 20.0),
                                ),
                                child: Slider(
                                    value: height.toDouble(),
                                    min: 120.0,
                                    max: 220.0,
                                    onChanged: (double newValue) {
                                      setState(() {
                                        height = newValue.round();
                                        final firestoreInstance =  FirebaseFirestore.instance;

                                        var firebaseUser =  FirebaseAuth.instance.currentUser;
                                        firestoreInstance.collection("User Details").doc(firebaseUser.uid).
                                        update({"Height":height});
                                      });
                                    }),
                              )
                            ],
                          ),
                          //curveType: CurveType.convex,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 7.7, top: 20),
                              child: Container(
                                height: 80,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [Color(0xFFffffff),Color(0xFFFfffff), ],
                                        tileMode: TileMode.clamp
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                    color: Color.fromRGBO(49, 39, 79, 1),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      )
                                    ]
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Weight : ',
                                          style: kLabelTextStyle,
                                        ),
                                        Text(
                                          weight.toString(),
                                          style: kNumberTextStyle,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        RoundIconButton(
                                          icon: Icons.remove,
                                          onPressed: () {
                                            setState(() {
                                              weight--;
                                              final firestoreInstance =  FirebaseFirestore.instance;

                                              var firebaseUser =  FirebaseAuth.instance.currentUser;
                                              firestoreInstance.collection("User Details").doc(firebaseUser.uid).
                                              update({"Weight":weight});
                                            });
                                          },
                                        ),
                                        SizedBox(
                                          width: 0,
                                        ),
                                        RoundIconButton(
                                          icon: Icons.add,
                                          onPressed: () {
                                            setState(() {
                                              weight++;
                                              final firestoreInstance =  FirebaseFirestore.instance;

                                              var firebaseUser =  FirebaseAuth.instance.currentUser;
                                              firestoreInstance.collection("User Details").doc(firebaseUser.uid).
                                              update({"Weight":weight});
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                //curveType: CurveType.convex,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 7.7, right: 25, top: 20),
                              child: Container(
                                height: 80,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [Color(0xFFffffff),Color(0xFFFfffff), ],
                                        tileMode: TileMode.clamp
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                    color: Color.fromRGBO(49, 39, 79, 1),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      )
                                    ]
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Age : ',
                                          style: kLabelTextStyle,
                                        ),
                                        Text(
                                          age.toString(),
                                          style: kNumberTextStyle,
                                        ),
                                      ],
                                    ),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        RoundIconButton(
                                          icon: Icons.remove,
                                          onPressed: () {
                                            setState(() {
                                              age--;
                                              final firestoreInstance =  FirebaseFirestore.instance;

                                              var firebaseUser =  FirebaseAuth.instance.currentUser;
                                              firestoreInstance.collection("User Details").doc(firebaseUser.uid).
                                              update({"Age":age});
                                            });
                                          },
                                        ),
                                        SizedBox(width: 2.0),
                                        RoundIconButton(
                                          icon: Icons.add,
                                          onPressed: () {
                                            setState(() {
                                              age++;
                                              final firestoreInstance =  FirebaseFirestore.instance;

                                              var firebaseUser =  FirebaseAuth.instance.currentUser;
                                              firestoreInstance.collection("User Details").doc(firebaseUser.uid).
                                              update({"Age":age});
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                //curveType: CurveType.convex,
                              ),
                            ),
                          ),
                        ],
                      ),


                      Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25, top: 20),
                        child: Container(
                          height: 65,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [Color(0xFFffffff),Color(0xFFFfffff), ],
                                  tileMode: TileMode.clamp
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 10,
                                  spreadRadius: 0,
                                  offset: Offset(0, 4),
                                )
                              ]
                          ),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    SizedBox(width: 15,),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Icon(
                                        Icons.local_hospital,
                                        color: Color(0xFFBC002D),
                                        size: 22,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Medical Condition',
                                            style: kLabelTextStyle,
                                          ),
                                          SizedBox(height: 3,),
                                          Text(mc!='null'?mc:'--',
                                            style: kNumberTextStyle,
                                          ),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                                //SizedBox(height: 1,),

                              ],
                            ),
                          ),
                          //curveType: CurveType.convex,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25, top: 20),
                        child: Container(
                          height: 65,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [Color(0xFFffffff),Color(0xFFFfffff), ],
                                  tileMode: TileMode.clamp
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 10,
                                  spreadRadius: 0,
                                  offset: Offset(0, 4),
                                )
                              ]
                          ),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    SizedBox(width: 15,),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Icon(
                                        Icons.phone,
                                        color: Color(0xFFBC002D),
                                        size: 20,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Contact',
                                            style: kLabelTextStyle,
                                          ),
                                          SizedBox(height: 3,),
                                          Text(contact!='null'?contact:'--',
                                            style: kNumberTextStyle,
                                          ),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                                //SizedBox(height: 1,),
                              ],
                            ),
                          ),
                          //curveType: CurveType.convex,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25, top: 20),
                        child: GestureDetector(
                          onTap: (){
                            /////commenting here
                            ////need to add functionality afterwards
                            /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return DonationHistory();
                                },
                              ),
                            );*/
                          },
                          child: Container(
                            height: 65,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [Color(0xFFffffff),Color(0xFFFfffff), ],
                                    tileMode: TileMode.clamp
                                ),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 10,
                                    spreadRadius: 0,
                                    offset: Offset(0, 4),
                                  )
                                ]
                            ),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      SizedBox(width: 15,),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Icon(
                                          Icons.history,
                                          color: Color(0xFFBC002D),
                                          size: 23,
                                        ),
                                      ),
                                      Text(
                                        '  Donation History',
                                        style: kLabelTextStyle.copyWith(color: kMainRed,fontSize: 14),
                                      ),


                                    ],
                                  ),
                                  //SizedBox(height: 1,),

                                ],
                              ),
                            ),
                            //curveType: CurveType.convex,
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return FAQ();
                              },
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left:25.0,right: 25.0,top: 20,bottom: 15),
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [kMainRed,kMainRed ],
                                    tileMode: TileMode.clamp
                                ),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  )
                                ]
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(height: 16,),
                                Center(
                                  child: Text(
                                    '  Who can I donate to?',
                                    style: TextStyle(fontSize: 17,fontFamily: 'nunito',fontWeight: FontWeight.bold,color: Colors.white.withOpacity(0.9)),

                                  ),
                                ),

                                //SizedBox(height: 1,),

                              ],
                            ),
                            //curveType: CurveType.convex,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          _auth.signOut();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left:25.0,right: 25.0,top: 0,bottom: 10),
                          child: Container(
                            height: 55,
                            decoration: BoxDecoration(
                              border: Border.all(color: kMainRed),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(height: 16,),
                                Center(
                                  child: Text(
                                    'Logout',
                                    style: TextStyle(fontSize: 17,fontFamily: 'nunito',fontWeight: FontWeight.bold,color: kMainRed),

                                  ),
                                ),
                                //SizedBox(height: 1,),
                              ],
                            ),
                            //curveType: CurveType.convex,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }






  displayOverlay(BuildContext context) {
    String name;
    String dob;
    String btype;
    String mc;
    String phone;


    return showDialog(
      context: context,
      builder: (context) {
        Size mq = MediaQuery.of(context).size;
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Container(
            height: mq.height * 0.67,
            width: mq.width * 0.8,
            child: ListView(children: [
              Column(
                children: [
                  Text(
                    'Edit Profile',
                    style: GoogleFonts.montserrat(color: Colors.black,fontWeight: FontWeight.w500),
                  ),
                  Divider(
                    thickness: 2,
                    indent: 80,
                    endIndent: 80,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Full Name',
                    style: GoogleFonts.montserrat(color: Colors.black,fontSize: 14),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 40,
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            name = value;
                          });
                        },
                        cursorColor: Colors.white,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          fillColor: kGrey.withOpacity(0.2),
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Date of Birth',
                    style: GoogleFonts.montserrat(color: Colors.black,fontSize: 14),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 40,
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            dob = value;
                          });
                        },
                        cursorColor: Colors.white,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          fillColor: kGrey.withOpacity(0.2),
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Blood Type',
                    style: GoogleFonts.montserrat(color: Colors.black,fontSize: 14),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 40,
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            btype = value;
                          });
                        },
                        cursorColor: Colors.white,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          fillColor: kGrey.withOpacity(0.2),
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ),SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Contact Number',
                    style: GoogleFonts.montserrat(color: Colors.black,fontSize: 14),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 40,
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            phone = value;
                          });
                        },
                        cursorColor: Colors.white,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          fillColor: kGrey.withOpacity(0.2),
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Medical Condition',
                    style: GoogleFonts.montserrat(color: Colors.black,fontSize: 14),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 40,
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            mc = value;
                          });
                        },
                        cursorColor: Colors.white,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          fillColor: kGrey.withOpacity(0.2),
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: kMainRed,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: MaterialButton(
                      onPressed: () {


                        showDialog(
                            context: context,
                            builder: (context) {

                              try {
                                FirebaseDatabase.instance.reference().child('User/${loggedInUser.uid}').set({
                                  "Name": name,
                                  "BloodType": btype,
                                  "Dob": dob,
                                  "MedCondition": mc,
                                  "Phone":phone,
                                }).then((value) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return HomePage();
                                      },
                                    ),
                                  );
                                });
//                                loggedInUser
//                                    .updateProfile(displayName: name)
//                                    .then((value) {
//                                });
                              } catch (e) {
                                print(e);
                              }
                              return Center(child: CircularProgressIndicator());
                            });
                      },
                      child: Text(
                        'Save Changes',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ]),
          ),
        );
      },
    );
  }
}
class RoundIconButton extends StatelessWidget {
  RoundIconButton({@required this.icon, @required this.onPressed});

  final IconData icon;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      elevation: 3.0,
      child: Icon(icon,color: Colors.white,),
      shape: CircleBorder(),
      constraints: BoxConstraints.tightFor(
        width: 35.0,
        height: 35.0,
      ),
      fillColor: Color(0xffE53033),
    );
  }
}