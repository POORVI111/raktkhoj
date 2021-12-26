import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../../colors.dart';
import 'find_nearby_hospitals.dart';

class NearbyHospitalPage extends StatefulWidget {
  @override
  _NearbyHospitalPageState createState() => _NearbyHospitalPageState();
}
//screen to display nearby hospitals
class _NearbyHospitalPageState extends State<NearbyHospitalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainRed,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          'Nearby Hospitals'.tr,
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
          child: FindNearbyHospitals(),
        ),
      ),
    );
  }
}
