/*this is request model*/

//import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
class RequestModel{
    String reqid;
    String patientName;
    String raiserUid;
    String donorUid;
    String qty;
    String phone;
    String condition;
    String dueDate;
    GeoPoint location;
    String bloodGroup;
    String address;
    bool permission;
    bool active;
    String docURL;


    RequestModel({
        this.raiserUid, this.qty, this.phone, this.condition,this.patientName,
        this.dueDate, this.location, this.bloodGroup, this.address, this.active, this.permission, this.donorUid, this.reqid, this.docURL,
    });


    Map<String,dynamic> toMap(RequestModel requset) {
        var data = Map<String, dynamic>();
        data['patientName'] = requset.patientName;
        data['raiserUid'] = requset.raiserUid;
        data['quantity'] = requset.qty;
        data['phone'] = requset.phone;
        data['patientCondition'] = requset.condition;
        data['dueDate'] = requset.dueDate;
        data['location'] = requset.location;
        data['bloodGroup'] = requset.bloodGroup;
        data['address'] = requset.address;
        data['permission']=requset.permission;
        data['active']=requset.active;
        data['reqid']=requset.reqid;
        data['donorUid']= requset.donorUid;
        data['docURL']=requset.docURL;
        return data;
    }

    RequestModel.fromMap(Map<String, dynamic> data){
        this.patientName=data['patientName'];
        this.raiserUid=data['raiserUid'];
        this.qty=data['quantity'] ;
        this.phone=data['phone'];
         this.condition=data['patientCondition'];
        this.dueDate=data['dueDate'] ;
        this.location=data['location'];
        this.bloodGroup=data['bloodGroup'];
        this.address=data['address'];
        this.reqid= data['reqid'];
        this.permission=data['permission'];
        this.active=data['active'];
        this.donorUid=data['donorUid'];
        this.docURL= data['docURL'];
    }

    RequestModel copyWith({String reqid, String patientName, String raiserUid, String donorUid,
    String qty, String phone, String condition, String dueDate, GeoPoint location,
    String bloodGroup, String address, bool permission, bool active, String docURL}){
        return new RequestModel(
            reqid: reqid??this.reqid,
            patientName: patientName??this.patientName,
            raiserUid: raiserUid ?? this.raiserUid,
            qty: qty??this.qty,
            phone: phone??this.phone,
            condition: condition??this.condition,
            dueDate: dueDate??this.dueDate,
            location: location??this.location,
            bloodGroup: bloodGroup??this.bloodGroup,
            address: address??this.address,
            permission: permission??this.permission,
            active: active??this.active,
            donorUid: donorUid??this.donorUid,
            docURL: docURL??this.docURL
        );
    }
}