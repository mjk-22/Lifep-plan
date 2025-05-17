
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lifeplan/CreateGroupScreen.dart';
import 'chatScreen.dart';

class GroupListScreen extends StatelessWidget {
  static const Color bgTeal = Color(0xFFCDE7EF);
  static const Color appBarGrey = Color(0xFFB0B0B0);
  static const Color textGrey = Color(0xFF4A4A4A);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: bgTeal,
      appBar: AppBar(
        title: Text('Group Chats', style: TextStyle(color: textGrey)),
        backgroundColor: appBarGrey,
        iconTheme: IconThemeData(color: textGrey),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('groups')
            .where('members', arrayContains: user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return ListTile(
                title: Text(doc['name'], style: TextStyle(color: textGrey)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        groupId: doc.id,
                        groupName: doc['name'],
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: appBarGrey,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreateGroupScreen(),
            ),
          );
        },
      ),
    );
  }
}
