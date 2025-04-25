import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'package:lifeplan/navPages/timer.dart';

import 'companion.dart';

void main() => runApp(const ClockApp());

class ClockApp extends StatelessWidget {
  const ClockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ClockPage(),
    );
  }
}
class HoverTab extends StatefulWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const HoverTab({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  State<HoverTab> createState() => _HoverTabState();
}

class _HoverTabState extends State<HoverTab> {
  bool isHovering = false;
  @override
  Widget build(BuildContext context) {


    final backgroundColor = widget.selected
        ? Colors.white
        : isHovering
        ? const Color(0xFFE0E0E0) // light gray on hover
        : Colors.transparent;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: TextStyle(
                color: widget.selected ? Colors.black : Colors.grey,
                fontWeight: widget.selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }


}

class ClockPage extends StatefulWidget {
  const ClockPage({super.key});

  @override
  State<ClockPage> createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  int selectedTabIndex = 0; // 0 = World Clock, 1 = Alarm, 2 = Timer

  late Timer timer;
  DateTime now = DateTime.now();
  List<String> navPages = [
    '/schedules',
    '/timer',
    '/home',
    '/planner',
    '/companion'
  ];
  int currentIndex = 1;
  void _tappedItem(int index) {
    setState(() {
      currentIndex = index;
    });
  }
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hour = now.hour % 12;
    final minute = now.minute;
    final second = now.second;

    return Scaffold(
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
      drawer: drawer(),
      backgroundColor: const Color(0xFFEAF2F5),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Icon(Icons.arrow_back_ios_new, size: 20),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Tab bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 60),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: HoverTab(
                      label: "World clock",
                      selected: selectedTabIndex == 0,
                      onTap: () => setState(() => selectedTabIndex = 0),
                    ),
                  ),
                  Expanded(
                    child: HoverTab(
                      label: "Alarm",
                      selected: selectedTabIndex == 1,
                      onTap: () => setState(() => selectedTabIndex = 1),
                    ),
                  ),
                  Expanded(
                    child: HoverTab(
                      label: "Timer",
                      selected: selectedTabIndex == 2,
                      onTap: () {
                        setState(() => selectedTabIndex = 2);
                        // Navigate to the Timer screen when clicked
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TimerScreen()), // Replace TimerScreen() with your actual Timer widget
                        );
                      },
                    ),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 40),
            // Analog clock
            SizedBox(
              height: 250,
              width: 250,
              child: CustomPaint(
                painter: ClockPainter(hour, minute, second),
              ),
            ),
            const SizedBox(height: 40),
            const Text("Eastern Time", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Text(
              "${_monthDay(now)}  ${_weekday(now)}, ${_formatTime(now)}",
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color(0xFFE3FFFF),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xFF356A6B),
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            _tappedItem(index);
            Navigator.pushNamed(context, navPages[currentIndex]);
          },
          currentIndex: currentIndex,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              label: "Schedules",
            ),
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
          ])

    );
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 260,
                height: 1.0,
                color: Colors.blueGrey,
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 50,
            child: ListTile(
              leading: Icon(
                Icons.person_add_alt_1,
                color: Colors.blueGrey,
                size: 25,
              ),
              title: Text(
                "Add user",
                style: TextStyle(color: Colors.blueGrey),
              ),
            ),
          ),
          Container(
            height: 50,
            child: ListTile(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 260,
                height: 1.0,
                color: Colors.blueGrey,
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 50,
            child: ListTile(
              leading: Icon(
                Icons.shopping_bag_outlined,
                color: Colors.blueGrey,
                size: 25,
              ),
              title: Text(
                "Shop",
                style: TextStyle(color: Colors.blueGrey),
              ),
            ),
          ),
          Container(
            height: 50,
            child: ListTile(
              leading: Icon(
                Icons.monetization_on,
                color: Colors.blueGrey,
                size: 25,
              ),
              title: Text(
                "Points",
                style: TextStyle(color: Colors.blueGrey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    int hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
    String period = dt.hour >= 12 ? "PM" : "AM";
    return "${_padZero(hour)}:${_padZero(dt.minute)}$period";
  }

  String _monthDay(DateTime dt) {
    return "${_monthName(dt.month)} ${dt.day}";
  }

  String _weekday(DateTime dt) {
    return [
      "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"
    ][dt.weekday - 1];
  }

  String _padZero(int n) => n.toString().padLeft(2, '0');

  String _monthName(int month) {
    return [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ][month - 1];
  }


}



class ClockPainter extends CustomPainter {
  final int hour;
  final int minute;
  final int second;

  ClockPainter(this.hour, this.minute, this.second);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    final paintCircle = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paintCircle);

    final tickPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.5;

    for (int i = 0; i < 12; i++) {
      double angle = i * pi / 6;
      Offset start = center + Offset(cos(angle) * (radius - 10), sin(angle) * (radius - 10));
      Offset end = center + Offset(cos(angle) * radius, sin(angle) * radius);
      canvas.drawLine(start, end, tickPaint);
    }

    // Hour hand
    final hourAngle = (pi / 6) * hour + (pi / 360) * minute;
    final hourHand = Paint()
      ..color = Colors.black
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(center, center + Offset(cos(hourAngle) * radius * 0.5, sin(hourAngle) * radius * 0.5), hourHand);

    // Minute hand
    final minAngle = (pi / 30) * minute;
    final minHand = Paint()
      ..color = Colors.black
      ..strokeWidth = 4;
    canvas.drawLine(center, center + Offset(cos(minAngle) * radius * 0.7, sin(minAngle) * radius * 0.7), minHand);

    // Second hand
    final secAngle = (pi / 30) * second;
    final secHand = Paint()
      ..color = Colors.red
      ..strokeWidth = 2;
    canvas.drawLine(center, center + Offset(cos(secAngle) * radius * 0.8, sin(secAngle) * radius * 0.8), secHand);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
