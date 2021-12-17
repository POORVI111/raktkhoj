import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raktkhoj/components/cached_image.dart';
import 'package:raktkhoj/model/user.dart';
import 'package:raktkhoj/screens/Chat/chat_screen.dart';

class DoctorImage extends StatefulWidget {
  DoctorImage({this.doctor });
  final UserModel doctor;


  @override
  _DoctorImageState createState() => _DoctorImageState();
}

class _DoctorImageState extends State<DoctorImage> {

  String imageUrl="";

  Future<UserModel> getDoctorsDetailsById() async {
    try {
        DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection(
            "User Details").doc(widget.doctor.uid).get();
        return UserModel.fromMap(documentSnapshot.data());
    } catch (e) {
      print(e);
      return null;
    }

  }

  @override
  void initState() {

      FirebaseFirestore.instance.collection("User Details").doc(widget.doctor.uid).get().then((value){
        imageUrl=value.data()["ProfilePhoto"];
        setState(() {
          imageUrl=imageUrl;
        });
      });


  }

  @override
  Widget build(BuildContext context) {
    return new Align(
      alignment: FractionalOffset.topCenter,
      //alignment: FractionalOffset.topRight,
      child:  new GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap:() async {
          UserModel to_chat= await getDoctorsDetailsById();

          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => ChatScreen(receiver: to_chat,)
          ));
        },
        child: new Hero(
          tag: 'icon-${widget.doctor.name}',
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
