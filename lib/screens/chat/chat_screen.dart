import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:raktkhoj/colors.dart';
import 'package:raktkhoj/components/cached_image.dart';
import 'package:raktkhoj/components/image_upload_provider.dart';
import 'package:raktkhoj/model/message.dart';
import 'package:raktkhoj/model/user.dart';
import 'package:raktkhoj/provider/call_utils.dart';
import 'package:raktkhoj/provider/chat_method.dart';
import 'package:raktkhoj/provider/storage_method.dart';

import '../../main.dart';


//screen to display one on one chat


class ChatScreen extends StatefulWidget {
  final UserModel receiver;

  ChatScreen({this.receiver});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ImageUploadProvider _imageUploadProvider;

  final StorageMethods _storageMethods = StorageMethods();
  final ChatMethods _chatMethods = ChatMethods();

  TextEditingController textFieldController = TextEditingController();
  FocusNode textFieldFocus = FocusNode();


  UserModel sender;
  String _currentUserId;
  bool isWriting = false;
  bool showEmojiPicker = false;

  @override
  void initState() {
    super.initState();
    getCurrentUser().then((user) {
      _currentUserId = user.uid;

      setState(() {
        sender = UserModel(
          uid: user.uid,
          name: user.displayName,
          profilePhoto: user.photoURL,
        );
      });
    });
  }

  showKeyboard() => textFieldFocus.requestFocus();

  hideKeyboard() => textFieldFocus.unfocus();

  hideEmojiContainer() {
    setState(() {
      showEmojiPicker = false;
    });
  }

  showEmojiContainer() {
    setState(() {
      showEmojiPicker = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    _imageUploadProvider = Provider.of<ImageUploadProvider>(context);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: customAppBar(context),
        body: Column(
          children: <Widget>[
            Flexible(
              child: messageList(),
            ),
            _imageUploadProvider.getViewState == "LOADING"
                ? Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(right: 15),
              child: CircularProgressIndicator(),
            )
                : Container(),
            chatControls(),
            showEmojiPicker ? Container(child: emojiContainer()) : Container(),
          ],
        ),
      );
  }

  emojiContainer() {
    return EmojiPicker(
      bgColor: Colors.white,
      indicatorColor: Colors.blue,
      rows: 3,
      columns: 7,
      onEmojiSelected: (emoji, category) {
        setState(() {
          isWriting = true;
        });

        textFieldController.text = textFieldController.text + emoji.emoji;
      },
      recommendKeywords: ["face", "happy", "party", "sad"],
      numRecommended: 50,
    );
  }
  

  Widget messageList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Chats")
          .doc(_currentUserId)
          .collection(widget.receiver.uid)
          .orderBy("timestamp", descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
    Message _message = Message.fromMap(snapshot.data());

    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Container(
        alignment: _message.senderId == _currentUserId
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: _message.senderId == _currentUserId
            ? senderLayout(_message)
            : receiverLayout(_message),
      ),
    );
  }

  Widget senderLayout(Message message) {
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
        child: getMessage(message),
      ),
    );
  }

  getMessage(Message message) {
    return message.type != "image"
        ? Text(
      message.message,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
    )
        : message.photoUrl != null
        ? CachedImage(
      message.photoUrl,
      height: 250,
      width: 250,
      radius: 10,
    )
        : Text("Url was null");
  }

  Widget receiverLayout(Message message) {
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
        child: getMessage(message),
      ),
    );
  }

  Widget chatControls() {
    setWritingTo(bool val) {
      setState(() {
        isWriting = val;
      });
    }

    sendMessage() {
      var text = textFieldController.text;

      Message _message = Message(
        receiverId: widget.receiver.uid,
        senderId: sender.uid,
        message: text,
        timestamp: Timestamp.now(),
        type: 'text',
      );

      setState(() {
        isWriting = false;
      });

      textFieldController.text = "";
      _chatMethods.addMessageToDb(_message);
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
              child: Icon(Icons.add),
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
                  onTap: () => hideEmojiContainer(),
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
                IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    if (!showEmojiPicker) {
                      // keyboard is visible
                      hideKeyboard();
                      showEmojiContainer();
                    } else {
                      //keyboard is hidden
                      showKeyboard();
                      hideEmojiContainer();
                    }
                  },
                  icon: Icon(Icons.face),
                ),
              ],
            ),
          ),
          isWriting
              ? Container()
              : Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(Icons.record_voice_over),
          ),
          isWriting
              ? Container()
              : GestureDetector(
            child: Icon(Icons.camera_alt),
            onTap: () => pickImage(source: ImageSource.gallery),
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

  static Future<PickedFile> _pickImage({@required ImageSource source}) async {
    final _picker = ImagePicker();
    PickedFile selectedImage = await _picker.getImage(source: source);
    return selectedImage;
  }


  void pickImage({@required ImageSource source}) async {
    PickedFile selectedImage = await _pickImage(source: source);
    _storageMethods.uploadImage(
        image: File(selectedImage.path),
        receiverId: widget.receiver.uid,
        senderId: _currentUserId,
        imageUploadProvider: _imageUploadProvider);
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
        widget.receiver.name,
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.video_call,
          ),
          onPressed: () async =>
          await CallUtils.cameraAndMicrophonePermissionsGranted()
              ? CallUtils.dial(
            from: sender,
            to: widget.receiver,
            context: context,
          )
              :
              {},
        ),
        IconButton(
          icon: Icon(
            Icons.phone,
          ),
          onPressed: () {},
        )
      ],
    );
  }
}

