import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raktkhoj/Colors.dart';
import 'package:raktkhoj/Login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegisterButton extends StatelessWidget {
  const RegisterButton({Key? key, required this.title,
    required this.userEmail,
    required this.userPassword,
    required this.userUserName,
    required this.userBloodGroup}) : super(key: key);

  final String title;

  final _auth = FirebaseAuth.instance;
  final String userEmail;
  final String userPassword;
  final String userUserName;
  final String userBloodGroup;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    // ignore: unnecessary_statements
    return InkWell(
      onTap: () async {

          try {
            final newUser = await _auth.createUserWithEmailAndPassword(
                  email: userEmail, password: userPassword);
              if (newUser != null) {
                User? user = newUser.user;
                user!.sendEmailVerification();
                await user
                    .updateProfile(
                  displayName: userName,
                )
                    .then((value) {
                  FirebaseDatabase.instance
                      .reference()
                      .child('User/${user.uid}')
                      .update({
                    'Email': userEmail,
                    'Name': userName,
                    'DefaultAdd': null,
                    'BloodGroup':userBloodGroup
                });
              });
            }
            _showDialog1(context, "Verification link has been sent to your mail");
//                            Fluttertoast.showToast(
//                                msg:
//                                "Verification link has been sent to your mail",
//                                toastLength: Toast.LENGTH_SHORT,
//                                gravity: ToastGravity.BOTTOM,
//                                timeInSecForIosWeb: 1,
//                                backgroundColor: Colors.blueGrey,
//                                textColor: Colors.white,
//                                fontSize: 14.0);
            //Navigator.pushReplacementNamed(context, Login.id);

          } catch (e) {
            switch (e.toString()) {
              case "email-already-in-use":
                errorMsg =
                "The email address is already in use by another account.";
                break;
              case "wrong-password":
                errorMsg = "Incorrect password.";
                break;
              case "user-not-found":
                errorMsg = "No user found with this email.";
                break;
              case "user-not-found":
                errorMsg = "No user found with this email.";
                break;
              case "weak-password":
                errorMsg = "very weak password";
                break;
              case "operation-not-allowed":
                errorMsg =
                "Too many requests. Try again later.";
                break;
              case "invalid-email":
                errorMsg = "Email address is invalid.";
                break;
              default:
                errorMsg = "Sign Up failed. Please try again.";
            }
            _showDialog1(context, errorMsg);
            print(e);
          }
      },


      borderRadius: BorderRadius.circular(30),


      child: Container(
        width: size.width * 0.8,
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
              child:  Text('Ok',style: GoogleFonts.montserrat(fontSize: 14,color: kMainRed,fontWeight: FontWeight.w600),),
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
String errorMsg = '';

