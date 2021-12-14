import 'package:flutter/material.dart';
import 'Onboarding.dart';
import 'dart:async';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shimmer/shimmer.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    _mockCheckForSession().then(
            (status) {
          if (status) {
            _navigateToHome();
          } else {
            _navigateToLogin();
          }
        }
    );
  }


  Future<bool> _mockCheckForSession() async {
    await Future.delayed(Duration(milliseconds: 6000), () {});

    return true;
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (BuildContext context) => OnBoarding()
        )
    );
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (BuildContext context) => OnBoarding()
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 40,),
            Image.asset('images/logo.png', width: 100, height: 90),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Shimmer.fromColors(
                  period: Duration(milliseconds: 2000),
                  baseColor: Color(0xffe53033),
                  highlightColor: Colors.white.withOpacity(0.8),
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "RAKTKHOJ",
                      style: TextStyle(
                          letterSpacing: 3,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
//                Text(
//                  "LINK",
//                  style: TextStyle(
//                      letterSpacing: 3,
//                      fontSize: 50.0,
//                      fontWeight: FontWeight.bold,
//                  ),
//                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


}
