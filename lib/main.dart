import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:raktkhoj/services/localization_service.dart';
import 'screens/home/Home_screen.dart';
import 'splash_screen.dart';


/*void main() {
  runApp(MyApp());
}*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(MyApp());
}


final _auth = FirebaseAuth.instance;

Future<User> getCurrentUser() async {
  User currentUser;
  currentUser = (await _auth.currentUser);
  return currentUser;
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Raktkhoj',
        theme: ThemeData(
        //...
        // CUSTOMIZE showDatePicker Colors
        colorScheme: ColorScheme.light(primary: const Color(0xFFed1e25)),
        //buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
    //
    //...
    ),
      translations: LocalizationService(), // your translations
      locale: LocalizationService().getCurrentLocale(), // translations will be displayed in that locale
      fallbackLocale: Locale(
        'en',
        'US',
      ), // specify the fallback locale in case an invalid locale is selected.
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



