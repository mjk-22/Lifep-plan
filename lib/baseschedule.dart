import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

void main() {
  runApp(ThirdPage());
}

class ThirdPage extends StatelessWidget {
  const ThirdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? selectedDay;
  String? selectedTime1;
  String? selectedTime2;
  TextEditingController startController = TextEditingController(text: "00:00");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFDCF0F0),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 150,
              ),
              Text(
                "Your base schedule",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              SizedBox(
                height: 10,
              ),
              Text("Enter your everyday schedule . . .",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              SizedBox(
                height: 60,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    border: Border.all(color: Colors.black)),
                width: 250,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 50,
                        width: 250,
                        child: DropdownButton<String>(
                            dropdownColor: Color(0xFFEAF8F8),
                            icon: Icon(
                              Icons.expand_more,
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(5),
                            underline: Container(
                              height: 1,
                              color: Colors.black,
                            ),
                            value: selectedDay,
                            hint: Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Select a Day"),
                                SizedBox(
                                  width: 120,
                                )
                              ],
                            ),
                            items: [
                              'Monday',
                              'Tuesday',
                              'Wednesday',
                              'Thursday',
                              'Friday',
                              'Saturday',
                              'Sunday'
                            ].map((day) {
                              return DropdownMenuItem<String>(
                                value: day,
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Text(
                                        day,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newDay) {
                              setState(() {
                                selectedDay = newDay;
                              });
                            }),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: 25,
                        height: 25,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius:
                            BorderRadius.all(Radius.circular(100))),
                        child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              _createEvent(context);
                            },
                            icon:
                            Icon(Icons.add, color: Colors.black, size: 15)),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  void _createEvent(BuildContext context) {
    showDialog(

        context: context,
        builder: (context) {
          return SizedBox(
            child: AlertDialog(
              backgroundColor: Colors.white,
              title: Text("Add Event"),
              content: Container(
                height: 35,
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Start:", style: TextStyle(fontSize: 20),),
                    SizedBox(width: 10,),
                    Container(
                      height: 200,
                      width: 70,
                      child: TextFormField(
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          MaskTextInputFormatter(mask: '##:##')
                        ],
                        decoration: InputDecoration(

                          labelText: "00:00",
                          labelStyle: TextStyle(color: Colors.black),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),

                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)
                          ),

                        ),
                      ),
                    ),
                    _dropdown(selectedTime1, (newTime) {
                      setState(() {
                        selectedTime1 = newTime;
                      });
                    })
                    //here
                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  Widget _dropdown(time, void Function(String?) onChanged) {
    return DropdownButton<String>(
        dropdownColor: Colors.white,
        icon: Icon(
          Icons.expand_more,
          color: Colors.black,
        ),
        borderRadius: BorderRadius.circular(5),
        elevation: 0,
        value: time,
        hint: Row(
          children: [
            Text("AM"),
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
                        fontSize: 12,),
                  )
                ],
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged
    );
  }

}
