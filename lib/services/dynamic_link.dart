/*
  generate dynamic link for particular screen
 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:raktkhoj/model/request.dart';
import 'package:raktkhoj/screens/donate_here/single_request_screen.dart';

class DynamicLinksService {

  //create link
  static Future<String> createDynamicLink(String parameter) async {

    String uriPrefix = "https://raktkhoj.page.link";

    final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: uriPrefix,
        link: Uri.parse('https://raktkhoj.page.link//?requestid=$parameter'),
        androidParameters: AndroidParameters(
          packageName: 'com.example.raktkhoj',
          minimumVersion: 0,
        ));



    // final Uri dynamicUrl = await parameters.buildUrl();
    final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
    final Uri shortUrl = shortDynamicLink.shortUrl;
    print(shortUrl.toString());
    return shortUrl.toString();
  }

  //initialise on tapping dynamic link
  Future<void> initDynamicLinks() async {
    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();

    await _handleDynamicLink(data);

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          _handleDynamicLink(dynamicLink);
        }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
  }

  //after detecting dynamic link
  Future<void> _handleDynamicLink(PendingDynamicLinkData data) async {
    final Uri deepLink = data?.link;

    if (deepLink == null) {
      return;
    }

    var title = deepLink.queryParameters['requestid'];
    if (title != null) {
      //print("refercode=$title");
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance.collection("Blood Request Details").doc(title).get();
      print("requestid ${title}");
      RequestModel requestModel = RequestModel.fromMap(snapshot.data());
      // await Navigator.push(context,MaterialPageRoute(
      //   builder: (context) => SingleRequestScreen(request: requestModel),
      // ));

      await Get.to(() =>SingleRequestScreen(request: requestModel));

    }
  }


}