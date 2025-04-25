import 'package:flutter/material.dart';
import 'package:lifeplan/navPages/worldclock.dart';

class ShopCompanionPage extends StatelessWidget {
  const ShopCompanionPage({super.key});

  void _showConfirmationDialog(BuildContext context, String itemName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Purchase"),
          content: Text("Are you sure you want to purchase $itemName?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade700,
              ),
              child: const Text("Confirm"),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("$itemName purchased!"),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildShopItem({
    required BuildContext context,
    required String imageUrl,
    required String title,
    required String subtitle,
    required String buttonLabel,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
              child: Image.network(
                imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: ElevatedButton(
                onPressed: () => _showConfirmationDialog(context, title),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                child: Text(
                  buttonLabel,
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF2F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEAF2F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Companion Shop",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 30),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Text(
              "Earn points to unlock new characters and dialogues! . . .",
              style: TextStyle(fontSize: 13, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Divider(thickness: 1),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: Text("Characters",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
          ),

          _buildShopItem(
            context: context,
            imageUrl:
            "https://t4.ftcdn.net/jpg/06/16/47/93/360_F_616479367_JcdjFpbvTp2H9XhQZxB9HiW1xOpVP5wY.jpg", // Placeholder image
            title: "Character: Lauren Smith",
            subtitle: "Age: 24\nGender: Female",
            buttonLabel: "Purchase",
          ),

          _buildShopItem(
            context: context,
            imageUrl:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRWDsnbRl1g7LhDZxOqm2GMm0Dfa6HWd4pGZTFTmgciACVTjvI25eIyD5s-W-Jw98DuDrA&usqp=CAU", // Placeholder image
            title: "Character: Nathan Leblanc",
            subtitle: "Age: 30\nGender: Male",
            buttonLabel: "Purchase",
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Divider(thickness: 1),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: Text("Dialogues",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
          ),

          _buildShopItem(
            context: context,
            imageUrl:
            "https://static.vecteezy.com/system/resources/thumbnails/026/461/349/small/happy-new-year-motivational-quotes-generative-ai-photo.jpeg", // Placeholder
            title: "Package: Motivation Package",
            subtitle: "Dialogues: 5",
            buttonLabel: "Purchase",
          ),
        ],
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
