//import 'dart:html';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:path/path.dart';
import 'package:raktkhoj/components/cached_image.dart';
import 'package:raktkhoj/provider/storage_method.dart';
import 'package:raktkhoj/user_oriented_pages/profile.dart';

import '../../colors.dart';

import 'dart:async';

import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:raktkhoj/services/dynamic_link.dart';
import 'package:raktkhoj/services/notifications.dart';





class DoctorInfo extends StatefulWidget {

  @override
  _DoctorInfoState createState() => _DoctorInfoState();
}

class _DoctorInfoState extends State<DoctorInfo>
    with TickerProviderStateMixin{

  //variables for setting animation in image and confirmation button
  final double infoHeight = 364.0;
  AnimationController animationController;
  Animation<double> animation;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;
  String to_show="";


  String userName;
  String profilePhoto;



  final StorageMethods _storageMethods = StorageMethods();
  final formkey = new GlobalKey<FormState>();

  UploadTask task;
  File file;


  String _docURL;
  String _degree;
  String _description;

  String _userID;

  String _tokenid;
  String _adminEmail;

  int flag = 0;





  User currentUser= FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    setData();
    super.initState();
    getAdminId();
  }


  //animation controlling
  Future<void> setData() async {
    animationController?.forward();
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity1 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity2 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity3 = 1.0;
    });


  }

  // to get admin id and email for notifications
  Future <String> getAdminId() async{
    String _admin="";
    String token,adminEmail;
    await FirebaseFirestore.instance.collection('Admin').doc('AdminLogin').get().then((value) =>
    _admin=value.data()['Aid'].toString())
    ;

    await FirebaseFirestore.instance.collection('User Details').doc(_admin).get().then((value) {
      token = value.data()['tokenId'].toString();
      adminEmail = value.data()['Email'].toString();
    });
    setState(() {
      _tokenid=token;
      _adminEmail=adminEmail;
    });
    // print('$token token');
    return token;
  }

  //select file to show valid request to admin
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom,
        allowedExtensions: ['pdf'],allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path;

    setState(() => file = File(path));
  }


//upoading the file in db
  Future<String> uploadFile() async {
    if (file == null) return null;

    final fileName = basename(file.path);
    final destination = 'DoctorsVerification/$fileName';

    task = _storageMethods.uploadFile(destination, file);
    setState(() {});

    if (task == null) return null;

    final snapshot = await task.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    //print('Download-Link: $urlDownload');
    return urlDownload;
  }


  //if the submission is successful
  //showing a dialog box
//heading toward page guide
  Future<bool> dialogTrigger(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'.tr),
            content: Text('Your documents would be verified'.tr),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  formkey.currentState.reset();
                  Navigator.pop(context);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Profile()));
                },
                child: Icon(
                  Icons.arrow_forward,
                  color: kMainRed,
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {

    //setting data of button to be shown
    FirebaseFirestore.instance.collection('User Details').doc(currentUser.uid).get().then((value)
    {
      userName=value.data()['Name'];
      profilePhoto=value.data()['ProfilePhoto'];
      setState(() {
        if(value.data()['Doctor']!=true||value.data()['Doctor']==null) {
          to_show = 'Yes, Enable';
          print(to_show);
        }
        else
          to_show='Cancel';
      });

    }
    );

    final fileName = file != null ? basename(file.path) : '<< Add a valid certificate';



    final double tempHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).size.width / 1.2) +
        15.0;

    return Container(
      color: kMainRed,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1.2,
                  child: Image.asset('images/give_blood.jpg'),
                  //child: Image.asset('images/give_blood.jpg'),
                ),
              ],
            ),
            Positioned(
              top: (MediaQuery.of(context).size.width / 1.2) - 15.0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32.0),
                      topRight: Radius.circular(32.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: SingleChildScrollView(
                    child: Container(
                      constraints: BoxConstraints(
                          minHeight: infoHeight,
                          maxHeight: tempHeight > infoHeight
                              ? tempHeight
                              : infoHeight),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 32.0, left: 18, right: 16),
                            child: Text(
                              userName==null?'--':userName,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                                letterSpacing: 0.27,
                                color: Colors.black,
                              ),
                            ),
                          ),

                          Expanded(
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: opacity2,
                              child:ClipRRect(
                                borderRadius: new BorderRadius.only(
                                    topLeft: const Radius.circular(40.0),
                                    topRight: const Radius.circular(40.0)),
                                child: Container(
                                  height: 800.0,
                                  width: double.infinity,
                                  color: Colors.white,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        new Form(
                                          key: formkey,
                                          child: Column(
                                            children: <Widget>[

                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16, right: 16, top: 8, bottom: 8),
                                                child: Text(
                                                  'To join the community of doctors with Raktkhoj, '
                                                      'attach your details for verification purpose.',
                                                  textAlign: TextAlign.justify,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w200,
                                                    fontSize: 14,
                                                    letterSpacing: 0.27,
                                                    color: Colors.grey,
                                                  ),
                                                  maxLines: 15,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: TextFormField(
                                                  decoration: InputDecoration(
                                                    hintText: 'mention your education'.tr,
                                                    icon: Icon(
                                                      FontAwesomeIcons.hospitalUser,
                                                      color: kMainRed,
                                                    ),
                                                  ),
                                                  validator: (value) => value.isEmpty
                                                      ? "this field can't be empty".tr
                                                      : null,
                                                  onSaved: (value) => _degree = value,
                                                ),
                                              ),



                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: TextFormField(
                                                  decoration: InputDecoration(
                                                    hintText: 'Speciality/Description'.tr,
                                                    icon: Icon(
                                                      FontAwesomeIcons.mobile,
                                                      color: kMainRed,
                                                    ),
                                                  ),
                                                  validator: (value) => (value.isEmpty)
                                                      ? "please provide description of your medical field".tr
                                                      : null,
                                                  onSaved: (value) => _description = value,
                                                  // Only numbers can be entered
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: <Widget>[

                                                        IconButton(
                                                          onPressed: selectFile,
                                                          icon: Icon(FontAwesomeIcons.paperclip),
                                                          color: kMainRed,

                                                        ),

                                                        //used expanded scroll view to avoid overflow
                                                        Expanded(child:
                                                        SingleChildScrollView(
                                                          scrollDirection: Axis.horizontal,
                                                          child: Text(
                                                            fileName,
                                                            style: TextStyle(
                                                                color: Colors.black54, fontSize: 15.0),
                                                          ),
                                                        ),
                                                        ),
                                                      ],
                                                    ),

                                                    SizedBox(height: 20),
                                                    task != null ? buildUploadStatus(task) : Container(),
                                                  ],
                                                ),
                                              ),

                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                            ),
                          ),

                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: opacity3,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, bottom: 16, right: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[

                                  Expanded(
                                    child: Container(
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: kMainRed,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(16.0),
                                        ),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: kMainRed
                                                  .withOpacity(0.3),
                                              offset: const Offset(1.1, 1.1),
                                              blurRadius: 10.0),
                                        ],
                                      ),
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(
                                            kMainRed,
                                          ),
                                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(24),
                                          )),
                                        ),
                                        onPressed: () async {

                                          if (!formkey.currentState.validate()) return;
                                          formkey.currentState.save();
                                          _docURL = await uploadFile();

                                          // await sendNotification([_tokenid], 'A new blood request has been added.', 'New Request Requires Permission');

                                          var time = DateTime.now().millisecondsSinceEpoch;
                                          String key = time.toString();
                                          String url=await DynamicLinksService.createDynamicLink(key);


                                          print("token: $_tokenid");


                                          if(to_show =="Cancel") {
                                            FirebaseFirestore.instance.collection(
                                                "User Details").doc(currentUser.uid).
                                            update({'Doctor': false});
                                            to_show= 'Yes, Enable';
                                          }
                                          else {
                                            FirebaseFirestore.instance.collection(
                                                "User Details").doc(currentUser.uid).
                                            update({'Doctor': true,
                                              'AdminVerified':false,
                                            'Degree':_degree,
                                            'Description':_description,
                                            'DoctorVerificationReport':_docURL}).then((result) async {
                                              //sendNotification();
                                              /*send notif to admin when new request is added*/
                                              await sendNotification([_tokenid], 'Request from Doctors community','Requires Permission');
                                              await sendEmail(_adminEmail, url, 'A new doctor services enabling request has been registered. Click on the link to view and verify documents: ', 'New Doctor Request');
                                              dialogTrigger(context);
                                            }).catchError((e) {
                                              print(e);
                                            });
                                            to_show= 'Cancel';
                                          }

                                        },
                                        child: Center(
                                          child: Text(
                                            to_show,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                              letterSpacing: 0.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).padding.bottom,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: (MediaQuery.of(context).size.width / 1.2) - 24.0 - 35,
              right: 35,
              child: ScaleTransition(
                alignment: Alignment.center,
                scale: CurvedAnimation(
                    parent: animationController, curve: Curves.fastOutSlowIn),
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0)),
                  elevation: 10.0,
                  child: Container(
                    width: 100,
                    height: 100,
                    child: Center(
                      child: CachedImage(
                        profilePhoto,
                        radius: 100,
                        isRound: true,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: SizedBox(
                width: AppBar().preferredSize.height,
                height: AppBar().preferredSize.height,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius:
                    BorderRadius.circular(AppBar().preferredSize.height),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //to show percentage doc uploaded
  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
    stream: task.snapshotEvents,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final snap = snapshot.data;
        final progress = snap.bytesTransferred / snap.totalBytes;
        final percentage = (progress * 100).toStringAsFixed(2);

        return Text(
          '$percentage %',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        );
      } else {
        return Container();
      }
    },
  );
}
