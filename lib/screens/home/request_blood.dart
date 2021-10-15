import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../../Colors.dart';
import 'Home_screen.dart';

class RequestBlood extends StatefulWidget {
  double _lat, _lng;
  RequestBlood(this._lat, this._lng);
  @override
  _RequestBloodState createState() => _RequestBloodState();
}

class _RequestBloodState extends State<RequestBlood> {
  final formkey = new GlobalKey<FormState>();
  List<String> _bloodGroup = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  List<String> _condition=['critical', 'normal'];
  String _selected = '';
  String _qty;
  String _phone;
  String _address;
  String _patientCondition;
  String _userID;
  bool _categorySelected = false;
  DateTime selectedDate = DateTime.now();
  var formattedDate;
  int flag = 0;
  User currentUser;
  List<Placemark> placemark;
  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    getAddress();
  }

  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> addData(_user) async {
    if (isLoggedIn()) {
      FirebaseFirestore.instance
          .collection('Blood Request Details')
          .doc(_user['uid'])
          .set(_user)
          .catchError((e) {
        print(e);
      });
    } else {
      print('You need to be logged In');
    }
  }

  Future<void> _loadCurrentUser() async {
    User currentUser;
    currentUser = await FirebaseAuth.instance.currentUser;
    setState(() {
      currentUser =currentUser;
      _userID= currentUser.uid;
    });

  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: selectedDate,
        lastDate: DateTime(2022));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        flag = 1;
      });
    var date = DateTime.parse(selectedDate.toString());
    formattedDate = "${date.day}-${date.month}-${date.year}";
  }

  Future<bool> dialogTrigger(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'.tr),
            content: Text('Blood Request Submitted'.tr),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  formkey.currentState.reset();
                  Navigator.pop(context);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
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

  void getAddress() async {
    placemark =
    await Geolocator().placemarkFromCoordinates(widget._lat, widget._lng);
    _address = placemark[0].name.toString() +
        "," +
        placemark[0].locality.toString() +
        ", Postal Code:" +
        placemark[0].postalCode.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainRed,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          "Request Blood".tr,
          style: TextStyle(
            fontSize: 20.0,
            fontFamily: "SouthernAire",
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            FontAwesomeIcons.reply,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ClipRRect(
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
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top: 20.0),
                              child: DropdownButton(
                                hint: Text(
                                  'Please choose a Blood Group'.tr,
                                  style: TextStyle(
                                    color: kMainRed,
                                  ),
                                ),
                                iconSize: 40.0,
                                items: _bloodGroup.map((val) {
                                  return new DropdownMenuItem<String>(
                                    value: val,
                                    child: new Text(val),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selected = newValue;
                                    this._categorySelected = true;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              _selected,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: kMainRed,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Quantity(L)'.tr,
                            icon: Icon(
                              FontAwesomeIcons.prescriptionBottle,
                              color: kMainRed,
                            ),
                          ),
                          validator: (value) => value.isEmpty
                              ? "Quantity field can't be empty".tr
                              : null,
                          onSaved: (value) => _qty = value,
                          keyboardType: TextInputType.number,
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
                        padding: const EdgeInsets.all(18.0),
                        child: DropDownField(
                          controller: TextEditingController(),
                          itemsVisibleInDropdown: 2,
                          icon: Icon(FontAwesomeIcons.hospitalUser,color: kMainRed,),
                          hintText: "Patient Condition".tr,
                          hintStyle: TextStyle(color: Colors.black54, fontSize: 15.0),
                          enabled: true,
                          items:_condition,
                          onValueChanged: (value){
                            _patientCondition=value;

                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Phone Number'.tr,
                            icon: Icon(
                              FontAwesomeIcons.mobile,
                              color: kMainRed,
                            ),
                          ),
                          validator: (value) => value.isEmpty
                              ? "Phone Number field can't be empty".tr
                              : null,
                          onSaved: (value) => _phone = value,
                          maxLength: 10,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              onPressed: null,
                              icon: Icon(FontAwesomeIcons.paperclip),
                              color: kMainRed,
                            ),
                            Text(
                              "<< Add a valid medical report".tr,
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 15.0),
                            )
                            
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      RaisedButton(
                        onPressed: () {
                          if (!formkey.currentState.validate()) return;
                          formkey.currentState.save();
                          final Map<String, dynamic> BloodRequestDetails = {
                            'uid': _userID,
                            'bloodGroup': _selected,
                            'quantity': _qty,
                            'dueDate': formattedDate,
                            'phone': _phone,
                            'location': new GeoPoint(widget._lat, widget._lng),
                            'address': _address,
                            'patientCondition': _patientCondition
                          };
                          addData(BloodRequestDetails).then((result) {
                            dialogTrigger(context);
                          }).catchError((e) {
                            print(e);
                          });
                        },
                        textColor: Colors.white,
                        padding: EdgeInsets.only(left: 5.0, right: 5.0),
                        color: kMainRed,
                        child: Text("SUBMIT".tr),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}