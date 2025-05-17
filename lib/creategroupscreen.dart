import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateGroupScreen extends StatefulWidget {
  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _groupNameController = TextEditingController();
  final _searchController = TextEditingController();
  List<String> selectedUserIds = [];
  List<Map<String, dynamic>> searchResults = [];

  static const Color bgTeal = Color(0xFFCDE7EF);
  static const Color appBarGrey = Color(0xFFB0B0B0);
  static const Color textGrey = Color(0xFF4A4A4A);

  void _searchUsers(String query) async {
    if (query.isEmpty) {
      setState(() => searchResults = []);
      return;
    }
    final result = await FirebaseFirestore.instance
        .collection('accounts')
        .where('email', isGreaterThanOrEqualTo: query)
        .where('email', isLessThanOrEqualTo: query + '\uf8ff')
        .get();
    setState(() {
      searchResults = result.docs
          .map((doc) => {'uid': doc.id, 'email': doc['email']})
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
    final user = FirebaseAuth.instance.currentUser!;
    if (!selectedUserIds.contains(user.uid)) {
      selectedUserIds.add(user.uid);
    }
    await FirebaseFirestore.instance.collection('groups').add({
      'name': _groupNameController.text.trim(),
      'members': selectedUserIds,
      'createdBy': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgTeal,
      appBar: AppBar(
        title: Text('Create Group', style: TextStyle(color: textGrey)),
        backgroundColor: appBarGrey,
        iconTheme: IconThemeData(color: textGrey),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Group Name input
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _groupNameController,
                style: TextStyle(color: textGrey),
                decoration: InputDecoration(
                  hintText: 'Group Name',
                  hintStyle: TextStyle(color: textGrey.withOpacity(0.6)),
                  prefixIcon: Icon(Icons.group, color: textGrey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Search Users input by email
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _searchUsers,
                style: TextStyle(color: textGrey),
                decoration: InputDecoration(
                  hintText: 'Search Users by email',
                  hintStyle: TextStyle(color: textGrey.withOpacity(0.6)),
                  prefixIcon: Icon(Icons.search, color: textGrey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Search Results list
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final userMap = searchResults[index];
                  final uid = userMap['uid'];
                  final email = userMap['email'];
                  final already = selectedUserIds.contains(uid);
                  return Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 6),
                    child: CheckboxListTile(
                      title: Text(email, style: TextStyle(color: textGrey)),
                      value: already,
                      activeColor: appBarGrey,
                      checkColor: Colors.white,
                      onChanged: (val) {
                        setState(() {
                          if (val == true) selectedUserIds.add(uid);
                          else selectedUserIds.remove(uid);
                        });
                      },
                      tileColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),

            // Create Group button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _createGroup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: appBarGrey,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Create Group',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
