import 'package:flutter/material.dart';
import 'package:lifeplan/entities/event.dart';
import 'dart:async';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:lifeplan/db/dbsetup.dart';
import 'package:lifeplan/entities/account.dart';

class NavPage extends StatefulWidget {
  const NavPage({super.key});

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  LifeplanDatabase db = LifeplanDatabase();
  List<String> navPages = [
    '/schedules',
    '/timer',
    '/home',
    '/planner',
    '/companion'
  ];

  int currentIndex = 2;
  String? selectedStart;
  String? selectedEnd;

  void _tappedItem(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  Future<void> createEvent(Function(String) updateSuccess) async {
    if (startController.text.isNotEmpty &&
        endController.text.isNotEmpty &&
        titleController.text.isNotEmpty &&
        locationController.text.isNotEmpty &&
        selectedStart != null &&
        selectedEnd != null) {

      try {

        List<String> parsedStart = startController.text.split(":");
        int startHour = int.parse(parsedStart[0]);
        int startMin = int.parse(parsedStart[1]);

        List<String> parsedEnd = endController.text.split(":");
        int endHour = int.parse(parsedEnd[0]);
        int endMin = int.parse(parsedEnd[1]);


        if (selectedStart == "PM" && startHour < 12) startHour += 12;
        if (selectedStart == "AM" && startHour == 12) startHour = 0;

        if (selectedEnd == "PM" && endHour < 12) endHour += 12;
        if (selectedEnd == "AM" && endHour == 12) endHour = 0;

        DateTime now = DateTime.now();
        DateTime startTime = DateTime(now.year, now.month, now.day, startHour, startMin);
        DateTime endTime = DateTime(now.year, now.month, now.day, endHour, endMin);


        if (endTime.isBefore(startTime) || endTime.isAtSameMomentAs(startTime)) {
          updateSuccess("Enter a valid time range!");
          return;
        }

        Event newEvent = Event(
          startTime: startTime,
          endTime: endTime,
          title: titleController.text,
          location: locationController.text,
        );
        await db.addEvent(newEvent);

        updateSuccess("New event added!");
      } catch (e) {
        updateSuccess("Invalid time format!");
      }

    } else {
      updateSuccess("Fill out everything");
    }
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
            )
        ),
        bottomNavigationBar: bottomNav(currentIndex),
        backgroundColor: Color(0xFFDCF0F0),
        drawer: drawer(),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: 170,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Good Morning, Username",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                              ),
                              Text(
                                "\"Success is built one step at a time - stay consistent, keep pushing and your hard work will pay off\"",
                                style: TextStyle(fontSize: 15),
                                textAlign: TextAlign.left,
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: 200,
                          child: Image.asset(
                            'assets/homepage.png',
                            fit: BoxFit.cover,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        _button("Create Event", Colors.black, Colors.white, () {}),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Add a new event",
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 70,
                    ),
                    Row(
                      children: [
                        Text(
                          "Current Points",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                Container(
                  height: 40,
                  width: 170,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 3,
                            offset: Offset(0, 4))
                      ]),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black, elevation: 0),
                      onPressed: (){},
                      child: Text(
                        "100 points",
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      )),
                )
                      ],
                    ),
                    SizedBox(height: 100,),
                    Container(
                      color: Colors.blueGrey,
                      height: 2,
                      width: 400,
                    ),
                    SizedBox(height: 70,),
                    Container(
                      height: 40,
                      width: 170,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 3,
                                offset: Offset(0, 4))
                          ]),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black, elevation: 0),
                          onPressed: (){},
                          child: Text(
                            "Your Events",
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          )),
                    ),
                    SizedBox(height: 10,),
                    Text(
                      "Complete your task to earn points and level up your progress!",
                      style: TextStyle(fontSize: 20), textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
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
    Container(
    height: 1.0,
    color: Colors.blueGrey,
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

  Widget _button(message, buttonColor, textColor, void Function() function) {
    return Container(
      height: 40,
      width: 170,
      decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 3,
                offset: Offset(0, 4))
          ]),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor, elevation: 0),
          onPressed: () async{
            await createDialog(context);
            setState(() {
              function();
            });
          },
          child: Text(
            message,
            style: TextStyle(color: textColor, fontSize: 17),
          )),
    );
  }

  Future<void> createDialog(BuildContext context) async{
    String dialogSuccessMsg = "";
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: Color(0xFFE3FFFF),
              title: Text("Create Event"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text("Title:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                    SizedBox(height: 5),
                    SizedBox(
                      height: 40,
                      width: 250,
                      child: TextFormField(
                        controller: titleController,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.black),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text("Location:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                    SizedBox(height: 5),
                    SizedBox(
                      height: 40,
                      width: 250,
                      child: TextFormField(
                        controller: locationController,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.black),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15,),
                    Text("Start Time:",style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        SizedBox(
                          height: 40,
                          width: 250,
                          child: TextFormField(
                            controller: startController,
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              MaskTextInputFormatter(mask: '##:##'),
                            ],
                            decoration: InputDecoration(
                              labelText: "00:00",
                              labelStyle: TextStyle(color: Colors.black),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              suffixIcon: _dropdown(selectedStart, (newValue) {
                                setStateDialog(() {
                                  selectedStart = newValue!;
                                });
                              }),
                            ),

                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Text("End Time:",style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        SizedBox(
                          height: 40,
                          width: 250,
                          child: TextFormField(
                            controller: endController,
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              MaskTextInputFormatter(mask: '##:##'),
                            ],
                            decoration: InputDecoration(

                              labelText: "00:00",
                              labelStyle: TextStyle(color: Colors.black),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              suffixIcon: _dropdown(selectedEnd, (newValue) {
                                setStateDialog(() {
                                  selectedEnd = newValue!;
                                });
                              }),
                            ),
                          ),
                        ),


                      ],
                    ),
                    SizedBox(height: 25,),
                    Align(
                      alignment: Alignment.center,
                      child: Text(dialogSuccessMsg),
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async{
                    await createEvent((message) {
                      setStateDialog(() {
                        dialogSuccessMsg = message;
                      });
                    });
                  },
                  child: Text("Create", style: TextStyle(color: Colors.black, fontSize: 18),),
                ),
                TextButton(
                  onPressed: () {

                    Navigator.pop(context);
                  },
                  child: Text("Cancel", style: TextStyle(color: Colors.black, fontSize: 18)),
                ),
              ],
            );
          },

        );
      },
    );
  }


  Widget _dropdown(time, void Function(String?) onChanged) {
    return DropdownButton<String>(
        underline: Container(
          height: 1,
          color: Color(0xFFE3FFFF),
        ),
        dropdownColor: Colors.white,
        icon: SizedBox.shrink(),
        borderRadius: BorderRadius.circular(5),
        value: time,
        hint: Row(
          children: [
            Text("AM "),
          ],
        ),
        items: [
          'AM',
          'PM',
        ].map((selectedTime) {
          return DropdownMenuItem<String>(
            value: selectedTime,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Text(
                    selectedTime,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                    ),
                  )
                ],
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged);
  }
}

