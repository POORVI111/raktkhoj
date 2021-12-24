import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel{
  String content;
  String creator;
  String title;
  int time;
  String creatorId;
  String creatorPhoto;

  PostModel({
    this.content, this.creator, this.title, this.time, this.creatorId,this.creatorPhoto
  });

  Map<String,dynamic> toMap(PostModel event) {
    var data = Map<String, dynamic>();
    data['content'] = event.content;
    data['creator'] = event.creator;
    data['creatorId'] = event.creatorId;
    data['time'] = event.time;
    data['title'] = event.title;
    data['creatorPhoto']=event.creatorPhoto;


    return data;
  }

  PostModel.fromMap(Map<String, dynamic> data){
    this.content=data['content'];
    this.creator=data['creator'];
    this.creatorId=data['creatorId'] ;
    this.time=data['time'];
    this.title=data['title'];
    this.creatorPhoto=data['creatorPhoto'];


  }

}