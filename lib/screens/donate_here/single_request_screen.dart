import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:raktkhoj/Colors.dart';
import 'package:raktkhoj/model/request.dart';
import 'package:raktkhoj/model/user.dart';
import 'package:raktkhoj/screens/Chat/chat_screen.dart';
import '../../Constants.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;



class SingleRequestScreen extends StatelessWidget {
  final RequestModel request;
  final String name;
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
  const SingleRequestScreen({Key key, this.request, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
          title: const Text('Blood Request Details'),
          actions: [
            IconButton(
              icon: Icon(
                FontAwesomeIcons.shareAlt,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
               FontAwesomeIcons.ellipsisV,
              ),
              onPressed: () {},
            )

        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child:SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 0, right: 0, top: 20),
                child: Container(
                  height: MediaQuery.of(context).size.height/3,
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
                                  Text(name,
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
                                  Text(request.dueDate,
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
                                  Text(request.bloodGroup,
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
                                      Text(request.address.toString(),
                                        style: kNumberTextStyle,
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Icon(
                                      Icons.directions,
                                      color: Colors.blue,
                                      size: 22,
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
                                  Text(possibleDonors(request.bloodGroup.toString())
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
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        UrlLauncher.launch("tel:${request.phone}");
                      },
                      textColor: Colors.white,
                      padding: EdgeInsets.only(left: 5.0, right: 5.0),
                      color: kMainRed,
                      child: Icon(Icons.phone),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                    ),
                    RaisedButton(
                      onPressed: () async {
                        UserModel requestRiser= await getUserDetailsById(request.raiserUid);

                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ChatScreen(receiver: requestRiser,)
                        ));
                      },
                      textColor: Colors.white,
                      padding: EdgeInsets.only(left: 5.0, right: 5.0),
                      color: kMainRed,
                      child: Icon(FontAwesomeIcons.comments),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                    ),
                    RaisedButton(
                      onPressed: () {
                        String message="Hello $name, I am a potential blood donor willing to help you. Reply back if you still need blood.";
                        UrlLauncher.launch("sms:${request.phone}?body=$message");
                      },
                      textColor: Colors.white,
                      padding: EdgeInsets.only(left: 5.0, right: 5.0),
                      color: kMainRed,
                      child: Icon(FontAwesomeIcons.sms),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 100,
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

                  },
                  child: Center(
                    child: Text(
                      'Donate',
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

class _MarkFulfilledBtn extends StatefulWidget {
 // final BloodRequest request;

 // const _MarkFulfilledBtn({Key key, this.request}) : super(key: key);

  @override
  _MarkFulfilledBtnState createState() => _MarkFulfilledBtnState();
}

class _MarkFulfilledBtnState extends State<_MarkFulfilledBtn> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(child: CircularProgressIndicator()),
    )
        : Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            Colors.green[600],
          ),
          padding: MaterialStateProperty.all(
            const EdgeInsets.all(12),
          ),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          )),
        ),
        onPressed: () async {
          // setState(() => _isLoading = true);
          // try {
          //   await FirebaseFirestore.instance
          //       .collection('blood_requests')
          //       .doc(widget.request.id)
          //       .update({'isFulfilled': true});
          //   widget.request.isFulfilled = true;
          //   Navigator.pop(context);
          // } on FirebaseException catch (e) {
          //   Fluttertoast.showToast(msg: e.message);
          // } catch (e) {
          //   Fluttertoast.showToast(
          //     msg: 'Something went wrong. Please try again',
          //   );
          // }
          // setState(() => _isLoading = false);
        },
        child: Center(
          child: Text(
            'Mark as Fulfilled',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .subtitle1
                .copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}