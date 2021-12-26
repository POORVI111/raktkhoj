import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:raktkhoj/colors.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({Key key , this.title}) : super(key: key);
  final String title;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // ignore: unnecessary_statements
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: size.width*0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: kMainRed,

        ),
        padding: EdgeInsets.symmetric(vertical: 20),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18
        ),
        ),
      ),
    );
  }
}
