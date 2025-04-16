import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lifeplan/worldclock.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}
class _TimerScreenState extends State<TimerScreen> {
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

  @override
  Widget build(BuildContext context) {
    // Keep everything else the same...
    // (your existing build method goes here)
    // So no need to modify the UI part unless you want animation or color changes.
    // Only this logic block needed to be changed.
    return Scaffold(
      backgroundColor: const Color(0xFFEAF2F5),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios_new, size: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tabs
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
                      selected: false,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ClockApp()));
                      },
                    ),
                  ),
                  Expanded(
                    child: HoverTab(
                      label: "Alarm",
                      selected: false,
                      onTap: () {},
                    ),
                  ),
                  Expanded(
                    child: HoverTab(
                      label: "Timer",
                      selected: true,
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),

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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        currentIndex: 1,
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

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final h = twoDigits(d.inHours);
    final m = twoDigits(d.inMinutes.remainder(60));
    final s = twoDigits(d.inSeconds.remainder(60));
    return "$h:$m:$s";
  }
}
