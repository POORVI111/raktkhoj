import 'dart:math';

import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:raktkhoj/provider/call_method.dart';
import 'package:raktkhoj/screens/Chat/video_call_screen.dart';
import 'model/call.dart';
import 'model/user.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static dial({UserModel from, UserModel to, context}) async {
    Call call = Call(
      callerId: from.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      receiverId: to.uid,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      channelId: Random().nextInt(1000).toString(),
    );

    bool callMade = await callMethods.makeCall(call: call);


    call.hasDialled = true;

    if (callMade) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(call: call),
        ),
      );
    }
  }
// static Future<bool> cameraAndMicrophonePermissionsGranted() async {
//   PermissionStatus cameraPermissionStatus = await _getCameraPermission();
//   PermissionStatus microphonePermissionStatus =
//   await _getMicrophonePermission();
//
//   if (cameraPermissionStatus == PermissionStatus.granted &&
//       microphonePermissionStatus == PermissionStatus.granted) {
//     return true;
//   } else {
//     _handleInvalidPermissions(
//         cameraPermissionStatus, microphonePermissionStatus);
//     return false;
//   }
// }
//
// static Future<PermissionStatus> _getCameraPermission() async {
//   PermissionStatus permission =
//   await Permission.camera.status;
//   if (permission != PermissionStatus.granted &&
//       permission != PermissionStatus.restricted) {
//     Map<Permission, PermissionStatus> permissionStatus =
//     await [Permission.camera]
//         .request();
//     return permissionStatus[Permission.camera] ??
//         PermissionStatus.denied;
//   } else {
//     return permission;
//   }
// }
//
// static Future<PermissionStatus> _getMicrophonePermission() async {
//   PermissionStatus permission =
//   await Permission.microphone.status;
//   if (permission != PermissionStatus.granted &&
//       permission != PermissionStatus.restricted) {
//     Map<Permission, PermissionStatus> permissionStatus =
//     await [Permission.microphone]
//         .request();
//     return permissionStatus[Permission.microphone] ??
//         PermissionStatus.denied;
//   } else {
//     return permission;
//   }
// }
//
// static void _handleInvalidPermissions(
//     PermissionStatus cameraPermissionStatus,
//     PermissionStatus microphonePermissionStatus,
//     ) {
//   if (cameraPermissionStatus == PermissionStatus.denied &&
//       microphonePermissionStatus == PermissionStatus.denied) {
//     throw new PlatformException(
//         code: "PERMISSION_DENIED",
//         message: "Access to camera and microphone denied",
//         details: null);
//   } else if (cameraPermissionStatus == PermissionStatus.restricted &&
//       microphonePermissionStatus == PermissionStatus.restricted) {
//     throw new PlatformException(
//         code: "PERMISSION_DISABLED",
//         message: "Location data is not available on device",
//         details: null);
//   }
// }

}