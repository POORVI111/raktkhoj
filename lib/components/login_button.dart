import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raktkhoj/Login.dart';
import 'package:raktkhoj/screens/home/Home_screen.dart';
import 'package:raktkhoj/trial_basis/page_guide.dart';
import 'package:raktkhoj/trial_basis/profile.dart';

import '../Colors.dart';
//import '../page_guide.dart';

class LoginButton extends StatelessWidget {
   LoginButton({Key key ,
     this.title,
    this.userEmail,
    this.userPassword,}) : super(key: key);

  final String title;

  final _auth = FirebaseAuth.instance;
  final String userEmail;
  final String userPassword;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // ignore: unnecessary_statements
    return InkWell(
      onTap: () async {
        try {
          final user = await _auth.signInWithEmailAndPassword(
              email: userEmail, password: userPassword);
          if (user != null) {
            print("Success");
            print(userEmail+userPassword);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PageGuide()));

          }

        } catch (e) {
          switch (e) {
            case "wrong-password":
              errorMsg = "Incorrect password.";
              break;
            case "user-not-found":
              errorMsg = "No user found with this email.";
              break;
            case "user-disabled":
              errorMsg =
              "User with this email has been disabled.";
              break;
            case "operation-not-allowed":
              errorMsg =
              "Too many requests. Try again later.";
              break;
            case "invalid-email":
              errorMsg = "Email address is invalid.";
              break;
            default:
              errorMsg = "Login failed. Please try again.";
          }

          _showDialog1(context, errorMsg);
//                            switch (e.code) {
//                              case "INVALID_PASSWORD":
//                                setState(() {
//                                  errorMsg = "This email is already in use.";
//                                });
//                                _showDialog1(context);
//                            }

          print(e);
        }
      },
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
  Future<void> _showDialog1(BuildContext context, String errorMsg) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //title: Text('Alert'),
          content: Text(errorMsg),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok',style: GoogleFonts.montserrat(fontSize: 14,color: kMainRed,fontWeight: FontWeight.w600),),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
String errorMsg='';
