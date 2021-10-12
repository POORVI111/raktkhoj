import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';


//import 'phone_login_page.dart';
import 'splash_screen.dart';
import 'home_page.dart';

/*void main() {
  runApp(MyApp());
}*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


final _auth = FirebaseAuth.instance;

Future<User> getCurrentUser() async {
  User currentUser;
  currentUser = (await _auth.currentUser)!;
  return currentUser;
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Raktkhoj',
      home: //Login(),
      FutureBuilder(
        future: getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SplashScreen();
          } else {
            return SplashScreen();
          }
        },
      ),
    );
  }
}



