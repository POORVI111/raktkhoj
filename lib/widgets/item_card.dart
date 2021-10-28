import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:raktkhoj/Constants.dart';

import 'dart:math' as math;


import 'package:raktkhoj/model/request.dart';
import 'package:raktkhoj/screens/donate_here/request_direction.dart';
import 'package:raktkhoj/user_oriented_pages/profile.dart';

class ItemCard extends StatelessWidget {


   ItemCard({this.request, this.increment, this.decrement});

  final RequestModel request;
  final VoidCallback increment;
  final VoidCallback decrement;

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
                          Text(request.patientName,
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
                          Text(request.qty,
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
                          Text(request.condition,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: kNumberTextStyle,
                          ),
                        ],
                      ),
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
                                    RequestDirection(location: request.location, address: request.address)));
                          }

                      ),
                    ),

                  ],
                ),
                /*Row(
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
                              Row(
                                children:[
                                  Text(
                                  'Location',
                                  style: kLabelTextStyle,
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
                                                  RequestDirection(location: request.location, address: request.address)));
                                        }

                                    ),
                                  ),

                                ]
                              ),

                            ],
                          ),

                        ],
                      ),
                    ),

                  ],
                ),*/

                //SizedBox(height: 1,),

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