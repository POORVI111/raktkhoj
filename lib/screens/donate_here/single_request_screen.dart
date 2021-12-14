import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:raktkhoj/Colors.dart';
import 'package:raktkhoj/model/request.dart';
import 'package:raktkhoj/model/user.dart';
import 'package:raktkhoj/screens/Chat/chat_screen.dart';
import 'package:raktkhoj/screens/donate_here/dialog_box_bg_error.dart';
import 'package:raktkhoj/screens/donate_here/request_direction.dart';
import 'package:raktkhoj/services/dynamic_link.dart';
import 'package:raktkhoj/services/notifications.dart';
import 'package:raktkhoj/user_oriented_pages/profile.dart';
import 'package:share/share.dart';
import 'package:unicorndial/unicorndial.dart';
import '../../Constants.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;



class SingleRequestScreen extends StatefulWidget {
  final RequestModel request;
const SingleRequestScreen({Key key, this.request}) : super(key: key);



@override
_SingleRequestScreenState createState() => _SingleRequestScreenState();
}

class _SingleRequestScreenState extends State<SingleRequestScreen> {
  String admin="";
  Future<UserModel> getUserDetailsById(id) async {
    try {
      DocumentSnapshot documentSnapshot =
      await FirebaseFirestore.instance.collection(
          "User Details").doc(id).get();
      return UserModel.fromMap(documentSnapshot.data());
    } catch (e) {
      print(e);
      return null;
    }

  }
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('Admin').doc('AdminLogin').get().then((value) {
      setState(() {
        admin=value.data()['Aid'].toString();});
      });

  }
  @override
  Widget build(BuildContext context) {

    var childButtons = <UnicornButton>[];

    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "Contact",
        currentButton: FloatingActionButton(
          heroTag: "Call",
          backgroundColor: kMainRed,
          mini: true,
          child:  Icon(Icons.phone),
          onPressed: () {
            UrlLauncher.launch("tel:${widget.request.phone}");
          },
        )));

    childButtons.add(UnicornButton(
        currentButton: FloatingActionButton(
            heroTag: "Chat",
            backgroundColor: kMainRed,
            mini: true,
            child: Icon(FontAwesomeIcons.comments),
            onPressed: () async {
              UserModel requestRiser= await getUserDetailsById(widget.request.raiserUid);

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => ChatScreen(receiver: requestRiser,)
              ));
            },

        )));

    childButtons.add(UnicornButton(
        currentButton: FloatingActionButton(
            heroTag: "Sms",
            backgroundColor: kMainRed,
            mini: true,
            child: Icon(FontAwesomeIcons.sms),
        onPressed: (){
          String message="Hello ${widget.request.patientName}, I am a potential blood donor willing to help you. Reply back if you still need blood.";
          UrlLauncher.launch("sms:${widget.request.phone}?body=$message");
        },)));

    String donorBloodGroup="";
    var valEnd;
    String donorEmail="";
    User currentUser;
    String donorName="";
    String profilePhoto="";
    String tokenId="";
    String email="";
    String to_show="DONATE";


    currentUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection("User Details").doc(currentUser.uid).get()
        .then((value) {
      valEnd=value.data()["Last Donation"];
      print(valEnd);
      donorBloodGroup=value.data()["BloodGroup"];
      donorName=value.data()["Name"];
      profilePhoto=value.data()["ProfilePhoto"];
      donorEmail=value.data()["Email"];

    });

    FirebaseFirestore.instance.collection('User Details').doc(widget.request.raiserUid).get().then((value)
    {
      email= value.data()["Email"];
      tokenId= value.data()['tokenId'];
    }
    );



    final textTheme = Theme.of(context).textTheme;
    //changing text of button in case if the user is request raiser..
    if(widget.request.raiserUid==currentUser.uid){
      to_show="DELETE";
    }

    return Scaffold(

      appBar: AppBar(
          title: const Text('Blood Request Details'),
          actions: [
            IconButton(
              icon: Icon(
                FontAwesomeIcons.shareAlt,
              ),
              onPressed: () async {

                String url= await DynamicLinksService.createDynamicLink(widget.request.reqid);
                await Share.share(
                  'I found this blood request at Raktkhoj: $url .\n'
                  '${widget.request.patientName} needs ${widget.request.bloodGroup} '
                      'blood by ${widget.request.dueDate}.'
                      'You can donate by visiting at '
                      '${widget.request.address}.\n\n'
                      'Contact +91${widget.request.phone} for more info.',
                );
              },
            ),
            IconButton(
              icon: Icon(
               FontAwesomeIcons.ellipsisV,
              ),
              onPressed: () async {

              },
            )

        ],
      ),
      floatingActionButton: UnicornDialer(
            parentButtonBackground: kMainRed,
            orientation: UnicornOrientation.VERTICAL,
            parentButton: Icon(FontAwesomeIcons.plus),
            childButtons: childButtons),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child:SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 0, right: 0, top: 20),
                child: Container(
                  height: MediaQuery.of(context).size.height/2,
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
                          offset: Offset(0, 3),
                        )
                      ]
                  ),
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
                                FontAwesomeIcons.hospitalUser,
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
                                    'Patient Name',
                                    style: kLabelTextStyle,
                                  ),
                                  SizedBox(height: 3,),
                                  Text(widget.request.patientName,
                                    style: kNumberTextStyle,
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                        Row(
                          children: <Widget>[
                            SizedBox(width: 15,),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(
                                FontAwesomeIcons.calendar,
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
                                    'Due Date',
                                    style: kLabelTextStyle,
                                  ),
                                  SizedBox(height: 3,),
                                  Text(widget.request.dueDate,
                                    style: kNumberTextStyle,
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                        Row(
                          children: <Widget>[
                            SizedBox(width: 15,),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(
                                Icons.opacity,
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
                                    'Blood Type',
                                    style: kLabelTextStyle,
                                  ),
                                  SizedBox(height: 6,),
                                  Text(widget.request.bloodGroup,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: kNumberTextStyle,
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                        Row(
                          children: <Widget>[
                            SizedBox(width: 15,),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(
                                FontAwesomeIcons.prescriptionBottle,
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
                                    'Quantity(L)',
                                    style: kLabelTextStyle,
                                  ),
                                  SizedBox(height: 6,),
                                  Text(widget.request.qty,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: kNumberTextStyle,
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                        Row(
                          children: <Widget>[
                            SizedBox(width: 15,),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(
                                FontAwesomeIcons.ambulance,
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
                                    'Condition',
                                    style: kLabelTextStyle,
                                  ),
                                  SizedBox(height: 6,),
                                  Text(widget.request.condition,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: kNumberTextStyle,
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                        Row(
                          children: <Widget>[
                            SizedBox(width: 15,),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(
                                FontAwesomeIcons.mapMarkedAlt,
                                color: Color(0xFFBC002D),
                                size: 22,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Location',
                                        style: kLabelTextStyle,
                                      ),
                                      SizedBox(height: 3,),
                                      Text(widget.request.address.toString(),
                                        style: kNumberTextStyle,
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: IconButton(
                                        icon: Icon(Icons.directions),
                                        color: Colors.green
                                            ,
                                        onPressed:() async {
                                          await Navigator.push(context,MaterialPageRoute(
                                              builder: (context) =>
                                                  RequestDirection(location: widget.request.location, address: widget.request.address)));
                                          }

                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                        Row(
                          children: <Widget>[
                            SizedBox(width: 15,),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(
                                FontAwesomeIcons.handHoldingWater,
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
                                    'Possible Donors',
                                    style: kLabelTextStyle,
                                  ),
                                  SizedBox(height: 3,),
                                  Text(possibleDonors(widget.request.bloodGroup.toString())
                                      .join('   /   '),
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

              /* only visible to admin to approve or disapprove*/
              if(admin ==currentUser.uid)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                         Colors.green,
                        ),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        )),
                      ),
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (context) {
                              Future.delayed(Duration(seconds: 2), () {
                                Navigator.of(context).pop();
                              });
                              return AlertDialog(
                                content: Text("Blood Request Permitted",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 17)),
                              );
                            });

                        //set permission to true
                        FirebaseFirestore.instance.collection("Blood Request Details").doc(widget.request.reqid)
                            .update({"permission" : true});

                        /* notification to user when request accepted by admin*/
                        String url=await DynamicLinksService.createDynamicLink(widget.request.reqid);
                        // print('email $email tokenid $tokenid');
                        await sendNotification([tokenId], 'Your request has been approved.', 'Blood Request Approved');
                        await sendEmail(email, url, 'You blood request has been approved by admin. We hope you find your donor through Raktkhoj.Click on the link to view your request', 'Blood Request Approved');
                      },
                      child: Center(
                        child: Text(
                          'Approve',
                          textAlign: TextAlign.center,
                          style: textTheme.subtitle1.copyWith(color: Colors.white),

                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          kMainRed,
                        ),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        )),
                      ),
                      onPressed: () async {
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

                        //request rejected
                        FirebaseFirestore.instance.collection("Blood Request Details").doc(widget.request.reqid)
                            .update({"permission" : false, "active": false});
                      },
                      child: Center(
                        child: Text(
                          'Disapprove',
                          textAlign: TextAlign.center,
                          style: textTheme.subtitle1.copyWith(color: Colors.white),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 50,
                ),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                            kMainRed,
                          ),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.all(12),
                    ),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    )),
                  ),
                  onPressed: () async {
                    if(widget.request.raiserUid==currentUser.uid){
                      FirebaseFirestore.instance.collection("Blood Request Details").doc(widget.request.reqid)
                      .update({"active": false});
                      return ;
                    }

                    if(valEnd == null) {
                      List<String> canDonateBloodSet=possibleDonors(widget.request.bloodGroup.toString());
                      if(canDonateBloodSet.contains(donorBloodGroup)){
                        showDialog(
                            context: context,
                            builder: (context) {
                              Future.delayed(Duration(seconds: 2), () {
                                Navigator.of(context).pop();
                              });
                              return AlertDialog(
                                content: Text("Fit and Ready to donate",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 17)),
                              );
                            });




                            FirebaseFirestore.instance.collection("Blood Request Details").doc(widget.request.reqid)
                              .update({"donorUid" : currentUser.uid , "active" : false});
                            FirebaseFirestore.instance.collection("User Details").doc(currentUser.uid)
                                .update({"Last Donation":DateTime.now()});
                      }else{
                        //to show blood group incompatibility error
                        //print(donorBloodGroup);
                        return showDialog(context: context,
                            builder: (BuildContext context){
                              return CustomDialogBox(
                                title: "Hey ${donorName} !!",
                                descriptions: "You cannot donate to patients with ${widget.request.bloodGroup} blood group .Please donate to compatible request raisers",
                                text: "Ok",
                                img: profilePhoto,
                              );
                            }
                        );
                      }

                      }else {
                      //valEnd.add(Duration(days: 2));
                      var presentDate = DateTime.now();
                      var lastDate=valEnd.toDate();
                      var dur = presentDate.difference(lastDate);
                      if (dur.inDays<2) {
                        //to show error dialog box

                        String cooldown = (2-dur.inDays).toString();
                        return showDialog(context: context,
                            builder: (BuildContext context) {
                              return CustomDialogBox(
                                title: "Hey $donorName !!",
                                descriptions: "Your cooldown peroid is not over. Please try after $cooldown days .",
                                text: "Ok",
                                img: profilePhoto,
                              );
                            }
                        );
                      } else {
                        List<String> canDonateBloodSet = possibleDonors(
                            widget.request.bloodGroup.toString());
                        if (canDonateBloodSet.contains(donorBloodGroup)) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  Future.delayed(Duration(seconds: 2), () {
                                    Navigator.of(context).pop();
                                  });
                                  return AlertDialog(
                                    content: Text("Fit and Ready to donate",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 17)),
                                  );
                                });
                            String url=await DynamicLinksService.createDynamicLink(widget.request.reqid);
                            await sendNotification([tokenId], 'You found a donor.', 'Your blood request got a potential donor');
                            await sendEmail(email, url, 'Your blood request matched with a potential donor \n. Hope we could save a life, connect with the donor- $donorEmail.\n Click on the link to view your request', 'Found a Donor');

                            FirebaseFirestore.instance.collection("Blood Request Details").doc(widget.request.reqid)
                                .update({"donorUid" : currentUser.uid , "active" : false});
                            FirebaseFirestore.instance.collection("User Details").doc(currentUser.uid)
                                .update({"Last Donation":DateTime.now()});

                        } else {
                          //to show blood group incompatibility error
                          print(donorBloodGroup);
                          return showDialog(context: context,
                              builder: (BuildContext context) {
                                return CustomDialogBox(
                                  title: "Hey $donorName !!",
                                  descriptions: "You cannot donate to patients with ${widget.request
                                      .bloodGroup} .Please donate to compatible request raisers",
                                  text: "Ok",
                                  img: profilePhoto,
                                );
                              }
                          );
                        }
                      }
                    }
                  },
                  child: Center(
                    child: Text(
                      to_show,
                      textAlign: TextAlign.center,
                      style: textTheme.subtitle1.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
              // if (!request.isFulfilled &&
              //     request.uid == FirebaseAuth.instance.currentUser.uid)
              //   _MarkFulfilledBtn(request: request),
            ],
          ),
        ),
      ),
      ),
    );
  }



 //to return potential donor bloodGroups for a request
    List<String> possibleDonors(String s) {
      switch (s) {
        case 'A+':
          return ['A+', 'A-', 'O+', 'O-'];
        case 'A-':
          return ['A-', 'O-'];
        case 'B+':
          return ['B+', 'B-', 'O+', 'O-'];
        case 'B-':
          return ['B-', 'O-'];
        case 'AB+':
        // can get from all
          return ['A+', 'A-', 'O+', 'O-','B+', 'B-','AB-','AB+'];
        case 'AB-':
          return [
            'AB-',
            'A-',
            'B-',
            'O-'
          ];
        case 'O+':
          return ['O+', 'O-'];
        case 'O-':
          return ['O-'];
        default:
          return [];
      }
  }
}