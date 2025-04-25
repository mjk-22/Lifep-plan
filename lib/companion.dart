import 'package:flutter/material.dart';
import 'package:lifeplan/worldclock.dart';

import 'companionshop.dart';


// Main Companion Page
class CompanionPage extends StatefulWidget {
  const CompanionPage({super.key});

  @override
  State<CompanionPage> createState() => _CompanionPageState();
}

class _CompanionPageState extends State<CompanionPage> {
  String mainDialogue =
      "You're doing so well, I might just have to join you—keep shining!";
  String alternateDialogue =
      "It’s time! Your study session is starting now—let’s get focused!";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF2F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEAF2F5),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Current Companion',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        currentIndex: 3, // Companion tab selected
        onTap: (index) {
          if (index == 0) {
            // TODO: Replace with actual SchedulesPage()
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ClockApp()),
            );
          } else if (index == 2) {
            // TODO: Replace with HomePage()
          } else if (index == 3) {
            // Already on CompanionPage
          } else if (index == 4) {
            // TODO: Replace with PlannerPage()
          }
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: "Schedules"),
          BottomNavigationBarItem(icon: Icon(Icons.wb_sunny), label: "Timer"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Companion"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_view_day), label: "Planner"),
        ],
      ),
    );
  }
}
