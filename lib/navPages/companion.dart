import 'package:flutter/material.dart';
import 'package:lifeplan/db/dbsetup.dart';
import 'package:lifeplan/entities/account.dart';
import 'package:lifeplan/entities/companion.dart';


// Main Companion Page
class CompanionPage extends StatefulWidget {
  const CompanionPage({super.key});

  @override
  State<CompanionPage> createState() => _CompanionPageState();
}

class _CompanionPageState extends State<CompanionPage> {
  LifeplanDatabase db = LifeplanDatabase();

  List<String> navPages = [
    '/timer',
    '/home',
    '/planner',
    '/companion'
  ];
  int currentIndex = 3;
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
    return FutureBuilder
      (future: db.readAccount(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(
                    strokeWidth: 4,
                    color: Color(0xFFDCF0F0)
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Text("null");
          }

          Account userAccount = snapshot.data!;

          return Scaffold(
              drawer: drawer(),
              backgroundColor: const Color(0xFFEAF2F5),
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
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      "CURRENT COMPANION",
                      style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      userAccount.companion?.name != null ? userAccount.companion!.name : "Unavailable",
                      style: const TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),

                    const SizedBox(height: 20),
                    Center(

                        child:userAccount.companion != null ?
                        Image.asset(userAccount.companion!.image, height: 530,) :
                        Text("No Companion Available", style: TextStyle(fontSize: 20, color: Colors.blueGrey),)
                    ),

                    // Shop Button
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/companiongender');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Change Companion',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
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
}