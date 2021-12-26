/*
model for events scheduled
 */
import 'dart:core';



class EventModel{
  String eventid;
  String Name;
  String organiserUid;
  String time;
  String imageUrl;
  String date;

  EventModel( {
    this.eventid, this.Name, this.organiserUid, this.time,
    this.imageUrl, this.date});

  Map<String,dynamic> toMap(EventModel event) {
    var data = Map<String, dynamic>();
    data['eventid'] = event.eventid;
    data['Name'] = event.Name;
    data['organiserUid'] = event.organiserUid;
    data['time'] = event.time;
    data['imageUrl'] = event.imageUrl;
    data['date'] = event.date;

    return data;
  }

  EventModel.fromMap(Map<String, dynamic> data){
    this.eventid=data['eventid'];
    this.organiserUid=data['organiserUid'];
    this.Name=data['Name'] ;
    this.time=data['time'];
    this.imageUrl=data['imageUrl'];
    this.date=data['date'] ;

  }
}