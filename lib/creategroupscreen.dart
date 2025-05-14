import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateGroupScreen extends StatefulWidget {
  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _groupNameController = TextEditingController();
  final _searchController = TextEditingController();
  List<String> selectedUserIds = [];
  List<Map<String, dynamic>> searchResults = [];

  void _searchUsers(String query) async {
    if (query.isEmpty) {
      setState(() => searchResults = []);
      return;
    }
    final result = await FirebaseFirestore.instance
        .collection('accounts')
        .where('username', isGreaterThanOrEqualTo: query)
        .where('username', isLessThanOrEqualTo: query + '\uf8ff')
        .get();
    setState(() {
      searchResults = result.docs
          .map((doc) => {'uid': doc.id, 'username': doc['username']})
          .toList();
    });
  }

  void _createGroup() async {
    if (_groupNameController.text.isEmpty || selectedUserIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enter group name and add members')),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    selectedUserIds.add(user!.uid); // Add current user to group
    final groupRef = await FirebaseFirestore.instance.collection('groups').add({
      'name': _groupNameController.text,
      'members': selectedUserIds,
      'createdBy': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Group')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _groupNameController,
              decoration: InputDecoration(labelText: 'Group Name'),
            ),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(labelText: 'Search Users'),
              onChanged: _searchUsers,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final user = searchResults[index];
                  return CheckboxListTile(
                    title: Text(user['username']),
                    value: selectedUserIds.contains(user['uid']),
                    onChanged: (val) {
                      setState(() {
                        if (val!) {
                          selectedUserIds.add(user['uid']);
                        } else {
                          selectedUserIds.remove(user['uid']);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _createGroup,
              child: Text('Create Group'),
            ),
          ],
        ),
      ),
    );
  }
}
