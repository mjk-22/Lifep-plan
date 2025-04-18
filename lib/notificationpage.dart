import 'package:flutter/material.dart';
import 'userPanel.dart';

void main() => runApp(NotificationApp());

class NotificationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NotificationScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isReminderOn = true;
  bool isEmailUpdateOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF2F5),
      drawer: const UserPanel(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        //elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.chevron_left, color: Colors.black),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Notifications",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            SwitchListTile(
              title: const Text(
                'Would You Like To Keep Notifications On Or Turn Them Off?\nDisabling Them Means You Won’t Receive Any Reminders.',
                style: TextStyle(fontSize: 14),
              ),
              activeTrackColor: Colors.black,
              value: isReminderOn,
              onChanged: (value) => setState(() => isReminderOn = value),
            ),
            SwitchListTile(
              title: const Text(
                'Would You Like To Receive Email Updates About Your Plant Growth And Earned Points?',
                style: TextStyle(fontSize: 14),
              ),
              activeTrackColor: Colors.black,
              value: isEmailUpdateOn,
              onChanged: (value) => setState(() => isEmailUpdateOn = value),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.notifications_none, size: 60, color: Colors.grey),
                      SizedBox(height: 12),
                      Text('No Notifications!',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      SizedBox(height: 8),
                      Text("You don't have any notification yet!",
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.grey,

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Schedules"),
          BottomNavigationBarItem(icon: Icon(Icons.wb_sunny), label: "Timer"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Companion"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_view_day), label: "Planner"),
        ],
      ),
    );
  }
}
