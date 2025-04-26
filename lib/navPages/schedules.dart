import 'package:flutter/material.dart';

class SchedulesPage extends StatefulWidget {
  const SchedulesPage({super.key});

  @override
  State<SchedulesPage> createState() => _SchedulesPageState();
}

class _SchedulesPageState extends State<SchedulesPage> {
  List<String> navPages = [
    '/schedules',
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
          ),
        title: Text("Previous Events"),
        centerTitle: true,
      ),
      drawer: drawer(),
      bottomNavigationBar: bottomNav(currentIndex),
      backgroundColor: Color(0xFFDCF0F0),
      body: GridView.count(
        // Create a grid with 2 columns.
        // If you change the scrollDirection to horizontal,
        // this produces 2 rows.
        crossAxisCount: 2,
        // Generate 100 widgets that display their index in the list.
        children: List.generate(10, (index) {
          return Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blueGrey,
              ),
                width: 200,
              height: 200,
              margin: EdgeInsets.all(10),
              child: Center(
                child: Text("2019-2020", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 30, color: Colors.white),),
              ),
            ),
          );
        }),
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
              onTap: () {
                Navigator.pushNamed(context, '/adduser');
              },
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
              onTap: () {
                Navigator.pushNamed(context, '/shop');
              },
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
}
