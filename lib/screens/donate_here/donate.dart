//import 'package:blooddonation/percentage_widget.dart';
//import 'package:blooddonation/recent_update_list_widget.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:raktkhoj/Colors.dart';
import 'package:raktkhoj/model/request.dart';
import 'package:raktkhoj/model/user.dart';
import 'package:raktkhoj/screens/donate_here/percentage_widget.dart';
import 'package:raktkhoj/screens/donate_here/search_request.dart';
import 'package:raktkhoj/screens/donate_here/single_request_screen.dart';
import 'package:flutter/rendering.dart';
import 'package:rxdart/rxdart.dart';



class Donate extends StatefulWidget {
  Donate({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DonateState createState() => _DonateState();
}

class _DonateState extends State<Donate> {
  double bannerHeight, listHeight, listPaddingTop;
  double cardContainerHeight, cardContainerTopPadding;
  //String name="";
  var  totalCount,donatedCount,availableCount,donatedPercentage,activePercentage;
  int selectedSort;
  var location;
  GeoPoint lesserGeopoint;
  GeoPoint greaterGeopoint;
  List<String> requestConditonList=["normal","critical"];

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var scrollController = ScrollController();





  String query = "";
  TextEditingController searchController = TextEditingController();
  @override
  void initState()  {
    super.initState();
    var firebaseUser =  FirebaseAuth.instance.currentUser;
    _firestore.collection("User Details").doc(firebaseUser.uid).get().then((value) {
      this.setState(() {
        location = value.data()['location'];
      });
    });
    selectedSort=0;
    getRequestsCount();
    getDocuments();
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels == 0)
          print('ListView scroll at top');
        else {
          print('ListView scroll at bottom');
          getDocumentsNext(); // Load next documents
        }
      }
    });

  }



  //geo nearby points
  void getGeoPoint() async{
    int distance=200;
    // ~1 mile of lat and lon in degrees
    var lat = 0.0144927536231884;
    var lon = 0.0181818181818182;
    double lowerLat = location.latitude - (lat * distance);
    double lowerLon = location.longitude - (lon * distance);
    var greaterLat = location.latitude + (lat * distance);
    var greaterLon = location.longitude + (lon * distance);
    lesserGeopoint = GeoPoint(lowerLat, lowerLon);
    greaterGeopoint = GeoPoint(greaterLat, greaterLon);
  }

  //show request count in card
  getRequestsCount() async{

    await FirebaseFirestore.instance.collection("Blood Request Details").get().
    then((value) => this.setState(() {
      totalCount=value.size;}));

    await FirebaseFirestore.instance.collection("Blood Request Details")
        .where('donorUid', isNotEqualTo:'').get().
    then((value) => this.setState(() {
      donatedCount=value.size;}));

    await FirebaseFirestore.instance.collection("Blood Request Details")
        .where('permission',isEqualTo:true)
        .where('donorUid', isEqualTo:'').get().
    then((value) => this.setState(() {
      availableCount=value.size;}));

    setState(() {
      donatedPercentage= (donatedCount*100/totalCount).floor();
      activePercentage= (availableCount*100/totalCount).floor();
    });


    // print( 'donatedCount $donatedCount totalCount $totalCount');
  }

  @override
  Widget build(BuildContext context) {
    bannerHeight = MediaQuery.of(context).size.height * .25;
    listHeight = MediaQuery.of(context).size.height * .75;
    cardContainerHeight = 200;
    cardContainerTopPadding = bannerHeight / 2;
    listPaddingTop = cardContainerHeight - (bannerHeight / 2);
    return Scaffold(
      // https://flutter.io/docs/development/ui/layout#stack
      body: Stack(
        children: <Widget>[
          new Column(
            children: <Widget>[
              //searchButton(context),
              topBanner(context),
              Expanded(child: bodyBloodRequestList(context))
            ],
          ),
          bannerContainer(),
          cardContainer(context),
        ],
      ),
    );
  }

  //search button leading to new page
  //where one can search the requests
  Widget searchButton(BuildContext context)
  {

    IconButton(icon: Icon(Icons.search),color:kMainRed,
        onPressed:() async{
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => SearchRequest(),
          ));
        }         );
  }

  Container bodyBloodRequestList(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.grey.shade300,
      padding:
      new EdgeInsets.only(top: listPaddingTop, right: 10.0, left: 10.0),
      child: Column(
        children: <Widget>[
          //searchButton(context),
          getScrollView(),
          rowRecentUpdates(),
          Expanded(child: requestLazy(context))
        ],
      ),
    );
  }


  Widget requestLazy(BuildContext context){
    return  listDocument.length != 0
        ? RefreshIndicator(
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        controller: scrollController,
        itemCount: listDocument.length+1,
        itemBuilder: (context, index) {
          if(index==listDocument.length)
            return Center(
              child: SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator()),
            );
          return RequestItem(listDocument[index], context);
        },
      ),
      onRefresh: getDocuments,
    )// Refresh entire list
        : Center(child:CircularProgressIndicator() ,);
  }


  //code for presenting all requests in from of list
  Widget requests(BuildContext context) {
    return StreamBuilder(

      /*stream: FirebaseFirestore.instance
          .collection("Blood Request Details").where('patientCondition',whereIn: requestConditonList)
          .where('active',isEqualTo:true)
          .orderBy('dueDate').snapshots(),*/
      stream: getQuery().snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {

          return Center(child: CircularProgressIndicator());
        }



        return ListView.builder(

          padding: EdgeInsets.all(10),
          //reverse: true,


          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {

            return RequestItem(snapshot.data.docs[index], context );
          },
        );
      },
    );
  }


  //each request item to be shown here
  Widget RequestItem(DocumentSnapshot snapshot, BuildContext context){
    String name="";
    RequestModel _req = RequestModel.fromMap(snapshot.data());
    // return StreamBuilder(
    //   stream: FirebaseFirestore.instance.collection('User Details').doc(_req.raiserUid).snapshots(),
    //   builder: (context, snapshot) {
    //     if (!snapshot.hasData)
    //       return Padding(
    //           padding: EdgeInsets.only(top: 50),
    //           child: Row(
    //             children: <Widget>[
    //               CircularProgressIndicator(
    //                 valueColor:
    //                 new AlwaysStoppedAnimation<Color>(
    //                     kMainRed),
    //               ),
    //               SizedBox(
    //                 width: 15,
    //               ),
    //               Text('Loading Requests...')
    //             ],
    //           ));
    //     try {
    //       name = snapshot.data['Name'];
    //     }catch(e){
    //       name= 'Loading';
    //     }
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // setState(() {
            //
            // });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 10.0, horizontal: 5),
            child: Container(
              height: 160,
              width: MediaQuery
                  .of(context)
                  .size
                  .width ,
              decoration: BoxDecoration(
                  color: kBackgroundColor,
                  borderRadius:
                  BorderRadius.circular(15),
                  border: Border.all(
                      color: kMainRed,
                      width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    )
                  ]),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 55,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .center,
                      mainAxisAlignment: MainAxisAlignment
                          .center,
                      children: <Widget>[
                        Icon(Icons.bloodtype_sharp,color: kMainRed,),
                        Text(
                          _req.bloodGroup,
                          style: TextStyle(
                              fontSize: 22,
                              color: kMainRed,
                              fontWeight:
                              FontWeight.bold,
                              fontFamily:
                              'nunito'),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.only(
                              left: 5),
                          child: Text(
                            'Type',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontFamily:
                                'nunito'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                      height: 40,
                      child: VerticalDivider(
                        color: Colors.black,
                        thickness: 1,
                      )),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(child:
                  Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: <Widget>[

                      SizedBox(height: 8),
                      //                                     SizedBox(height: 12,),

                      Row(
                          children : <Widget>[
                            Icon(FontAwesomeIcons.hospitalUser,color: kMainRed,size: 12,),
                            SizedBox(width: 3,),
                            Text(
                              'Name: ${_req.patientName}',
                              style: TextStyle(
                                  fontSize: 12.5,
                                  fontFamily: 'nunito',
                                  color: Colors.black),
                            ),
                          ]

                      ),
                      SizedBox(height: 5,),
                      Row(
                          children : <Widget>[
                            Icon(FontAwesomeIcons.prescriptionBottle,color: kMainRed,size: 12,),
                            SizedBox(width: 3,),
                            Text(
                              'Quantity:  ${_req
                                  .qty
                                  .toString()} L',
                              style: TextStyle(
                                  fontSize: 12.5,
                                  fontFamily: 'nunito',
                                  color: Colors.black),
                            ),
                          ]
                      ),
                      SizedBox(height: 5,),
                      Row(
                          children : <Widget>[
                            Icon(FontAwesomeIcons.clock,color: kMainRed,size: 12,),
                            SizedBox(width: 3,),
                            Text(
                              'Due Date: ${_req.dueDate
                                  .toString()}',
                              style: TextStyle(
                                  fontSize: 12.5,
                                  fontFamily: 'nunito',
                                  color: kMainRed),
                            ),
                          ]
                      ),
                      Expanded(child:
                      Row(
                          children : <Widget>[
                            Icon(FontAwesomeIcons.mapMarkedAlt,color: kMainRed, size: 12),
                            SizedBox(width:3,),
                            Expanded(child:
                            Text(
                              '${_req.address}',
                              overflow: TextOverflow.ellipsis,
                              // maxLines: 2,
                              //softWrap: false,
                              style: TextStyle(
                                  fontSize: 12.5,
                                  fontFamily: 'nunito',
                                  color: Colors.black),

                            ),
                            ),
                          ]
                      ),
                      ),

                      Row(
                          children:<Widget> [
                            Icon(FontAwesomeIcons.ambulance,color: kMainRed,size: 15,),
                            SizedBox(width: 5),
                            Text('${_req.condition
                                .toString()}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  fontFamily: 'nunito',
                                  color: kMainRed),


                            ),
                          ]
                      ),



                      Row(
                        children:[
                          SizedBox(width:175),
                          IconButton(onPressed: (){
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => SingleRequestScreen(request: _req),
                            ));
                          }, icon:
                          Icon(Icons.east_outlined,color: kMainRed,)),],
                      ),


                    ],
                  ),
                  ),

                ],
              ),


            ),
          ),
        ),

      ],
    );
    // }

    // );
  }

  //would show emergency conditions
  //view all feature added
  Row rowRecentUpdates() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      verticalDirection: VerticalDirection.down,
      children: <Widget>[
        InkWell(
          onTap: (){
            requestConditonList=["critical"];
          },
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text("Emergencies",
                style: TextStyle(color: kMainRed, fontSize: 17.0)),

          ),
        ),
        InkWell(
          onTap: (){
            requestConditonList=["critical","normal"];
          },
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text("View All",
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0)),
          ),
        )
      ],
    );
  }

  Container topBanner(BuildContext context) {
    return Container(
        height: bannerHeight,
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          color: kMainRed,
        )
    );
  }


  //added a banner on top of page
  //again ui ui ui......
  Container bannerContainer() {
    return
      Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: 50.0, right: 10.0, left: 20.0),
          child: Row(
              children:[
                SizedBox(width: 70,),
                Text(
                  "Blood Requests",
                  style: TextStyle(
                      color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(width:40),
                IconButton(icon: Icon(Icons.search),color:Colors.white,
                    onPressed:() async{
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => SearchRequest(),
                      ));
                    }         )
              ]
          ));


  }


  //conatiner for ui enhancement
  Container cardContainer(BuildContext context) {
    return Container(
        alignment: Alignment.topCenter,
        padding: new EdgeInsets.only(
            top: cardContainerTopPadding, right: 20.0, left: 20.0),
        child: Container(
          height: cardContainerHeight,
          width: MediaQuery.of(context).size.width,
          child: Container(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: (donatedPercentage!=null && activePercentage!=null)?Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  PercentageWidget(
                    size: 120.0,
                    title: 'Available',
                    count: donatedCount,
                    //==null? 0:donatedCount,
                    percentage: activePercentage,
                    //==null?0:activePercentage,
                    countLeft: true,
                  ),
                  PercentageWidget(
                    size: 120.0,
                    title: 'Requests',
                    count: totalCount,
                    //==null?0:totalCount,
                    percentage: donatedPercentage,
                    //==null?0:donatedPercentage,
                    countLeft: false,
                  ),
                  SizedBox(
                    height: 60.0,
                  )
                ],
              ):Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CircularProgressIndicator()
                ],
              ),
            ),
          ),
        )
    );
  }


  //scroll view added for sorting the requests on basis of blood grps
  Widget getScrollView(){
    return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(8),
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceEvenly,
          children: [
            ChoiceChip(
              selectedColor:
              kMainRed,
              //Theme.of(context).accentColor,
              elevation: 10,
              onSelected: (value) {
                setState(() {
                  selectedSort = 0;
                  getDocuments();
                });
              },
              label: Text('All',
                  style: TextStyle(
                      color: kDarkerGrey)),
              selected: selectedSort == 0,
            ),
            SizedBox(width: 5),
            ChoiceChip(
              selectedColor:
              kMainRed,
              //Theme.of(context).accentColor,
              elevation: 10,
              onSelected: (value) {
                setState(() {
                  selectedSort = 9;
                  getDocuments();
                });
              },
              label: Text('Nearby',
                  style: TextStyle(
                      color: kDarkerGrey)),
              selected: selectedSort == 9,
            ),
            SizedBox(width: 5),
            ChoiceChip(
              selectedColor:
              kMainRed,
              //Theme.of(context).accentColor,
              elevation: 10,
              onSelected: (value) {
                setState(() {
                  selectedSort = 1;
                  getDocuments();
                });
              },
              label: Text('A+',
                  style: TextStyle(
                    color:kDarkerGrey,)),
              selected: selectedSort == 1,
            ),

            SizedBox(width: 5),
            ChoiceChip(
              selectedColor:
              kMainRed,
              elevation: 10,
              onSelected: (value) {
                setState(() {
                  selectedSort = 2;
                  getDocuments();
                });
              },
              label: Text('A-',
                  style: TextStyle(
                      color: kDarkerGrey)),
              selected: selectedSort == 2,
            ),
            SizedBox(width: 5),
            ChoiceChip(
              selectedColor:
              kMainRed,
              elevation: 10,
              onSelected: (value) {
                setState(() {
                  selectedSort = 3;
                  getDocuments();
                });
              },
              label: Text('B+',
                  style: TextStyle(
                      color:kDarkerGrey)),
              selected: selectedSort == 3,
            ),
            SizedBox(width: 5),
            ChoiceChip(
              selectedColor:
              kMainRed,
              elevation: 10,
              onSelected: (value) {
                setState(() {
                  selectedSort = 4;
                  getDocuments();
                });
              },
              label: Text('B-',
                  style: TextStyle(
                      color:kDarkerGrey)),
              selected: selectedSort == 4,
            ),
            SizedBox(width: 5),
            ChoiceChip(
              selectedColor:
              kMainRed,
              elevation: 10,
              onSelected: (value) {
                setState(() {
                  selectedSort = 5;
                  getDocuments();
                });
              },
              label: Text('AB+',
                  style: TextStyle(
                      color:kDarkerGrey)),
              selected: selectedSort == 5,
            ),SizedBox(width: 5),
            ChoiceChip(
              selectedColor:
              kMainRed,
              elevation: 10,
              onSelected: (value) {
                setState(() {
                  selectedSort = 6;
                  getDocuments();
                });
              },
              label: Text('AB-',
                  style: TextStyle(
                      color:kDarkerGrey)),
              selected: selectedSort == 6,
            ),SizedBox(width: 5),
            ChoiceChip(
              selectedColor:
              kMainRed,
              elevation: 10,
              onSelected: (value) {
                setState(() {
                  selectedSort = 7;
                  getDocuments();
                });
              },
              label: Text('O+',
                  style: TextStyle(
                      color:kDarkerGrey)),
              selected: selectedSort == 7,
            ),SizedBox(width: 5),
            ChoiceChip(
              selectedColor:
              kMainRed,
              elevation: 10,
              onSelected: (value) {
                setState(() {
                  selectedSort = 8;
                  getDocuments();
                });
              },
              label: Text('O-',
                  style: TextStyle(
                      color:kDarkerGrey)),
              selected: selectedSort == 8,
            ),
          ],
        ));
  }

  List<DocumentSnapshot> listDocument;
  QuerySnapshot collectionState;
  // Fetch first 15 documents
  Future<void> getDocuments() async {

    listDocument = List();
    var collection = getQuery().limit(5);
    // print('getDocuments');
    fetchDocuments(collection);


  }

  // Fetch next 5 documents starting from the last document fetched earlier
  Future<void> getDocumentsNext() async {
    // Get the last visible document
    var lastVisible = collectionState.docs[collectionState.docs.length-1];
    // print('listDocument legnth: ${collectionState.size} last: $lastVisible');

    var collection = getQuery().startAfterDocument(lastVisible).limit(2);

    fetchDocuments(collection);
  }

  fetchDocuments(Query collection){

    collection.get().then((value) {
      collectionState = value; // store collection state to set where to start next
      value.docs.forEach((element) {
        // print('getDocuments ${element.data()}');
        setState(() {
          listDocument.add(element);
        });
      });
    });


  }

  //get queries according to blood Group selected..
  /*
      0->all
      1->A+
      2->A-
      3->B+
      4->B-
      5->AB+
      6->AB-
      7->O+
      8->o-
  */
  //.where('bloodGroup',isEqualTo: "A+")

  Query getQuery() {
    switch (selectedSort) {
      case 0:
        return  FirebaseFirestore.instance
            .collection("Blood Request Details").where('patientCondition',whereIn: requestConditonList)
            .where('active',isEqualTo:true)
            .where('permission', isEqualTo: true)
            .orderBy('dueDate');
        break;
      case 1:
        return FirebaseFirestore.instance
            .collection("Blood Request Details").where('patientCondition',whereIn: requestConditonList)
            .where('active',isEqualTo:true)
            .where('permission', isEqualTo: true)
            .where('bloodGroup',isEqualTo: "A+")
            .orderBy('dueDate');
        break;
      case 2:
        return FirebaseFirestore.instance
            .collection("Blood Request Details").where('patientCondition',whereIn: requestConditonList)
            .where('active',isEqualTo:true)
            .where('permission', isEqualTo: true)
            .where('bloodGroup',isEqualTo: "A-")
            .orderBy('dueDate');
        break;
      case 3:
        return FirebaseFirestore.instance
            .collection("Blood Request Details").where('patientCondition',whereIn: requestConditonList)
            .where('active',isEqualTo:true)
            .where('permission', isEqualTo: true)
            .where('bloodGroup',isEqualTo: "B+")
            .orderBy('dueDate');
        break;
      case 4:
        return FirebaseFirestore.instance
            .collection("Blood Request Details").where('patientCondition',whereIn: requestConditonList)
            .where('active',isEqualTo:true)
            .where('permission', isEqualTo: true)
            .where('bloodGroup',isEqualTo: "B-")
            .orderBy('dueDate');
        break;
      case 5:
        return FirebaseFirestore.instance
            .collection("Blood Request Details").where('patientCondition',whereIn: requestConditonList)
            .where('active',isEqualTo:true)
            .where('permission', isEqualTo: true)
            .where('bloodGroup',isEqualTo: "AB+")
            .orderBy('dueDate');
        break;
      case 6:
        return FirebaseFirestore.instance
            .collection("Blood Request Details").where('patientCondition',whereIn: requestConditonList)
            .where('active',isEqualTo:true)
            .where('permission', isEqualTo: true)
            .where('bloodGroup',isEqualTo: "AB-")
            .orderBy('dueDate');
        break;
      case 7:
        return FirebaseFirestore.instance
            .collection("Blood Request Details").where('patientCondition',whereIn: requestConditonList)
            .where('active',isEqualTo:true)
            .where('permission', isEqualTo: true)
            .where('bloodGroup',isEqualTo: "O+")
            .orderBy('dueDate');
        break;
      case 8:
        return FirebaseFirestore.instance
            .collection("Blood Request Details").where('patientCondition',whereIn: requestConditonList)
            .where('active',isEqualTo:true)
            .where('permission', isEqualTo: true)
            .where('bloodGroup',isEqualTo: "O-")
            .orderBy('dueDate');
        break;
      case 9:
        getGeoPoint();
        return FirebaseFirestore.instance
            .collection("Blood Request Details").where('patientCondition',whereIn: requestConditonList)
            .where('active',isEqualTo:true)
            .where('permission', isEqualTo: true)
            .where('location',isGreaterThan:lesserGeopoint)
            .where('location', isLessThan:greaterGeopoint);
        //.orderBy('dueDate');
        break;

    }
    debugPrint('Unexpected sorting selected');
    return null;
  }



}











