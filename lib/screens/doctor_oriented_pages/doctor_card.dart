import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:raktkhoj/model/user.dart';

import '../../Constants.dart';

class DoctorCard extends StatefulWidget {

  DoctorCard({this.doctor});

  final UserModel doctor;

  @override
  _DoctorCardState createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCard> {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Padding(
        padding: const EdgeInsets.only(top: 50.0),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(width: 15,),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(
                        FontAwesomeIcons.userNurse,
                        color: Color(0xFFBC002D),
                        size: 22,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(widget.doctor.name,
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




              ],
            ),
          ),
        ),
      ),
    );
  }
}
