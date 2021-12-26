/*
to show doctors info
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:raktkhoj/model/user.dart';
import 'package:raktkhoj/screens/Chat/chat_screen.dart';

import '../../colors.dart';
import '../../constants.dart';
import '../../provider/call_utils.dart';
import '../../main.dart';

class DoctorCard extends StatefulWidget {

  DoctorCard({this.doctor});

  final UserModel doctor;

  @override
  _DoctorCardState createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCard> {

  UserModel sender;
  String _currentUserId;

  @override
  void initState() {
    super.initState();
    getCurrentUser().then((user) {
      _currentUserId = user.uid;

      setState(() {
        sender = UserModel(
          uid: user.uid,
          name: user.displayName,
          profilePhoto: user.photoURL,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: new Card(
          elevation: 0.0,
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
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Row(
                //   children: <Widget>[
                //     // Padding(
                //     //   padding: const EdgeInsets.all(5.0),
                //     //   child: Icon(
                //     //     FontAwesomeIcons.userNurse,
                //     //     color: Color(0xFFBC002D),
                //     //     size: 22,
                //     //   ),
                //     // ),

                Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Center(

                    child: Text(widget.doctor.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,

                      ),

                    ),
                  ),
                ),

                //
                //   ],
                // ),
                SizedBox(height: 20,),
                Row(
                  children: <Widget>[
                    SizedBox(width: 15,),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(
                        FontAwesomeIcons.bookOpen,
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
                            'Education',
                            style: kLabelTextStyle,
                          ),
                          SizedBox(height: 3,),
                          Text(widget.doctor.Degree,
                            style: kNumberTextStyle,
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: <Widget>[
                    SizedBox(width: 15,),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(
                        Icons.assistant_rounded,
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
                            'Specialisation:',
                            style: kLabelTextStyle,
                          ),
                          SizedBox(height: 6,),
                          Text(widget.doctor.Description,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: kNumberTextStyle,
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () async =>
                      await CallUtils.cameraAndMicrophonePermissionsGranted()
                          ? CallUtils.dial(
                        from: sender,
                        to: widget.doctor,
                        context: context,
                      )
                          :
                      {},
                      textColor: Colors.white,
                      padding: EdgeInsets.only(left: 5.0, right: 5.0),
                      color: kMainRed,
                      child: Icon(Icons.video_call),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                    ),
                    RaisedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                receiver: widget.doctor,
                              ),
                            ));
                      },
                      textColor: Colors.white,
                      padding: EdgeInsets.only(left: 5.0, right: 5.0),
                      color: kMainRed,
                      child: Icon(FontAwesomeIcons.comments),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                    ),
                  ],
                ),




              ],
            ),
          ),
        ),
      ),
    );
  }
}
