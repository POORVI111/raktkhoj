import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:raktkhoj/model/user.dart';

import '../../Colors.dart';
import '../../main.dart';

class ChatBot extends StatefulWidget {

  @override
  _ChatBotState createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {


  TextEditingController textFieldController = TextEditingController();
  FocusNode textFieldFocus = FocusNode();

  DialogFlowtter dialogFlowtter;
  UserModel sender;
  String _currentUserId;
  bool isWriting = false;
  @override
  void initState() {
    super.initState();
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
    getCurrentUser().then((user) {
      _currentUserId = user.uid;
      setState(() {
      });
    });
  }
  showKeyboard() => textFieldFocus.requestFocus();
  hideKeyboard() => textFieldFocus.unfocus();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppBar(context),
      body: Column(
        children: <Widget>[
          Flexible(
             child: messageList(),
          ),
          Container(),
          chatControls(),
        ],
      ),
    );
  }

   Widget messageList() {
     return StreamBuilder(
       stream: FirebaseFirestore.instance
           .collection('User Details')
           .doc(_currentUserId)
           .collection("chat with bot")
           .orderBy("timestamp", descending: true)
           .snapshots(),
       builder: (context, snapshot) {
         if (snapshot.data == null) {
           return Center(child: CircularProgressIndicator());
         }


         return ListView.builder(
           padding: EdgeInsets.all(10),
           reverse: true,
           itemCount: snapshot.data.docs.length,
           itemBuilder: (context, index) {

             return chatMessageItem(snapshot.data.docs[index]);
           },
         );
       },
     );
   }
   Widget chatMessageItem(DocumentSnapshot snapshot) {
     Map<String, dynamic> map=snapshot.data();
     String text= map['message'];
     bool isUserMessage=map['isUserMessage'];
    // print('text $text');

     return Container(
       margin: EdgeInsets.symmetric(vertical: 15),
       child: Container(
         alignment: isUserMessage ==true
             ? Alignment.centerRight
             : Alignment.centerLeft,
         child: isUserMessage==true
             ? senderLayout(text)
             : receiverLayout(text),
       ),
     );
   }


   Widget senderLayout(String text) {
     Radius messageRadius = Radius.circular(5);

     return Container(
       margin: EdgeInsets.only(top: 12),
       constraints:
       BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
       decoration: BoxDecoration(
         color: kGrey,//sender
         borderRadius: BorderRadius.only(
           topLeft: messageRadius,
           topRight: messageRadius,
           bottomLeft: messageRadius,
         ),
       ),
       child: Padding(
         padding: EdgeInsets.all(5),
         child: Text(
           text,
           style: TextStyle(
             color: Colors.white,
             fontSize: 16.0,
           ),
         ),
       ),
     );
   }

   Widget receiverLayout(String text) {
     Radius messageRadius = Radius.circular(5);

     return Container(
       margin: EdgeInsets.only(top: 12),
       constraints:
       BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
       decoration: BoxDecoration(
         color: kBackgroundColor,//receiverColor,
         borderRadius: BorderRadius.only(
           bottomRight: messageRadius,
           topRight: messageRadius,
           bottomLeft: messageRadius,
         ),
       ),
       child: Padding(
         padding: EdgeInsets.all(5),
         child: Text(
           text,
           style: TextStyle(
             color: Colors.white,
             fontSize: 16.0,
           ),
         ),
       ),
     );
   }
  Widget chatControls() {
    setWritingTo(bool val) {
      setState(() {
        isWriting = val;
      });
    }

    sendMessage() async {
      var text = textFieldController.text;
      if (text.isEmpty) return;

      var map = Map<String, dynamic>();
      map['message']= text;
      map['isUserMessage']=true;
      map['timestamp']=Timestamp.now();

      textFieldController.text = "";
      await FirebaseFirestore.instance.collection('User Details').doc(_currentUserId).collection('chat with bot').add(map);
      DetectIntentResponse response = await dialogFlowtter.detectIntent(
    queryInput: QueryInput(text: TextInput(text: text)),
   );

  if (response.message == null) return;
   map['message']= response.message.text?.text[0];
   map['isUserMessage']=false;
   map['timestamp']=Timestamp.now();
   await FirebaseFirestore.instance.collection('User Details').doc(_currentUserId).collection('chat with bot').add(map);

      setState(() {
        isWriting = false;
      });

    }

    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          GestureDetector(
            // onTap: () => shareDoc(context),
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                //gradient: Colors.f,//fabGradient,
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: textFieldController,
                  focusNode: textFieldFocus,
                 // onTap: () => hideEmojiContainer(),
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  onChanged: (val) {
                    (val.length > 0 && val.trim() != "")
                        ? setWritingTo(true)
                        : setWritingTo(false);
                  },
                  decoration: InputDecoration(
                    hintText: "Type a message",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(50.0),
                        ),
                        borderSide: BorderSide.none),
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    filled: true,
                    //fillColor: Colors.separatorColor,
                  ),
                ),
              ],
            ),
          ),
          isWriting
              ? Container(
              margin: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                //gradient: Colors.fabGradient,
                  shape: BoxShape.circle),
              child: IconButton(
                icon: Icon(
                  Icons.send,
                  size: 15,
                ),
                onPressed: () => sendMessage(),
              ))
              : Container()
        ],
      ),
    );
  }

  customAppBar(context) {
    return AppBar(
      backgroundColor: kMainRed,
      leading: IconButton(
        icon: Icon(
          FontAwesomeIcons.reply,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: false,
      title: Text(
        "Chat with Raktkhoj",
      ),
    );
  }

@override
void dispose() {
  dialogFlowtter.dispose();
  super.dispose();
}


}