import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raktkhoj/components/cached_image.dart';
import 'package:raktkhoj/model/user.dart';

import '../Colors.dart';

class TopDonorsList extends StatefulWidget {


  @override
  _TopDonorsListState createState() => _TopDonorsListState();
}

class _TopDonorsListState extends State<TopDonorsList>
    with TickerProviderStateMixin{

  AnimationController animationController;


  @override
  void initState() {
    //animationController = AnimationController(
      //  duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void dispose() {
    //animationController.dispose();
    super.dispose();
  }


  Widget topDonors(BuildContext context){
    print(FirebaseFirestore.instance.collection("User Details").snapshots().length);
    return StreamBuilder(
          //proper query yet has to be written
        stream: FirebaseFirestore.instance
            .collection("User Details").snapshots(),

        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

          if (snapshot.data == null) {

            return Center(child: CircularProgressIndicator());
          }


          return ListView.builder(
            padding: const EdgeInsets.only(
                top: 0, bottom: 0, right: 16, left: 16),
            itemCount: snapshot.data.docs.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
                 return DonorView(snapshot.data.docs[index],context);
                //final int count = snapshot.data.docs.length > 5
                //? 5
                //  :snapshot.data.docs.length;
              /*final int count =1;
              final Animation<double> animation =
              Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: animationController,
                      curve: Interval((1 / count) * index, 1.0,
                          curve: Curves.fastOutSlowIn)));
              animationController.forward();

              return DonorView(
                snapshot: snapshot.data.docs[index],
                animation: animation,
                animationController: animationController,
//callback: widget.callBack,
              );*/
            },
          );

        });

  }

  Widget DonorView(DocumentSnapshot snapshot ,BuildContext context  ){
    UserModel _donor = UserModel.fromMap(snapshot.data());

    InkWell(
      splashColor: Colors.transparent,
      //onTap: callback,
      child: SizedBox(
        width: 280,
        child: Stack(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    width: 48,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 24, bottom: 24, left: 16),
                      child: Row(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(16.0)),
                            child: AspectRatio(
                                aspectRatio: 1.0,
                                child: CachedImage(_donor.profilePhoto , height: 70,width: 60,)),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: kMainRed,
                        borderRadius: const BorderRadius.all(
                            Radius.circular(16.0)),
                      ),
                      child: Row(
                        children: <Widget>[
                          const SizedBox(
                            width: 48 + 24.0,
                          ),
                          Expanded(
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(top: 16),
                                    child: Text(
                                      _donor.name,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        letterSpacing: 0.27,
                                        color: kDarkerGrey,
                                      ),
                                    ),
                                  ),
                                  const Expanded(
                                    child: SizedBox(),
                                  ),



                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: Container(
        height: 134,
        width: double.infinity,
        child:topDonors(context),
      ),
    );

  }
}

/*class DonorView extends StatelessWidget {
  const DonorView(
      {
        this.snapshot,
        this.animationController,
        this.animation,
      });

  //final VoidCallback callback;
  final DocumentSnapshot snapshot;
  final AnimationController animationController;
  final Animation<double> animation;


  @override
  Widget build(BuildContext context) {
    UserModel _donor = UserModel.fromMap(snapshot.data());

    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - animation.value), 0.0, 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              //onTap: callback,
              child: SizedBox(
                width: 280,
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: <Widget>[
                          const SizedBox(
                            width: 48,
                          ),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 24, bottom: 24, left: 16),
                              child: Row(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius:
                                    const BorderRadius.all(Radius.circular(16.0)),
                                    child: AspectRatio(
                                        aspectRatio: 1.0,
                                        child: CachedImage(_donor.profilePhoto , height: 70,width: 60,)),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: kMainRed,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(16.0)),
                              ),
                              child: Row(
                                children: <Widget>[
                                  const SizedBox(
                                    width: 48 + 24.0,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(top: 16),
                                            child: Text(
                                              _donor.name,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                letterSpacing: 0.27,
                                                color: kDarkerGrey,
                                              ),
                                            ),
                                          ),
                                          const Expanded(
                                            child: SizedBox(),
                                          ),



                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}*/
