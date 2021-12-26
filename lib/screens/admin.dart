//admin page
//to verify requests and doctors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raktkhoj/colors.dart';
import 'package:raktkhoj/components/cached_image.dart';
import 'package:raktkhoj/model/request.dart';
import 'package:raktkhoj/model/user.dart';
import 'package:raktkhoj/provider/pdf_api.dart';
import 'package:raktkhoj/provider/pdf_viewer_page.dart';
import 'package:raktkhoj/screens/donate_here/percentage_widget.dart';
import 'package:raktkhoj/screens/donate_here/search_request.dart';
import 'package:raktkhoj/screens/donate_here/single_request_screen.dart';
import 'package:raktkhoj/services/dynamic_link.dart';
import 'package:raktkhoj/services/notifications.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;


class Admin extends StatefulWidget {
  Admin({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  double bannerHeight, listHeight, listPaddingTop;
  double cardContainerHeight, cardContainerTopPadding;
  //String name="";
  int selectedSort;
  int reqOrDoc;
  List<String> requestConditonList=["normal","critical"];

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  //fetching all blood requests and dumping into a list
  Future<List<RequestModel>> fetchAllRequests()  async {
    List<RequestModel> requestList = <RequestModel>[];

    QuerySnapshot querySnapshot =
    await _firestore.collection("Blood Request Details").get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      requestList.add(RequestModel.fromMap(querySnapshot.docs[i].data()));

    }
    return requestList;
  }


  //fetching all doctors verfication requests and dumping into a list
  Future<List<UserModel>> fetchAllDoctors()  async {
    List<UserModel> doctorList = <UserModel>[];

    QuerySnapshot querySnapshot =
    await _firestore.collection("User Details").get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      UserModel x=UserModel.fromMap(querySnapshot.docs[i].data());

      if(x!=null&&x.Doctor!=null){
        if(querySnapshot.docs[i]['Doctor']&&querySnapshot.docs[i]['Doctor']==true
        &&querySnapshot.docs[i]['AdminVerified']==false){
          doctorList.add(UserModel.fromMap(querySnapshot.docs[i].data()));
        }
      }
      print(doctorList.length);
      //doctorList.add(UserModel.fromMap(querySnapshot.docs[i].data()));

    }
    return doctorList;
  }

  List<RequestModel> requestList;
  List<UserModel> doctorList;
  String query = "";
  TextEditingController searchController = TextEditingController();
  @override
  void initState()  {
    super.initState();
    selectedSort=0;
    reqOrDoc=1;

    //requestList=_firestore.collection("Blood Request Details").snapshots() as List<RequestModel>;

    fetchAllRequests().then((List<RequestModel> list) {
      setState(() {
        requestList = list;
      });
    });

    fetchAllDoctors().then((List<UserModel> list) {
      setState(() {
        doctorList = list;
      });
    });



  }

  //send notif to all donors opted for notification
  sendNotifNearbyDonor(String url,  GeoPoint requestLocation) async {

    List<String> donorMails=[];
    QuerySnapshot querySnapshot= await  FirebaseFirestore.instance.collection('User Details').where('Donor', isEqualTo: true).get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      dynamic request = querySnapshot.docs[i].data();
      GeoPoint position= request['location'];
      String donorMail=  request['Email'].toString();

      //calc distance
      var _distanceInMeters = await Geolocator().distanceBetween(
          position.latitude,
          position.longitude,
          requestLocation.latitude,
          requestLocation.longitude
      );
      if(_distanceInMeters<=10000000)
        donorMails.add(donorMail);
    }
    await sendccEmails(donorMails, url, "Dear Raktkhoj donor, we found a request near you. Help save a life. Click on the link to view request:", "Found a request near you" );

  }

  @override
  Widget build(BuildContext context) {
    bannerHeight = MediaQuery.of(context).size.height * .14;
    listHeight = MediaQuery.of(context).size.height * .75;
    //cardContainerHeight = 200;

    cardContainerTopPadding = bannerHeight / 2;
    listPaddingTop = 20;
    return Scaffold(
      // https://flutter.io/docs/development/ui/layout#stack
      body: Stack(
        children: <Widget>[

          new Column(
            children: <Widget>[
              //searchButton(context),
              topBanner(context),
              Expanded(child: bodyBloodRequestList(context))
            ],
          ),
          bannerContainer(),
        ],
      ),
    );
  }


  //to set option for viewing doctors or requests list
  Row rowRecentUpdates() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      verticalDirection: VerticalDirection.down,
      children: <Widget>[
        InkWell(
          onTap: (){
            setState(() {
              reqOrDoc=1;
            });
          },
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text("Doctors Verification",
                style: TextStyle(color: reqOrDoc==1? kMainRed: Colors.black87, fontSize: 17.0)),

          ),
        ),
        InkWell(
          onTap: (){
            setState(() {
              reqOrDoc=0;
            });
          },
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text("Blood Request",
                style: TextStyle(
                    color: reqOrDoc==0? kMainRed: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0)),
          ),
        )
      ],
    );
  }

  //body of admin page
  Container bodyBloodRequestList(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.grey.shade300,
      padding:
      new EdgeInsets.only(top: listPaddingTop, right: 10.0, left: 10.0),
      //child: requestOrDoctorSelector(context),
      child: Column(
        children: <Widget>[
          //searchButton(context),
          //getScrollView(),
          rowRecentUpdates(),

          Expanded(child: requestOrDoctorSelector(context)),

        ],
      ),
    );
  }

  //to show request or doctor
  Widget requestOrDoctorSelector(BuildContext context)
  {
    if(reqOrDoc==0)
    {
      return Column(
        children: <Widget>[
          //searchButton(context),
          getScrollView(),

          Expanded(child:  requests(context)),

        ],
      );
    }

    else
    {

      doctorList==null?[]:doctorList;
      if(doctorList==null)
      {
        return Column(
          children: <Widget>[
            //searchButton(context),
            //getScrollView(),

            Expanded(child: Center(child: CircularProgressIndicator()) ),

          ],
        );

      }
    }
    return Column(
      children: <Widget>[
        //searchButton(context),
        //getScrollView(),

        Expanded(child: doctors(context , doctorList) ),

      ],
    );


  }

  //to show doctors verification request to admin in list form
  Widget doctors(BuildContext context , List<UserModel> list)
  {

    return ListView.builder(

      padding: EdgeInsets.all(10),
      //reverse: true,


      itemCount: list.length,
      itemBuilder: (context, index) {

        return DoctorItem(list[index], context );
      },
    );







  }

  // to show blood requets to admin in list form
  Widget requests(BuildContext context) {
    return StreamBuilder(


      stream: getQuery().snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {

          return Center(child: CircularProgressIndicator());
        }



        return ListView.builder(

          padding: EdgeInsets.all(10),
          //reverse: true,


          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {

            return RequestItem(snapshot.data.docs[index], context );
          },
        );
      },
    );
  }


  //to open pdf
  void openPDF(BuildContext context, File file) => Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => PDFViewerPage(file: file)),
  );


  //designing a single doctor verification item
  Widget DoctorItem(UserModel _doc, BuildContext context){


    // String name="";
    String email="", tokenid="";
    GeoPoint location;
    //UserModel _doc = UserModel.fromMap(snapshot.data());
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('User Details').doc(_doc.uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Padding(
                padding: EdgeInsets.only(top: 50),
                child: Row(
                  children: <Widget>[
                    CircularProgressIndicator(
                      valueColor:
                      new AlwaysStoppedAnimation<Color>(
                          kMainRed),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text('Loading Requests...')
                  ],
                ));
          try {
            email=snapshot.data['Email'];
            tokenid = snapshot.data['tokenId'];
            location=snapshot.data['location'];
          }catch(e){
            // name= 'Loading';
          }
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  // setState(() {
                  //
                  // });
                },
                //showing data of doctor verification requests
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 5),
                  child: Column(
                    children: <Widget>[Container(
                      height: 140,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width ,
                      decoration: BoxDecoration(
                          color: kBackgroundColor,
                          // borderRadius:
                          // BorderRadius.circular(15),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          border: Border.all(
                              color: kMainRed,
                              width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.1),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            )
                          ]),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 8,
                          ),
                          Container(
                            width: 60,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .center,
                              mainAxisAlignment: MainAxisAlignment
                                  .center,
                              children: <Widget>[
                                CachedImage(
                                  _doc.profilePhoto,
                                  radius: 60,
                                  isRound: true,
                                ),


                              ],
                            ),
                          ),
                          // SizedBox(
                          //     height: 160,
                          //     child: VerticalDivider(
                          //       color: Colors.black,
                          //       thickness: 1,
                          //     )),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(child:
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: <Widget>[

                              SizedBox(height: 8),
                              //                                     SizedBox(height: 12,),

                              Row(
                                  children : <Widget>[
                                    Icon(FontAwesomeIcons.hospitalUser,color: kMainRed,size: 16,),
                                    SizedBox(width: 3,),
                                    Text(
                                      'Doctor: ${_doc.name}',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'nunito',
                                          color: Colors.black),
                                    ),
                                  ]

                              ),
                              SizedBox(height: 7,),
                              Row(
                                  children : <Widget>[
                                    Icon(FontAwesomeIcons.bookOpen,color: kMainRed,size: 14,),
                                    SizedBox(width: 3,),
                                    Text(
                                      'Degree:  ${_doc.Degree
                                          .toString()} ',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'nunito',
                                          color: Colors.black),
                                    ),
                                  ]
                              ),
                              SizedBox(height: 5,),
                              Row(
                                  children : <Widget>[
                                    SizedBox(width: 8,),
                                    //opening the doctor verification document
                                    //not working properly
                                    //poorvi dudh do galati
                                    IconButton(onPressed:() async{
                                      var docURL=_doc.DoctorVerificationReport;
                                      final url =docURL;
                                      final file = await PDFApi.loadNetwork(url.toString());
                                      await openPDF(context, file);
                                    },
                                      icon:Icon(FontAwesomeIcons.folderOpen,color: kMainRed,size: 20,), ),
                                    SizedBox(width: 8,),
                                    //icon if user wants to approve doctor
                                    //dialog would be shown
                                    //db changes
                                    //email and push notifications to doctor
                                    IconButton(onPressed:() async{

                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content: Text("Doctor Verification Done",
                                                  style: TextStyle(
                                                      color: Colors.black, fontSize: 17)),
                                              actions: <Widget>[
                                                new FlatButton(
                                                  child: new Text('Ok'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                )
                                              ],
                                            );
                                          });

                                      String url=await DynamicLinksService.createDynamicLink(_doc.uid);
                                      // print('email $email tokenid $tokenid');


                                      try {
                                        sendNotification([tokenid], 'Your verification is finished.', 'Welcom to raktkhoj doctors community');
                                        sendEmail(email, url, 'You doctor community joining request has been approved by admin. We hope you find you help needies through Raktkhoj.Click on the link to view your request', 'Verification successful');
                                        sendNotifNearbyDonor(url, location);
                                      }catch(e) {};

                                      FirebaseFirestore.instance.collection("User Details").doc(_doc.uid)
                                          .update({"AdminVerified" : true});
                                    },
                                      icon:Icon(FontAwesomeIcons.thumbsUp,color: kMainRed,size: 20,), ),
                                    SizedBox(width: 8,),
                                    //if admin disapproves the doctor
                                    //changes in db
                                    IconButton(onPressed:(){
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            Future.delayed(Duration(seconds: 2), () {
                                              Navigator.of(context).pop();
                                            });
                                            return AlertDialog(
                                              content: Text("Deleted the request",
                                                  style: TextStyle(
                                                      color: Colors.black, fontSize: 17)),
                                            );
                                          });
                                      FirebaseFirestore.instance.collection("User Details").doc(_doc.uid)
                                          .update({"Doctor" : false, "AdminVerified": false});
                                    },
                                      icon:Icon(FontAwesomeIcons.trash,color: kMainRed,size: 20,), ),

                                  ]
                              ),
                              SizedBox(height: 5,),




                            ],
                          ),
                          ),

                        ],
                      ),


                    ),

                    ],
                  ),
                ),
              ),
            ],
          );

        }

    );
  }





//designing a single request item
  Widget RequestItem(DocumentSnapshot snapshot, BuildContext context){


    // String name="";
    String email="", tokenid="";
    GeoPoint location;
    RequestModel _req = RequestModel.fromMap(snapshot.data());
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('User Details').doc(_req.raiserUid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Padding(
                padding: EdgeInsets.only(top: 50),
                child: Row(
                  children: <Widget>[
                    CircularProgressIndicator(
                      valueColor:
                      new AlwaysStoppedAnimation<Color>(
                          kMainRed),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text('Loading Requests...')
                  ],
                ));
          try {
            email=snapshot.data['Email'];
            tokenid = snapshot.data['tokenId'];
            location=snapshot.data['location'];
          }catch(e){
            // name= 'Loading';
          }
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  // setState(() {
                  //
                  // });
                },
                //showing data of blood requests raised
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 5),
                  child: Column(
                    children: <Widget>[Container(
                      height: 160,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width ,
                      decoration: BoxDecoration(
                          color: kBackgroundColor,
                          // borderRadius:
                          // BorderRadius.circular(15),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                          border: Border.all(
                              color: kMainRed,
                              width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.1),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            )
                          ]),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 55,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .center,
                              mainAxisAlignment: MainAxisAlignment
                                  .center,
                              children: <Widget>[
                                Icon(Icons.bloodtype_sharp,color: kMainRed,),
                                Text(
                                  _req.bloodGroup,
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: kMainRed,
                                      fontWeight:
                                      FontWeight.bold,
                                      fontFamily:
                                      'nunito'),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.only(
                                      left: 5),
                                  child: Text(
                                    'Type',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        fontFamily:
                                        'nunito'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // SizedBox(
                          //     height: 160,
                          //     child: VerticalDivider(
                          //       color: Colors.black,
                          //       thickness: 1,
                          //     )),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(child:
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: <Widget>[

                              SizedBox(height: 8),
                              //                                     SizedBox(height: 12,),

                              Row(
                                  children : <Widget>[
                                    Icon(FontAwesomeIcons.hospitalUser,color: kMainRed,size: 12,),
                                    SizedBox(width: 3,),
                                    Text(
                                      'Name: ${_req.patientName}',
                                      style: TextStyle(
                                          fontSize: 12.5,
                                          fontFamily: 'nunito',
                                          color: Colors.black),
                                    ),
                                  ]

                              ),
                              SizedBox(height: 5,),
                              Row(
                                  children : <Widget>[
                                    Icon(FontAwesomeIcons.prescriptionBottle,color: kMainRed,size: 12,),
                                    SizedBox(width: 3,),
                                    Text(
                                      'Quantity:  ${_req
                                          .qty
                                          .toString()} L',
                                      style: TextStyle(
                                          fontSize: 12.5,
                                          fontFamily: 'nunito',
                                          color: Colors.black),
                                    ),
                                  ]
                              ),
                              SizedBox(height: 5,),
                              Row(
                                  children : <Widget>[
                                    Icon(FontAwesomeIcons.clock,color: kMainRed,size: 12,),
                                    SizedBox(width: 3,),
                                    Text(
                                      'Due Date: ${_req.dueDate
                                          .toString()}',
                                      style: TextStyle(
                                          fontSize: 12.5,
                                          fontFamily: 'nunito',
                                          color: kMainRed),
                                    ),
                                  ]
                              ),
                              Expanded(child:
                              Row(
                                  children : <Widget>[
                                    Icon(FontAwesomeIcons.mapMarkedAlt,color: kMainRed, size: 12),
                                    SizedBox(width:3,),
                                    Expanded(child:
                                    Text(
                                      '${_req.address}',
                                      overflow: TextOverflow.ellipsis,
                                      // maxLines: 2,
                                      //softWrap: false,
                                      style: TextStyle(
                                          fontSize: 12.5,
                                          fontFamily: 'nunito',
                                          color: Colors.black),

                                    ),
                                    ),
                                  ]
                              ),
                              ),

                              Row(
                                  children:<Widget> [
                                    Icon(FontAwesomeIcons.ambulance,color: kMainRed,size: 15,),
                                    SizedBox(width: 5),
                                    Text('${_req.condition
                                        .toString()}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                          fontFamily: 'nunito',
                                          color: kMainRed),


                                    ),
                                  ]
                              ),
                              //head towards full view of request
                              Row(
                                children:[
                                  SizedBox(width:175),
                                  IconButton(onPressed: (){
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => SingleRequestScreen(request: _req),
                                    ));
                                  }, icon:
                                  Icon(Icons.east_outlined,color: kMainRed,)),],
                              ),
                            ],
                          ),
                          ),

                        ],
                      ),


                    ),
                      //while approving blood request
                      //changing in db
                      //sending notifiactions to request raiser
                      //sending email to request raiser
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Text("Blood Request Permitted",
                                            style: TextStyle(
                                                color: Colors.black, fontSize: 17)),
                                        actions: <Widget>[
                                          new FlatButton(
                                            child: new Text('Ok'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      );
                                    });
                                // showDialog(
                                //     context: context,
                                //     builder: (context) {
                                //       Future.delayed(Duration(seconds: 2), () {
                                //         Navigator.of(context).pop();
                                //       });
                                //       return AlertDialog(
                                //         content: Text("Blood Request Permitted",
                                //             style: TextStyle(
                                //                 color: Colors.black, fontSize: 17)),
                                //       );
                                //     });
                                String url=await DynamicLinksService.createDynamicLink(_req.reqid);
                                // print('email $email tokenid $tokenid');


                                try {
                                  sendNotification([tokenid], 'Your request has been approved.', 'Blood Request Approved');
                                  sendEmail(email, url, 'You blood request has been approved by admin. We hope you find your donor through Raktkhoj.Click on the link to view your request', 'Blood request approved');
                                  sendNotifNearbyDonor(url, location);
                                }catch(e) {};

                                FirebaseFirestore.instance.collection("Blood Request Details").doc(_req.reqid)
                                    .update({"permission" : true});
                              },
                              child: Container(
                                  height: 30,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(15),
                                        // bottomRight: Radius.circular(15),
                                      ),
                                      border:
                                      Border.all(width: 1, color: kMainRed),
                                      color: Colors.transparent),
                                  child: Center(
                                    child: Text('Approve'.tr,
                                        style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: kMainRed,
                                        )),
                                  )),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: (){
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      Future.delayed(Duration(seconds: 2), () {
                                        Navigator.of(context).pop();
                                      });
                                      return AlertDialog(
                                        content: Text("Deleted the request",
                                            style: TextStyle(
                                                color: Colors.black, fontSize: 17)),
                                      );
                                    });
                                FirebaseFirestore.instance.collection("Blood Request Details").doc(_req.reqid)
                                    .update({"permission" : false, "active": false});
                              },

                              //section for disapproving the request
                              child: Container(
                                  height: 30,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      // bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    ),

                                    // border: Border.symmetric(horizontal: BorderSide.none),
                                    //border: Border.all(width:1, color:Colors.white24),
                                    border: Border.all(width: 1, color: kMainRed),
                                    color: Colors.transparent,
                                  ),
                                  child: Center(
                                    child: Text('Disapprove'.tr,
                                        style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: kMainRed,
                                          //letterSpacing: 1
                                        )),
                                  )),

                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );

        }

    );
  }





  //top banner for ui
  Container topBanner(BuildContext context) {
    return Container(
        height: bannerHeight,
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          color: kMainRed,
        )
    );
  }

  //a container to create the banners
  //decoration part
  Container bannerContainer() {
    return
      Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: 50.0, right: 10.0, left: 20.0),
          child: Row(
              children:[
                SizedBox(width: 70,),
                Text(
                  "ADMIN PANNEL \n New Requests",
                  style: TextStyle(
                      color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(width:40),
                // IconButton(icon: Icon(Icons.search),color:Colors.white,
                //     onPressed:() async{
                //       Navigator.of(context).push(MaterialPageRoute(
                //         builder: (_) => SearchRequest(),
                //       ));
                //     }         )
              ]
          ));


  }


  //sorting the requests on baseis of blood groups
  Widget getScrollView(){
    return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(8),
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceEvenly,
          children: [
            ChoiceChip(
              selectedColor:
              kMainRed,
              //Theme.of(context).accentColor,
              elevation: 10,
              onSelected: (value) {
                setState(() {
                  selectedSort = 0;
                });
              },
              label: Text('All',
                  style: TextStyle(
                      color: kDarkerGrey)),
              selected: selectedSort == 0,
            ),
            SizedBox(width: 5),
            ChoiceChip(
              selectedColor:
              kMainRed,
              //Theme.of(context).accentColor,
              elevation: 10,
              onSelected: (value) {
                setState(() {
                  selectedSort = 1;
                });
              },
              label: Text('A+',
                  style: TextStyle(
                    color:kDarkerGrey,)),
              selected: selectedSort == 1,
            ),
            SizedBox(width: 5),
            ChoiceChip(
              selectedColor:
              kMainRed,
              elevation: 10,
              onSelected: (value) {
                setState(() {
                  selectedSort = 2;
                });
              },
              label: Text('A-',
                  style: TextStyle(
                      color: kDarkerGrey)),
              selected: selectedSort == 2,
            ),
            SizedBox(width: 5),
            ChoiceChip(
              selectedColor:
              kMainRed,
              elevation: 10,
              onSelected: (value) {
                setState(() {
                  selectedSort = 3;
                });
              },
              label: Text('B+',
                  style: TextStyle(
                      color:kDarkerGrey)),
              selected: selectedSort == 3,
            ),
            SizedBox(width: 5),
            ChoiceChip(
              selectedColor:
              kMainRed,
              elevation: 10,
              onSelected: (value) {
                setState(() {
                  selectedSort = 4;
                });
              },
              label: Text('B-',
                  style: TextStyle(
                      color:kDarkerGrey)),
              selected: selectedSort == 4,
            ),
            SizedBox(width: 5),
            ChoiceChip(
              selectedColor:
              kMainRed,
              elevation: 10,
              onSelected: (value) {
                setState(() {
                  selectedSort = 5;
                });
              },
              label: Text('AB+',
                  style: TextStyle(
                      color:kDarkerGrey)),
              selected: selectedSort == 5,
            ),SizedBox(width: 5),
            ChoiceChip(
              selectedColor:
              kMainRed,
              elevation: 10,
              onSelected: (value) {
                setState(() {
                  selectedSort = 6;
                });
              },
              label: Text('AB-',
                  style: TextStyle(
                      color:kDarkerGrey)),
              selected: selectedSort == 6,
            ),SizedBox(width: 5),
            ChoiceChip(
              selectedColor:
              kMainRed,
              elevation: 10,
              onSelected: (value) {
                setState(() {
                  selectedSort = 7;
                });
              },
              label: Text('O+',
                  style: TextStyle(
                      color:kDarkerGrey)),
              selected: selectedSort == 7,
            ),SizedBox(width: 5),
            ChoiceChip(
              selectedColor:
              kMainRed,
              elevation: 10,
              onSelected: (value) {
                setState(() {
                  selectedSort = 8;
                });
              },
              label: Text('O-',
                  style: TextStyle(
                      color:kDarkerGrey)),
              selected: selectedSort == 8,
            ),
          ],
        ));
  }

  //get queries according to blood Group selected..
  /*
      0->all
      1->A+
      2->A-
      3->B+
      4->B-
      5->AB+
      6->AB-
      7->O+
      8->o-
  */
  //.where('bloodGroup',isEqualTo: "A+")

  Query getQuery() {
    switch (selectedSort) {
      case 0:
        return  FirebaseFirestore.instance
            .collection("Blood Request Details").where('patientCondition',whereIn: requestConditonList)
            .where('active',isEqualTo:true)
            .where('permission', isEqualTo:false)
            .orderBy('dueDate');
        break;
      case 1:
        return FirebaseFirestore.instance
            .collection("Blood Request Details").where('patientCondition',whereIn: requestConditonList)
            .where('active',isEqualTo:true)
            .where('permission', isEqualTo:false)
            .where('bloodGroup',isEqualTo: "A+")
            .orderBy('dueDate');
        break;
      case 2:
        return FirebaseFirestore.instance
            .collection("Blood Request Details").where('patientCondition',whereIn: requestConditonList)
            .where('active',isEqualTo:true)
            .where('permission', isEqualTo:false)
            .where('bloodGroup',isEqualTo: "A-")
            .orderBy('dueDate');
        break;
      case 3:
        return FirebaseFirestore.instance
            .collection("Blood Request Details").where('patientCondition',whereIn: requestConditonList)
            .where('active',isEqualTo:true)
            .where('bloodGroup',isEqualTo: "B+")
            .orderBy('dueDate');
        break;
      case 4:
        return FirebaseFirestore.instance
            .collection("Blood Request Details").where('patientCondition',whereIn: requestConditonList)
            .where('active',isEqualTo:true)
            .where('permission', isEqualTo:false)
            .where('permission', isEqualTo:false)
            .where('bloodGroup',isEqualTo: "B-")
            .orderBy('dueDate');
        break;
      case 5:
        return FirebaseFirestore.instance
            .collection("Blood Request Details").where('patientCondition',whereIn: requestConditonList)
            .where('active',isEqualTo:true)
            .where('permission', isEqualTo:false)
            .where('bloodGroup',isEqualTo: "AB+")
            .orderBy('dueDate');
        break;
      case 6:
        return FirebaseFirestore.instance
            .collection("Blood Request Details").where('patientCondition',whereIn: requestConditonList)
            .where('active',isEqualTo:true)
            .where('permission', isEqualTo:false)
            .where('bloodGroup',isEqualTo: "AB-")
            .orderBy('dueDate');
        break;
      case 7:
        return FirebaseFirestore.instance
            .collection("Blood Request Details").where('patientCondition',whereIn: requestConditonList)
            .where('active',isEqualTo:true)
            .where('permission', isEqualTo:false)
            .where('bloodGroup',isEqualTo: "O+")
            .orderBy('dueDate');
        break;
      case 8:
        return FirebaseFirestore.instance
            .collection("Blood Request Details").where('patientCondition',whereIn: requestConditonList)
            .where('active',isEqualTo:true)
            .where('permission', isEqualTo:false)
            .where('bloodGroup',isEqualTo: "O-")
            .orderBy('dueDate');
        break;
    }
    debugPrint('Unexpected sorting selected');
    return null;
  }


}





