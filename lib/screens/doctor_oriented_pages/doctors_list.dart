import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raktkhoj/components/animated_circle.dart';
import 'package:raktkhoj/components/rectangle_indicator.dart';
import 'package:raktkhoj/components/shadows.dart';
import 'package:raktkhoj/model/background_colors.dart';
import 'package:raktkhoj/model/user.dart';
import 'dart:math' as math;

import '../../Colors.dart';
import 'doctor_card.dart';
import 'doctor_image.dart';
import 'dart:convert';

class DoctorsList extends StatefulWidget {


  @override
  _DoctorsListState createState() => _DoctorsListState();
}
const double _kViewportFraction = 0.75;
class _DoctorsListState extends State<DoctorsList>
    with TickerProviderStateMixin{

  //code to show list of doctors to contact in emergency purpose

  List<UserModel> menu=[];


  final PageController _backgroundPageController = new PageController();
  final PageController _pageController = new PageController(viewportFraction: _kViewportFraction);
  ValueNotifier<double> selectedIndex = new ValueNotifier<double>(0.0);
  Color _backColor = const Color.fromRGBO(240, 232, 223, 1.0);
  int _counter = 0;
  int _cartQuantity = 0;
  AnimationController controller, scaleController;
  Animation<double> scaleAnimation;
  bool firstEntry = true;
  User currentUser;


  Future<List<UserModel>> fetchAllDoctors()  async {
    List<UserModel> doctorList = <UserModel>[];

    User curr=FirebaseAuth.instance.currentUser;

    //to check if a user is a doctor or not
    //to check doctor is admin verified or not


      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection("User Details").get();
      for (var i = 0; i < querySnapshot.docs.length; i++) {
        UserModel x=UserModel.fromMap(querySnapshot.docs[i].data());

        if(x!=null&&x.Doctor!=null){
          if(querySnapshot.docs[i]['Doctor']&&querySnapshot.docs[i]['Doctor']==true
              &&querySnapshot.docs[i]['AdminVerified']==true)
          {
            doctorList.add(UserModel.fromMap(querySnapshot.docs[i].data()));
          }
        }

      }

      print(doctorList.length);
      return doctorList;
  }

  @override
  void initState() {
    super.initState();
    //initialising variables for animatiomn
    controller = new AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    scaleController = new AnimationController(vsync: this, duration: Duration(milliseconds: 175));
    scaleAnimation = new Tween<double>(begin: 1.0, end: 1.20).animate(
        new CurvedAnimation(parent: scaleController, curve: Curves.easeOut)
    );
    fetchAllDoctors().then((List<UserModel> list) {
      setState(() {
        menu = list;
      });
    });

  }


  @override
  void dispose() {
    controller.dispose();
    scaleController.dispose();
    _pageController.dispose();
    _backgroundPageController.dispose();
    super.dispose();
  }


  //widget for showing card of request or donation
  _contentWidget(UserModel doctor, int index, Alignment alignment, double resize) {
    return new Stack(
      children: <Widget>[
        new Center(
          child: new Container(
            //color: kBackgroundColor,
            alignment: alignment,
            width: 300.0 * resize,
            height: 500.0 * resize,
            child: new Stack(
              children: <Widget>[
                shadow2,
                shadow1,
                new DoctorCard(doctor: doctor,),

                new DoctorImage(doctor: doctor,),

              ],
            ),
          ),
        ),
      ],
    );
  }


  Iterable<Widget> _buildPages() {
    final List<Widget> pages = <Widget>[];
    for (int index = 0; index < menu.length; index++) {
      var alignment = Alignment.center.add(new Alignment(
          (selectedIndex.value - index) * _kViewportFraction, 0.0));
      var resizeFactor = (1 -
          (((selectedIndex.value - index).abs() * 0.3).clamp(0.0, 1.0)));
      pages.add(
          _contentWidget(
            menu[index],
            index,
            alignment,
            resizeFactor,
          )
      );
    }
    return pages;
  }



  @override
  Widget build(BuildContext context) {
    //timeDilation = 1.0;
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    //checking if list is empty
    if(menu.isEmpty){
      return Center(child: Text("Empty list!!"));
    }

    //to set heading of page as donations or requests
    String heading="Contact doctors in emergency";


    //stack to show rest of data
    return new Stack(
      children: <Widget>[

        new Positioned.fill(bottom: screenHeight / 2,
            child: new Container(
                decoration: new BoxDecoration(color: _backColor))),
        //new CustomAppBar(),
        new AppBar(
          title:  Text(heading),
          actions: [
          ],),
        new Align(alignment: Alignment.bottomCenter,
            child: new Padding(padding: const EdgeInsets.only(bottom: 50.0),
                child: new RectangleIndicator(
                    _backgroundPageController, menu.length, 6.0, Colors.grey[400],
                    kBackgroundColor))),
        new PageView.builder(
          itemCount: menu.length,
          itemBuilder: (BuildContext context, int itemCount){
            return Container();
          },
          controller: _backgroundPageController,
          onPageChanged: (index) {
            setState(() {
              _backColor =
              colors[new math.Random().nextInt(colors.length)];
            });
          },
        ),
        new NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            if (notification.depth == 0 &&
                notification is ScrollUpdateNotification) {
              selectedIndex.value = _pageController.page;
              if (_backgroundPageController.page != _pageController.page) {
                _backgroundPageController.position
                // ignore: deprecated_member_use
                    .jumpToWithoutSettling(_pageController.position.pixels /
                    _kViewportFraction);
              }
              setState(() {});
            }
            return false;
          },
          child: new PageView(
            controller: _pageController,
            children:_buildPages(),
          ),
        ),
        Positioned.fill(
          top: 30.0,
          right: 5.0,
          bottom: 100.0,
          child: new StaggerAnimation(controller: controller.view),
        ),


      ],
    );
  }
}
