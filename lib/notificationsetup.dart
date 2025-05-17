import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> showCompanionReplyAwesome(String companionDocId) async {
  final doc = await FirebaseFirestore.instance
      .collection('companions')
      .doc(companionDocId)
      .get();

  if (doc.exists && doc.data()!.containsKey('replies')) {
    List<dynamic> replies = doc.data()!['replies'];

    if (replies.isNotEmpty) {
      final random = Random();
      String reply = replies[random.nextInt(replies.length)];

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
          channelKey: 'companion_channel',
          title: 'Your Companion Says',
          body: reply,
          notificationLayout: NotificationLayout.Default,
        ),
      );
    }
  }
}