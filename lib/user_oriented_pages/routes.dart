import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//was made to ease out the animation pages for donation and requests history
//but didnt worked out well
class Routes {
  static final  _router = FluroRouter();

  static void initRoutes() {
    /*_router.define("/detail/:id", handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          return new DetailPage(params["id"]);
        }));*/
  }

  static void navigateTo(context, String route) {
    _router.navigateTo(context, route);
  }

}