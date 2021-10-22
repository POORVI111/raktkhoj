import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:raktkhoj/screens/donate_here/single_request_screen.dart';
import 'package:raktkhoj/services/dynamic_link.dart';
import 'package:raktkhoj/services/localization_service.dart';
import 'package:raktkhoj/user_oriented_pages/page_guide.dart';
import 'components/image_upload_provider.dart';
import 'model/request.dart';
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
class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    DynamicLinksService().initDynamicLinks();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
        ],
    child: GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Raktkhoj',
        theme: ThemeData(
        //...
        // CUSTOMIZE showDatePicker Colors
        colorScheme: ColorScheme.light(primary: const Color(0xFFed1e25)),
        buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
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
            return PageGuide();
          } else {
            return SplashScreen();
          }
        },
      ),
    )
    );
  }

  // Future<void> initDynamicLinks() async {
  //   FirebaseDynamicLinks.instance.onLink(
  //       onSuccess: (PendingDynamicLinkData dynamicLink) async {
  //         final Uri deepLink = dynamicLink.link;
  //
  //         if (deepLink != null) {
  //           // ignore: unawaited_futures
  //           //Navigator.pushNamed(deepLink.path);
  //           DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
  //               .instance.collection("Blood Request Details").doc(
  //               deepLink.queryParameters['requestid']).get();
  //           print("requestid ${deepLink.queryParameters['requestid']}");
  //           RequestModel requestModel = RequestModel.fromMap(snapshot.data());
  //           Navigator.of(context).push(MaterialPageRoute(
  //             builder: (_) => SingleRequestScreen(request: requestModel),
  //           ));
  //
  //         }
  //       }, onError: (OnLinkErrorException e) async {
  //     print('onLinkError');
  //     print(e.message);
  //   });
  //
  //   final PendingDynamicLinkData data =
  //   await FirebaseDynamicLinks.instance.getInitialLink();
  //   final Uri deepLink = data.link;
  //
  //   if (deepLink != null) {
  //     try {
  //       DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
  //           .instance.collection("Blood Request Details").doc(
  //           deepLink.queryParameters['requestid']).get();
  //       print('deeplink$deepLink');
  //       print(deepLink.queryParameters['requestid']);
  //       RequestModel requestModel = RequestModel.fromMap(snapshot.data());
  //       Navigator.of(context).push(MaterialPageRoute(
  //         builder: (_) => SingleRequestScreen(request: requestModel),
  //       ));
  //     }catch(e){}
  //     // ignore: unawaited_futures
  //     // Navigator.pushNamed(context, '/${deepLink.queryParameters['call_id']}');
  //
  //     // Navigator.pushNamed(context, deepLink.path);
  //   }
  // }

}



