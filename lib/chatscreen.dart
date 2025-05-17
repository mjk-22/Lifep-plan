import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lifeplan/groupsettingsscreen.dart';

class ChatScreen extends StatefulWidget {
  final String groupId;
  final String groupName;

  ChatScreen({required this.groupId, required this.groupName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  static const Color bgTeal = Color(0xFFCDE7EF);
  static const Color appBarGrey = Color(0xFFB0B0B0);
  static const Color textGrey = Color(0xFF4A4A4A);

  void _sendMessage() async {
    if (_messageController.text.isEmpty) return;
    await FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupId)
        .collection('messages')
        .add({
      'senderId': user!.uid,
      'text': _messageController.text,
      'timestamp': FieldValue.serverTimestamp(),
    });
    _messageController.clear();
  }

  void _deleteMessage(String messageId) {
    FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupId)
        .collection('messages')
        .doc(messageId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgTeal,
      appBar: AppBar(
        title: Text(widget.groupName, style: TextStyle(color: textGrey)),
        backgroundColor: appBarGrey,
        iconTheme: IconThemeData(color: textGrey),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: textGrey),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => GroupSettingsScreen(
                  groupId: widget.groupId,
                  currentName: widget.groupName,
                ),
              ));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('groups')
                  .doc(widget.groupId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return const Center(child: CircularProgressIndicator());
                if (snapshot.hasError)
                  return Center(child: Text('Error: ${snapshot.error}'));
                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) return const Center(child: Text('No messages yet.'));

                return ListView.builder(
                  reverse: true,
                  itemCount: docs.length,
                  itemBuilder: (ctx, i) {
                    final msg = docs[i];
                    final isMe = msg['senderId'] == user!.uid;
                    final ts = msg['timestamp'] as Timestamp?;
                    final timeString = ts != null
                        ? DateFormat('hh:mm a').format(ts.toDate())
                        : '';
                    return ListTile(
                      title: Text(msg['text'], style: TextStyle(color: textGrey)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(isMe ? 'You' : 'User ${msg['senderId']}',
                              style: TextStyle(color: textGrey)),
                          if (timeString.isNotEmpty)
                            Text(timeString,
                                style: TextStyle(color: textGrey, fontSize: 12)),
                        ],
                      ),
                      trailing: isMe
                          ? IconButton(
                        icon: Icon(Icons.delete_outline, size: 20, color: textGrey),
                        onPressed: () => _deleteMessage(docs[i].id),
                      )
                          : null,
                    );
                  },
                );
              },
            ),
          ),

          // Input bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Type a message',
                      labelStyle: TextStyle(color: textGrey),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none),
                    ),
                    style: TextStyle(color: textGrey),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: appBarGrey,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}