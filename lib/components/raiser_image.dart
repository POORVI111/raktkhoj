import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:raktkhoj/components/cached_image.dart';

import 'dart:math' as math;


import 'package:raktkhoj/model/request.dart';
import 'package:raktkhoj/model/user.dart';
import 'package:raktkhoj/screens/Chat/chat_screen.dart';



class RaiserImage extends StatefulWidget {
  RaiserImage({this.request , this.type});
  final RequestModel request;
  final String type;

  @override
  _RaiserImageState createState() => _RaiserImageState();
}
  class _RaiserImageState extends State<RaiserImage>{
  String imageUrl="";

  Future<UserModel> getUserDetailsById() async {
    try {
      if(widget.type=="donations"){
        DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection(
            "User Details").doc(widget.request.raiserUid).get();
        return UserModel.fromMap(documentSnapshot.data());
      }else{
        DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection(
            "User Details").doc(widget.request.donorUid).get();
        return UserModel.fromMap(documentSnapshot.data());
      }

    } catch (e) {
      print(e);
      return null;
    }

  }

  @override
  void initState() {
    if(widget.type=='donations'){
      FirebaseFirestore.instance.collection("User Details").doc(widget.request.raiserUid).get().then((value){
        imageUrl=value.data()["ProfilePhoto"];
        setState(() {
          imageUrl=imageUrl;
        });
      });
    }else{
      FirebaseFirestore.instance.collection("User Details").doc(widget.request.donorUid).get().then((value){
        imageUrl=value.data()["ProfilePhoto"];
        setState(() {
          imageUrl=imageUrl;
        });
      });
    }

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
        onTap:() async {
          UserModel to_chat= await getUserDetailsById();

          Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ChatScreen(receiver: to_chat,)
          ));
        },
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