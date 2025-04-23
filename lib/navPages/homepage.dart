import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController startController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController endController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  int currentIndex = 3;
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
      bottomNavigationBar: bottomNav(currentIndex),
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
            )),
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
                        _button("Create Event", Colors.black, Colors.white),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Add a new event",
                          style: TextStyle(fontSize: 20),
                        )
                      ],
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
        onTap: _tappedItem,
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

  Widget _button(message, buttonColor, textColor) {
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

            });
          },
          child: Text(
            message,
            style: TextStyle(color: textColor, fontSize: 17),
          )),
    );
  }

  Future<void> createDialog(BuildContext context) async{
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
                    Text("Date:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                    SizedBox(height: 5),
                    SizedBox(
                      height: 40,
                      width: 250,
                      child: TextFormField(
                        controller: dateController,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          MaskTextInputFormatter(mask: '##/##/##'),
                        ],
                        decoration: InputDecoration(
                          labelText: "mm/dd/yy",
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
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {

                    Navigator.pop(context);
                  },
                  child: Text("Create", style: TextStyle(color: Colors.black),),
                ),
                TextButton(
                  onPressed: () {

                    Navigator.pop(context);
                  },
                  child: Text("Cancel", style: TextStyle(color: Colors.black)),
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
