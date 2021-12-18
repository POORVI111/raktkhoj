import 'dart:convert';
import 'package:http/http.dart';
import 'package:raktkhoj/Constants.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
Future<Response> sendNotification(List<String> tokenIdList, String contents, String heading) async{

  return await post(
    Uri.parse('https://onesignal.com/api/v1/notifications'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>
    {
      "app_id": ONESIGNAL_APP_ID,//App Id that one get from the OneSignal When the application is registered.

      "include_player_ids": tokenIdList,//tokenIdList Is the List of All the Token Id to to Whom notification must be sent.

      // android_accent_color reprsent the color of the heading text in the notifiction
      "android_accent_color":"FF9976D2",

      "small_icon":"ic_stat_onesignal_default",

      "large_icon":"images/logo.png",

      "headings": {"en": heading},

      "contents": {"en": contents},


    }),
  );


}
  sendEmail(String adminMail, String requestlink, String text, String heading) async {
    String username = 'raktkhojad@gmail.com';
    String password = 'raktkhojadmin';

    final smtpServer = gmail(username, password);
    // Use the SmtpServer class to configure an SMTP server:
    // final smtpServer = SmtpServer('smtp.domain.com');
    // See the named arguments of SmtpServer for further configuration
    // options.

    // Create our message.
    final message = Message()
      ..from = Address(username, 'Raktkhoj')
      ..recipients.add(adminMail)
      ..subject = 'Raktkhoj Blood Request 🩸 \n ${DateTime.now()}'
      ..html = "<h1>$heading</h1>\n<p>$text $requestlink</p>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

sendccEmails(List<String> donorMails, String requestlink, String text, String heading) async {
  String username = 'raktkhojad@gmail.com';
  String password = 'raktkhojadmin';

  final smtpServer = gmail(username, password);
  // Use the SmtpServer class to configure an SMTP server:
  // final smtpServer = SmtpServer('smtp.domain.com');
  // See the named arguments of SmtpServer for further configuration
  // options.

  // Create our message.
  final message = Message()
    ..from = Address(username, 'Raktkhoj')
    ..ccRecipients.addAll(donorMails)
    ..subject = 'Raktkhoj Blood Request 🩸 \n ${DateTime.now()}'
    ..html = "<h1>$heading</h1>\n<p>$text $requestlink</p>";

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
}



