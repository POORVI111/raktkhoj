import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:raktkhoj/components/image_upload_provider.dart';
import 'package:raktkhoj/provider/storage_method.dart';
import 'package:raktkhoj/screens/additional/additional.dart';
import 'package:raktkhoj/screens/page_guide.dart';
import 'package:raktkhoj/user_oriented_pages/profile.dart';

import '../../colors.dart';

class AddEvents extends StatefulWidget {


  @override
  _AddEventsState createState() => _AddEventsState();
}

class _AddEventsState extends State<AddEvents>
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

  final formkey = new GlobalKey<FormState>();

  String _docURL;
  String _degree;
  String _name;
  String _time;
  String _imageUrl;
  String _description;

  String _userID;

  String _tokenid;
  String _adminEmail;

  var formattedDate;
  ImageUploadProvider _imageUploadProvider;
  final StorageMethods _storageMethods = StorageMethods();
  DateTime selectedDate = DateTime.now();

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
    FirebaseFirestore.instance.collection('User Details').doc(currentUser.uid).get().then((value) {
      userName = value.data()['Name'];
    });
    //getAdminId();
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

  //selecting(changing dob)
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1975),
      lastDate: DateTime(2022),);
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        flag = 1;
      });
    var date = DateTime.parse(selectedDate.toString());
    formattedDate = "${date.day}-${date.month}-${date.year}";
    //changing to database
    final firestoreInstance =  FirebaseFirestore.instance;

    /*var firebaseUser =  FirebaseAuth.instance.currentUser;
    firestoreInstance.collection("User Details").doc(firebaseUser.uid).
    update({"Dob":formattedDate});*/

  }

  //image picking in order to change cover image of event
  static Future<PickedFile> _pickImage({@required ImageSource source}) async {
    final _picker = ImagePicker();
    PickedFile selectedImage = await _picker.getImage(source: source);
    return selectedImage;
  }

  //uploading image to firebase
  void UploadImage({@required ImageSource source}) async {
    PickedFile selectedImage = await _pickImage(source: source);
    final firestoreInstance =  FirebaseFirestore.instance;
    var firebaseUser =  FirebaseAuth.instance.currentUser;
    _imageUrl=await _storageMethods.uploadEventImage(
       image: File(selectedImage.path),
        //userId: firebaseUser.uid,
        imageUploadProvider: _imageUploadProvider);

    // Set some loading value to db and show it to user
    //_imageUploadProvider.setToLoading();

    // Get url from the image bucket
    //String url = await _storageMethods.uploadImageToStorage(File(selectedImage.path));

    // Hide loading
    //_imageUploadProvider.setToIdle();

    //_imageUrl=url;
    print(_imageUrl);

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
            content: Text('You have successfully scheduled an event'.tr),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  formkey.currentState.reset();
                  Navigator.pop(context);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => PageGuide()));
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
    final double tempHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).size.width / 1.2) +
        15.0;
    //return Container();



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
                                                  'To schedule an event with Raktkhoj, '
                                                      'inorder to help others.',
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
                                                    hintText: 'Name of event'.tr,
                                                    icon: Icon(
                                                      FontAwesomeIcons.hospitalUser,
                                                      color: kMainRed,
                                                    ),
                                                  ),
                                                  validator: (value) => value.isEmpty
                                                      ? "this field can't be empty".tr
                                                      : null,
                                                  onSaved: (value) => _name = value,
                                                ),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: <Widget>[
                                                    IconButton(
                                                      onPressed: () => _selectDate(context),
                                                      icon: Icon(FontAwesomeIcons.calendar),
                                                      color: kMainRed,
                                                    ),
                                                    flag == 0
                                                        ? Text(
                                                      "<< Pick up a Due Date".tr,
                                                      style: TextStyle(
                                                          color: Colors.black54, fontSize: 15.0),
                                                    )
                                                        : Text(formattedDate),
                                                  ],
                                                ),
                                              ),



                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: TextFormField(
                                                  decoration: InputDecoration(
                                                    hintText: 'Starting time'.tr,
                                                    icon: Icon(
                                                      FontAwesomeIcons.mobile,
                                                      color: kMainRed,
                                                    ),
                                                  ),
                                                  validator: (value) => (value.isEmpty)
                                                      ? "please provide timings of event".tr
                                                      : null,
                                                  onSaved: (value) => _time = value,
                                                  // Only numbers can be entered
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

                                          var time = DateTime.now().millisecondsSinceEpoch;
                                          String key = time.toString();




                                            FirebaseFirestore.instance.collection(
                                                "Event Details").doc(key).
                                                set({'eventid': key,
                                              'Name':_name,
                                              'date':formattedDate,
                                              'time':_time,
                                                'organiserUid':currentUser.uid,
                                                'imageUrl':_imageUrl}).then((result) async {

                                              dialogTrigger(context);
                                            }).catchError((e) {
                                              print(e);
                                            });



                                        },
                                        child: Center(
                                          child: Text(
                                            "Add event",
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
                    width: 70,
                    height: 70,
                    child: Center(
                      child: RoundIconButton(icon: FontAwesomeIcons.camera, onPressed: (){
                        //EDIT PROFILE
                        //displayOverlay(context);
                        UploadImage(source: ImageSource.gallery);

                      }),
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
