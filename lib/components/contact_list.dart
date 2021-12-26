/*
   users in contact of current user
 */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:raktkhoj/model/contact.dart';
import 'package:raktkhoj/model/user.dart';
import 'package:raktkhoj/provider/chat_method.dart';
import 'package:raktkhoj/screens/Chat/chat_screen.dart';

import 'cached_image.dart';
import 'last_message_container.dart';


class ContactList extends StatelessWidget {
  final Contact contact;

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<UserModel> getUserDetailsById(id) async {
    try {
      DocumentSnapshot documentSnapshot =
      await _firestore.collection("User Details").doc(id).get();
      return UserModel.fromMap(documentSnapshot.data());
    } catch (e) {
      print(e);
      return null;
    }
  }

  ContactList(this.contact);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: getUserDetailsById(contact.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserModel user = snapshot.data;

          return ViewLayout(
            contact: user,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class ViewLayout extends StatelessWidget {
  final UserModel contact;
  final ChatMethods _chatMethods = ChatMethods();

  ViewLayout({
    @required this.contact,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              receiver: contact,
            ),
          )),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: false ? 10 : 0),
          child: Row(
            children: <Widget>[
          Container(
          constraints: BoxConstraints(maxHeight: 50, maxWidth: 50),
          child: Stack(
            children: <Widget>[
              CachedImage(
                contact.profilePhoto,
                radius: 60,
                isRound: true,
              ),

            ],
          ),
        ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: false ? 10 : 15),
                  padding: EdgeInsets.symmetric(vertical: false ? 3 : 15),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1,
                              color:Colors.grey))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            (contact != null ? contact.name : null) != null ? contact.name : "..",
                            style:
                            TextStyle(color: Colors.black, fontFamily: "Arial", fontSize: 15),
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: <Widget>[
                              LastMessageContainer(
                                stream: _chatMethods.fetchLastMessageBetween(
                                  senderId: FirebaseAuth.instance.currentUser.uid,
                                  receiverId: contact.uid,
                                )
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
    );
  }
}
