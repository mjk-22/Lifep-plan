import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GroupSettingsScreen extends StatefulWidget {
  final String groupId;
  final String currentName;

  GroupSettingsScreen({required this.groupId, required this.currentName});

  @override
  _GroupSettingsScreenState createState() => _GroupSettingsScreenState();
}

class _GroupSettingsScreenState extends State<GroupSettingsScreen> {
  final _nameController = TextEditingController();
  final _userSearchController = TextEditingController();
  List<Map<String, String>> _members = []; // holds uid and display email or 'You'
  List<Map<String, dynamic>> _searchResults = [];
  final _me = FirebaseAuth.instance.currentUser!;

  static const Color bgTeal = Color(0xFFCDE7EF);
  static const Color appBarGrey = Color(0xFFB0B0B0);
  static const Color textGrey = Color(0xFF4A4A4A);

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.currentName;
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    final doc = await FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupId)
        .get();
    List<String> uids = List<String>.from(doc['members']);
    List<Map<String, String>> temp = [];
    for (String uid in uids) {
      String display;
      if (uid == _me.uid) {
        display = 'You';
      } else {
        final userDoc = await FirebaseFirestore.instance
            .collection('accounts')
            .doc(uid)
            .get();
        display = userDoc.data()?['email'] as String? ?? uid;
      }
      temp.add({'uid': uid, 'display': display});
    }
    setState(() => _members = temp);
  }

  Future<void> _renameGroup() async {
    await FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupId)
        .update({'name': _nameController.text.trim()});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Group name updated')),
    );
  }

  Future<void> _searchUsers(String q) async {
    if (q.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }
    final snap = await FirebaseFirestore.instance
        .collection('accounts')
        .where('email', isGreaterThanOrEqualTo: q)
        .where('email', isLessThanOrEqualTo: q + '\uf8ff')
        .get();
    setState(() => _searchResults = snap.docs
        .map((d) => {'uid': d.id, 'email': d['email']})
        .toList());
  }

  Future<void> _addMember(String uid) async {
    await FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupId)
        .update({'members': FieldValue.arrayUnion([uid])});
    _loadMembers();
  }

  Future<void> _removeMember(String uid) async {
    await FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupId)
        .update({'members': FieldValue.arrayRemove([uid])});
    _loadMembers();
  }

  Future<void> _deleteGroup() async {
    await FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupId)
        .delete();
    Navigator.of(context).pop(); // settings screen
    Navigator.of(context).pop(); // group list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgTeal,
      appBar: AppBar(
        title: Text('Group Settings', style: TextStyle(color: textGrey)),
        backgroundColor: appBarGrey,
        iconTheme: IconThemeData(color: textGrey),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            // Rename group
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Group Name',
                labelStyle: TextStyle(color: textGrey),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.edit, color: textGrey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: textGrey),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _renameGroup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: appBarGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text('Save Name', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 16),
            Divider(color: appBarGrey, thickness: 1),

            // Members list
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Members', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textGrey)),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: _members.map((member) {
                  final display = member['display']!;
                  final uid = member['uid']!;
                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: textGrey,
                        child: Text(display.substring(0, 1).toUpperCase(), style: const TextStyle(color: Colors.white)),
                      ),
                      title: Text(display, style: TextStyle(color: textGrey)),
                      trailing: uid == _me.uid
                          ? null
                          : IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        color: Colors.redAccent,
                        onPressed: () => _removeMember(uid),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Divider(color: appBarGrey, thickness: 1),

            // Add members (search by email)
            TextField(
              controller: _userSearchController,
              decoration: InputDecoration(
                labelText: 'Search to add users by email',
                labelStyle: TextStyle(color: textGrey),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.search, color: textGrey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: textGrey),
              onChanged: _searchUsers,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: _searchResults.map((u) {
                  final already = _members.any((m) => m['uid'] == u['uid']);
                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(u['email'], style: TextStyle(color: textGrey)),
                      trailing: already
                          ? Icon(Icons.check_circle, color: appBarGrey)
                          : IconButton(
                        icon: Icon(Icons.add_circle_outline, color: textGrey),
                        onPressed: () => _addMember(u['uid']),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Divider(color: appBarGrey, thickness: 1),

            // Delete group
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.delete, color: Colors.white),
                label: Text('Delete Group', style: const TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _deleteGroup,
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
