import 'package:flutter/material.dart';
import 'package:lifeplan/db/dbsetup.dart';
import 'package:lifeplan/entities/account.dart';
import 'package:lifeplan/entities/event.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PlannerPage extends StatefulWidget {
  const PlannerPage({super.key});

  @override
  State<PlannerPage> createState() => _PlannerPageState();
}

class _PlannerPageState extends State<PlannerPage> {
  LifeplanDatabase db = LifeplanDatabase();
  List<String> navPages = [
    '/timer',
    '/home',
    '/planner',
    '/companion'
  ];

  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  Future<void> updateEvent(Function(String) updateSuccess, Event oldEvent) async {
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


        await db.updateAccountEvent(oldEvent, newEvent);

        updateSuccess("Event Modified!");
      } catch (e) {
        updateSuccess("Invalid time format!");
      }

    } else {
      updateSuccess("Fill out everything");
    }
  }

  int currentIndex = 2;
  String? selectedStart;
  String? selectedEnd;

  void _tappedItem(int index) {
    setState(() {
      currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: db.readAccount(),
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
              title: Text("Your Current Events"),
              centerTitle: true,
            ),
            drawer: drawer(),
            bottomNavigationBar: bottomNav(currentIndex),
            backgroundColor: Color(0xFFDCF0F0),
            body: GridView.count(
              crossAxisCount: 1,
              children: List.generate(userAccount.events?.length ?? 0, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 92, horizontal: 20),
                  child: Container(

                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(userAccount.events![index].title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Start Time", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                            SizedBox(width: 20,),
                            Text(DateFormat('h:mm a').format(userAccount.events![index].startTime), style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20, color: Colors.white)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("End Time", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                            SizedBox(width: 20,),
                            Text(DateFormat('h:mm a').format(userAccount.events![index].endTime), style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20, color: Colors.white)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Location", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                            SizedBox(width: 20,),
                            TextButton(
                              onPressed: () {
                                viewLocation(context, userAccount.events![index].location, "AIzaSyB5-Sqwn0_67M1gulBa5MgQK43gfA7Xf3o");
                              },
                              child: Text(userAccount.events![index].location, style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20, color: Colors.white, decoration: TextDecoration.underline, decorationColor: Colors.white)),),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text("Created:${DateFormat('EEE MMMM d y').format(userAccount.events![index].startTime)}", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14, color: Colors.white)),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    startController.text = DateFormat('h:mm').format(userAccount.events![index].startTime);
                                    endController.text = DateFormat('h:mm').format(userAccount.events![index].endTime);
                                    titleController.text = userAccount.events![index].title;
                                    locationController.text = userAccount.events![index].location;
                                    createDialog(context, userAccount.events![index]);
                                  },
                                  icon: Icon(Icons.edit_calendar_outlined, color: Colors.white),
                                ),
                                IconButton(
                                  onPressed: () async{
                                    await db.deleteEvent(userAccount.events![index]);
                                    setState(() {});
                                  },
                                  icon: Icon(Icons.delete, color: Colors.white),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }),
            ),

          );

        }
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

  Future<void> createDialog(BuildContext context, Event oldEvent) async{
    String dialogSuccessMsg = "";
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: Color(0xFFE3FFFF),
              title: Text("Modify Event"),
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
                    await updateEvent((message) {
                      setStateDialog(() {
                        dialogSuccessMsg = message;
                      });

                      if (message == "Event Modified!") {
                        Navigator.pop(context);
                        setState(() {});
                      }
                    }, oldEvent);
                  },
                  child: Text("Modify", style: TextStyle(color: Colors.black, fontSize: 18),),
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

  Future<LatLng?> parseLocation(String location, String apiKey) async {
    final latLngPattern = RegExp(r'^-?\d+(\.\d+)?\s*,\s*-?\d+(\.\d+)?$');
    if (latLngPattern.hasMatch(location)) {
      final parts = location.split(',');
      final lat = double.tryParse(parts[0].trim());
      final lng = double.tryParse(parts[1].trim());
      if (lat != null && lng != null) {
        return LatLng(lat, lng);
      }
    }

    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(location)}&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    final json = jsonDecode(response.body);
    if (json['status'] == 'OK') {
      final lat = json['results'][0]['geometry']['location']['lat'];
      final lng = json['results'][0]['geometry']['location']['lng'];
      return LatLng(lat, lng);
    }

    return null;
  }


  void viewLocation(BuildContext context, String location, String apiKey) async{
    final latLocation = await parseLocation(location, apiKey);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Event Location'),
          content: latLocation != null
              ? Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
                color: Colors.blue[100]
            ),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: latLocation,
                zoom: 15,
              ),
              markers: {
                Marker(markerId: MarkerId('location'), position: latLocation),
              },
            ),
          )
              : SizedBox(
            width: 300,
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Enter real coordinates to view your event location on a map!", style: TextStyle(fontSize: 20, color: Colors.blueGrey)),
                SizedBox(height: 10,),
                Text("Result: ${location}", style: TextStyle(fontSize: 16, color: Colors.blueGrey, fontWeight: FontWeight.bold)),
              ],
            ),
          ), // fallback text
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Close')),
          ],
        );
      },
    );
  }
}