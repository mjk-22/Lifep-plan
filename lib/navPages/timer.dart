import 'dart:async';
import 'package:lifeplan/db/dbsetup.dart';
import 'package:flutter/material.dart';
import 'companion.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}
class _TimerScreenState extends State<TimerScreen> {
  LifeplanDatabase db = LifeplanDatabase();
  bool isRunning = false;
  Duration duration = const Duration(minutes: 40);
  Timer? timer;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (duration.inSeconds > 0) {
        setState(() {
          duration -= const Duration(seconds: 1);
        });
      } else {
        stopTimer();
      }
    });
  }

  void stopTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void toggleTimer() {
    if (isRunning) {
      stopTimer();
    } else {
      setState(() => isRunning = true);
      startTimer();
    }
  }

  void resetTimer() {
    stopTimer();
    setState(() {
      duration = const Duration(minutes: 40);
    });
  }



  List<String> navPages = [
    '/timer',
    '/home',
    '/planner',
    '/companion'
  ];
  int currentIndex = 0;
  String? selectedStart;
  String? selectedEnd;

  void _tappedItem(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Keep everything else the same...
    // (your existing build method goes here)
    // So no need to modify the UI part unless you want animation or color changes.
    // Only this logic block needed to be changed.
    return Scaffold(drawer: drawer(),
        backgroundColor:  Color(0xFFDCF0F0),
        appBar: AppBar(
            backgroundColor: Color(0xFFDCF0F0),
            bottom: PreferredSize(
                preferredSize: Size.fromHeight(1.0),
                child: Container(
                  width: 370,
                  color: Colors.blueGrey,
                  height: 1.0,
                )),
            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(
                    Icons.chevron_right,
                    color: Colors.blueGrey,
                    size: 40,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            )
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),

              const SizedBox(height: 200),

              // Timer Circle
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, 10),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Center(
                  child: Text(
                    _formatDuration(duration),
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(isRunning ? Icons.pause : Icons.play_arrow),
                    iconSize: 40,
                    onPressed: toggleTimer,
                  ),
                  const SizedBox(width: 30),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    iconSize: 35,
                    onPressed: resetTimer,
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: bottomNav(currentIndex)

    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final h = twoDigits(d.inHours);
    final m = twoDigits(d.inMinutes.remainder(60));
    final s = twoDigits(d.inSeconds.remainder(60));
    return "$h:$m:$s";
  }

  Widget bottomNav(index) {
    return BottomNavigationBar(
        backgroundColor: Color(0xFFE3FFFF),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF356A6B),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          _tappedItem(index);
          Navigator.pushNamed(context, navPages[currentIndex]);
        },
        currentIndex: index,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.timer_outlined),
            label: "Timer",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.my_library_books_rounded),
            label: "Planner",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_pin_circle_rounded),
            label: "Companion",
          ),
        ]);
  }

  Widget drawer() {
    return Drawer(
      backgroundColor: Color(0xFFE3FFFF),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(height: 35),
          Container(
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.chevron_left,
                      color: Colors.blueGrey,
                      size: 40,
                    ))
              ],
            ),
          ),
          SizedBox(height: 35),
          Container(
            height: 1.0,
            color: Colors.blueGrey,
          ),
          SizedBox(
            height: 20,

          ),
          Container(
            height: 50,
            child: ListTile(
              onTap: () {
                Navigator.pushNamed(context, '/viewaccount');
              },
              leading: Icon(
                Icons.account_circle_rounded,
                color: Colors.blueGrey,
                size: 25,
              ),
              title: Text(
                "Account",
                style: TextStyle(color: Colors.blueGrey),
              ),
            ),
          ),
          Container(
            height: 50,
            child: ListTile(
              onTap: () {
                Navigator.pushNamed(context, '/home');
              },
              leading: Icon(
                Icons.home_outlined,
                color: Colors.blueGrey,
                size: 25,
              ),
              title: Text(
                "Home",
                style: TextStyle(color: Colors.blueGrey),
              ),
            ),
          ),
          Container(
            height: 50,
            child: ListTile(
              onTap: () {
                Navigator.pushNamed(context, '/notification');
              },
              leading: Icon(
                Icons.notifications_active,
                color: Colors.blueGrey,
                size: 25,
              ),
              title: Text(
                "Notifications",
                style: TextStyle(color: Colors.blueGrey),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 1.0,
            color: Colors.blueGrey,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 50,
            child: ListTile(
              onTap: () {
                Navigator.pushNamed(context, '/groupchat');
              },
              leading: Icon(
                Icons.message,
                color: Colors.blueGrey,
                size: 25,
              ),
              title: Text(
                "Chat Rooms",
                style: TextStyle(color: Colors.blueGrey),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 1.0,
            color: Colors.blueGrey,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 50,
            child: ListTile(
              onTap: () {
                db.logout(context);
              },
              leading: Icon(
                Icons.logout,
                color: Colors.blueGrey,
                size: 25,
              ),
              title: Text(
                "Logout",
                style: TextStyle(color: Colors.blueGrey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}