import 'package:flutter/material.dart';

class UserPanel extends StatelessWidget {
  const UserPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFFEAF2F5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Life Plan',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.account_circle_rounded),
                    //  CircleAvatar(
                       // radius: 20,
                        //backgroundImage: AssetImage('assets/'), // placeholder, we will replace after
                      //),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [//place holder for now, we will modify it with firebase connection
                          Text('Jack Smith', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('jackmehoff@gmail.com', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      Spacer(),
                      Icon(Icons.more_vert),
                    ],
                  ),
                )
              ],
            ),
          ),
          ListTile(leading: Icon(Icons.home), title: Text("Home")),
          ListTile(leading: Icon(Icons.notifications), title: Text("Notifications")),
          const Divider(),
          ExpansionTile(
            title: Text("Social"),
            children: const [
              ListTile(title: Text("Add user")),
              ListTile(title: Text("Group chats")),
              ListTile(title: Text("Public Schedules")),
            ],
          ),
          const Divider(),
          ExpansionTile(
            title: Text("Companion"),
            children: const [
              ListTile(title: Text("Shop")),
              ListTile(title: Text("Points")),
            ],
          ),
          const Divider(),
          ListTile(leading: Icon(Icons.settings), title: Text("Support")),
        ],
      ),
    );
  }
}
