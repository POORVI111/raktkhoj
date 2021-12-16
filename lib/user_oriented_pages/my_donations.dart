import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart' show timeDilation ;
import 'package:flutter/material.dart';

import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:raktkhoj/Colors.dart';

import 'package:raktkhoj/model/background_colors.dart';

import 'package:raktkhoj/model/request.dart';
import 'package:raktkhoj/components/animated_circle.dart';


import 'package:raktkhoj/components/raiser_image.dart';
import 'package:raktkhoj/components/item_card.dart';
import 'package:raktkhoj/components/rectangle_indicator.dart';
import 'package:raktkhoj/components/shadows.dart';

class MenuPager extends StatefulWidget {
  final String type;

  const MenuPager({Key key , this.type}):super(key: key);
  @override
  _MenuPagerState createState() => new _MenuPagerState();
}

const double _kViewportFraction = 0.75;

class _MenuPagerState extends State<MenuPager> with TickerProviderStateMixin {

  //code to show history of donations in animated form

  List<RequestModel> menu=[];


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

  Future<List<RequestModel>> fetchAllDonations()  async {
    List<RequestModel> requestList = <RequestModel>[];

    User curr=FirebaseAuth.instance.currentUser;

    //to check if to show donation history or requests history
    //and accordingly update the request list

    if( widget.type =="donations"){
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection("Blood Request Details").get();
      for (var i = 0; i < querySnapshot.docs.length; i++) {
        if(querySnapshot.docs[i]['donorUid']==curr.uid){
          requestList.add(RequestModel.fromMap(querySnapshot.docs[i].data()));
        }
      }
    }else{
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection("Blood Request Details").get();
      for (var i = 0; i < querySnapshot.docs.length; i++) {
        if(querySnapshot.docs[i]['raiserUid']==curr.uid && querySnapshot.docs[i]['active']==false
            &&querySnapshot.docs[i]['permission']==true && querySnapshot.docs[i]['donorUid']!='') {
          requestList.add(RequestModel.fromMap(querySnapshot.docs[i].data()));
        }
      }
    }



    return requestList;
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
    fetchAllDonations().then((List<RequestModel> list) {
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

  //code for playing animations
  Future<Null> playAnimation() async {
    try {
      if(controller.isCompleted){
        controller.reset();
        await controller.forward().whenComplete((){
          scaleController.forward().whenComplete((){
            scaleController.reverse();
            setState(() {
              _cartQuantity = _cartQuantity + _counter;
              _counter = 0;
            });
          });
        });
      } else {
        await controller.forward().whenComplete((){
          setState(() {
            if(firstEntry){
              firstEntry = false;
            }
            _cartQuantity = _cartQuantity + _counter;
            _counter = 0;
          });
          scaleController.forward().whenComplete((){
            scaleController.reverse();
          });
        });
      }
    } on TickerCanceled {

    }
  }


  //widget for showing card of request or donation
  _contentWidget(RequestModel donation, int index, Alignment alignment, double resize) {
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
                new ItemCard(
                  request: donation,

                ),

                new RaiserImage(request: donation ,type: widget.type,),

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
    timeDilation = 1.0;
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    //checking if list is empty
    if(menu.isEmpty){
      return Center(child: Text("Empty list!!"));
    }

    //to set heading of page as donations or requests
    String heading="";
    if(widget.type=='donations'){
      heading="Donations";
    }else{
      heading="My Requests";
    }

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