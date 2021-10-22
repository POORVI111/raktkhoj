import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:raktkhoj/model/request.dart';
import 'package:raktkhoj/screens/donate_here/single_request_screen.dart';

import '../../Colors.dart';

class SearchRequest extends StatefulWidget {
  const SearchRequest({Key key}) : super(key: key);

  @override
  _SearchRequestState createState() => _SearchRequestState();
}

class _SearchRequestState extends State<SearchRequest> {

  double bannerHeight, listHeight, listPaddingTop;
  double cardContainerHeight, cardContainerTopPadding;

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;



  Future<User> getCurrentUser() async {
    User currentUser;
    currentUser = await _auth.currentUser;
    return currentUser;
  }

  Future<List<RequestModel>> fetchAllRequests(User currentUser) async {
    List<RequestModel> reqList = <RequestModel>[];

    QuerySnapshot querySnapshot =
    await _firestore.collection("Blood Request Details").get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != currentUser.uid) {
        reqList.add(RequestModel.fromMap(querySnapshot.docs[i].data()));
      }
    }
    return reqList;
  }

  List<RequestModel> reqList;
  String query = "";
  TextEditingController searchController = TextEditingController();

  void initState() {
    super.initState();

    getCurrentUser().then((User user) {
      fetchAllRequests(user).then((List<RequestModel> list) {
        setState(() {
          reqList = list;
        });
      });
    });
  }

  searchAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: kMainRed,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(FontAwesomeIcons.reply, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      elevation: 0,
      title: Text("Search", style: TextStyle(color: Colors.white),),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: TextField(
            controller: searchController,
            onChanged: (val) {
              setState(() {
                query = val;
              });
            },
            cursorColor: Colors.black,
            autofocus: true,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 20,
            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.close, color: Colors.black),
                onPressed: () {
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => searchController.clear());
                  query="";
                },
              ),
              border: InputBorder.none,
              hintText: "Type here to search",
              hintStyle: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  //returns list view of queried users
  searchRequestList(String query) {
    final List<RequestModel> suggestionList = query.isEmpty
        ? (reqList!=null? reqList:[])
        : reqList != null?
    reqList.where((RequestModel _req) {
      if (query != null || _req.address != null || _req.active == true) {
        String _getAddressname = _req.address.toLowerCase();
        String _query = query.toLowerCase();
        String _getName=  _req.patientName.toLowerCase();
      //   String _getName = "";
      //   FirebaseFirestore.instance.collection("User Details").doc(_req.raiserUid).get().then((value){
      //     _getName=value.data()["Name"];
      // });
      //   _getName=_getName.toLowerCase();

        bool matchesUsername = _getAddressname.contains(_query);
        bool matchesName = _getName.contains(_query);

        return (matchesUsername || matchesName);
      } else { return false; }

    }).toList()
        : [];

    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.grey.shade300,
      padding:
      new EdgeInsets.only(right: 5.0, left: 5.0),
      child: Column(
        children: <Widget>[
          //getScrollView(),
          //rowRecentUpdates(),
          Expanded(child: requests(context , suggestionList))
        ],
      ),
    );
  }


  //requests widget
  Widget requests(BuildContext context , List<RequestModel> suggestionList) {

    return ListView.builder(

      padding: EdgeInsets.all(10),
      //reverse: true,


      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        String name="";
        RequestModel _req= RequestModel(
            patientName: suggestionList[index].patientName,
            raiserUid:suggestionList[index].raiserUid,
            qty:suggestionList[index].qty,
            phone:suggestionList[index].phone,
            condition:suggestionList[index].condition,
            dueDate:suggestionList[index].dueDate,
            location:suggestionList[index].location,
            bloodGroup:suggestionList[index].bloodGroup,
            address:suggestionList[index].address,
            reqid:suggestionList[index].reqid,
            permission:suggestionList[index].permission,
            active:suggestionList[index].active,
            donorUid:suggestionList[index].donorUid
        );

        // return StreamBuilder(
        //     stream: FirebaseFirestore.instance.collection('User Details').doc(_req.raiserUid).snapshots(),
        //     builder: (context, snapshot) {
        //       if (!snapshot.hasData)
        //         return Padding(
        //             padding: EdgeInsets.only(top: 50),
        //             child: Row(
        //               children: <Widget>[
        //                 CircularProgressIndicator(
        //                   valueColor:
        //                   new AlwaysStoppedAnimation<Color>(
        //                       kMainRed),
        //                 ),
        //                 SizedBox(
        //                   width: 15,
        //                 ),
        //                 Text('Loading Requests...')
        //               ],
        //             ));
        //       try {
        //         name = snapshot.data['Name'];
        //       }catch(e){
        //         name= 'Loading';
        //       }
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
                          vertical: 10.0, horizontal:2),
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
                                    SizedBox(width:158),
                                    IconButton(onPressed: (){
                                      Navigator.of(context).push(MaterialPageRoute(
                                        builder: (_) => SingleRequestScreen(request: _req),
                                      ));
                                    }, icon:
                                    Icon(Icons.east_outlined,color: kMainRed,)),],
                                ),

                                //                                      Row(
                                //                                        //mainAxisAlignment: MainAxisAlignment.end,
                                //                                        crossAxisAlignment: CrossAxisAlignment.end,
                                //                                        children: [
                                //                                          SizedBox(width: 80,),
                                //                                          Text(
                                //                                            'Status: ${lists[index]["Status"].toString()}',
                                //                                            style: TextStyle(
                                //                                              fontWeight: FontWeight.w700,
                                //                                                fontSize: 12.5,
                                //                                                fontFamily: 'nunito',
                                //                                                color: kMainRed),
                                //                                          ),
                                //                                        ],
                                //                                      ),
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
            }

        );
    //   },
    // );
  }


  //individual data ui

  @override
  Widget build(BuildContext context) {
    bannerHeight = MediaQuery.of(context).size.height * .25;
    listHeight = MediaQuery.of(context).size.height * .75;
    cardContainerHeight = 200;

    cardContainerTopPadding = bannerHeight / 2;
    listPaddingTop = cardContainerHeight - (bannerHeight / 2);
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: searchAppBar(context),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: searchRequestList(query),
      ),
    );
  }
}
