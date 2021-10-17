/*this is request model*/

//import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:raktkhoj/user_oriented_pages/profile.dart';

class RequestModel{
    String raiserUid;
    String qty;
    String phone;
    String condition;
    String dueDate;
    GeoPoint location;
    String bloodGroup;
    String address;

    RequestModel({
        this.raiserUid, this.qty, this.phone, this.condition,
        this.dueDate, this.location, this.bloodGroup, this.address
    });


    Map<String,dynamic> toMap(RequestModel requset) {
        var data = Map<String, dynamic>();
        data['uid'] = requset.raiserUid;
        data['quantity'] = requset.qty;
        data['phone'] = requset.phone;
        data['patientCondition'] = requset.condition;
        data['dueDate'] = requset.dueDate;
        data['location'] = requset.location;
        data['bloodGroup'] = requset.bloodGroup;
        data['address'] = requset.address;
        return data;
    }

    RequestModel.fromMap(Map<String, dynamic> data){
        this.raiserUid=data['uid'];
        this.qty=data['quantity'] ;
        this.phone=data['phone'];
         this.condition=data['patientCondition'];
        this.dueDate=data['dueDate'] ;
        this.location=data['location'];
        this.bloodGroup=data['bloodGroup'];
        this.address=data['address'];
    }
}