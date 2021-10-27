import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:raktkhoj/components/cached_image.dart';

import 'dart:math' as math;

import 'package:raktkhoj/model/Food.dart';
import 'package:raktkhoj/model/request.dart';



class FoodImage extends StatefulWidget {
  FoodImage({this.request});
  final RequestModel request;

  @override
  _FoodImageState createState() => _FoodImageState();
}
  class _FoodImageState extends State<FoodImage>{
  String imageUrl="";
  @override
  void initState() {
    FirebaseFirestore.instance.collection("User Details").doc(widget.request.raiserUid).get().then((value){
      imageUrl=value.data()["ProfilePhoto"];
      setState(() {
        imageUrl=imageUrl;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    /*FirebaseFirestore.instance.collection("User Details").doc(request.raiserUid).get().then((value){
      imageUrl=value.data()["ProfilePhoto"];
    });*/

    return new Align(
      alignment: FractionalOffset.topCenter,
      //alignment: FractionalOffset.topRight,
      child:  new GestureDetector(
        behavior: HitTestBehavior.opaque,
//        onTap: () =>
//            Routes.navigateTo(
//              context,
//              '/detail/${food.id}',
//            ),
        child: new Hero(
          tag: 'icon-${widget.request.patientName}',
          child: CachedImage(
            imageUrl,
            radius: 100,
            isRound: true,
          ),
        ),
      ),
    );
  }
}