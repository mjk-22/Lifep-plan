import 'package:flutter/material.dart';
import 'package:lifeplan/navPages/worldclock.dart';

import '../companionshop.dart';


// Main Companion Page
class CompanionPage extends StatefulWidget {
  const CompanionPage({super.key});

  @override
  State<CompanionPage> createState() => _CompanionPageState();
}

class _CompanionPageState extends State<CompanionPage> {
  List<String> navPages = [
    '/schedules',
    '/timer',
    '/home',
    '/planner',
    '/companion'
  ];
  int currentIndex = 4;
  String? selectedStart;
  String? selectedEnd;

  void _tappedItem(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  String mainDialogue =
      "You're doing so well, I might just have to join you—keep shining!";
  String alternateDialogue =
      "It’s time! Your study session is starting now—let’s get focused!";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(),
      backgroundColor: const Color(0xFFEAF2F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEAF2F5),
        title: const Text(
          'Current Companion',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w400,
            color: Colors.blueGrey,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              'Lauren Smith',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // Main Dialogue Box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(2, 2),
                    )
                  ],
                ),
                child: Text(
                  mainDialogue,
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Alternate Dialogue Description and Box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Choose your motivational dialogue:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(2, 2),
                        )
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Radio<String>(
                          value: alternateDialogue,
                          groupValue: mainDialogue,
                          onChanged: (String? value) {
                            setState(() {
                              final temp = mainDialogue;
                              mainDialogue = alternateDialogue;
                              alternateDialogue = temp;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(
                              alternateDialogue,
                              style: const TextStyle(
                                fontSize: 12.5,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Companion Image
            Center(
              child: Image.network(
                'https://s3-alpha-sig.figma.com/img/168d/77b9/12fe6643e6b38febf61fd1bdf8f54532?Expires=1745798400&Key-Pair-Id=APKAQ4GOSFWCW27IBOMQ&Signature=ZFDYChHJAyD4PxVFlQIZW3YgbBiylx1NlPvbidTODoDeMlVCmTg06TisP8~T9jvj2OXamGozLFK7uQ8tDEGJBN22sc0lfbBQXQ26ZejVF3L4r7-lVWugvMeCAHJkGQSP14uCRPFomAX~M-JPEccu6~o0FzpFbuhQ3dFD2rdI1S9vVRtkE-zqnXEGK0HNDoW13DTFyNtPvJN0F4KcG8esHJTKXDpo8SrGfrco8nTs2F4~Q1KRtU~~kScePlzBCzSuJma~13VeFuSf7abCSKD4N0UVu~LY2dzIrokV2aHi84bnKPF8trJJ8e1RSUfCY3fd-lHkPnkQj4QVzKgdUG~kCQ__',
                height: 400,
              ),
            ),

            // Shop Button
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ShopCompanionPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade700,
                padding:
                const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Shop New Companion',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: bottomNav(currentIndex)
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
        ]);
  }
}
