import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'main.dart';

void showCompanionReplyNotification(String companionDocId, {Function(String)? onReply}) async {
  final doc = await FirebaseFirestore.instance
      .collection('companions')
      .doc(companionDocId)
      .get();

  if (doc.exists && doc.data()!.containsKey('replies')) {
    List<dynamic> replies = doc.data()!['replies'];

    if (replies.isNotEmpty) {
      final random = Random();
      String reply = replies[random.nextInt(replies.length)];

      print("Selected reply: $reply");

      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'companion_channel',
        'Companion Replies',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
      );

      const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

      await flutterLocalNotificationsPlugin.show(
        0,
        'Your Companion Says',
        reply,
        platformDetails,
      );

      if (onReply != null) {
        onReply(reply);
      }
    }
  }
}
