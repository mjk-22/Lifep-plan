
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lifeplan/db/dbsetup.dart';
import 'package:lifeplan/entities/companion.dart';
import 'dart:async';

class FemaleCompanion extends StatefulWidget {
  const FemaleCompanion({super.key});

  @override
  State<FemaleCompanion> createState() => _FemaleCompanionState();
}

class _FemaleCompanionState extends State<FemaleCompanion> {
  Color bgColor = Colors.white;
  int currentIndex = 0;
  LifeplanDatabase db = LifeplanDatabase();
  String success = "";

  Future<List<Companion>> getCompanions() async{
    List<Companion> list = await db.readCompanion('female');
    return list;
  }

  void addCompanionToUserAccount() async{

    if (bgColor == Colors.blueGrey) {

      List<Companion> companions = await getCompanions();
      Companion chosenCompanion = companions[currentIndex];
      db.updateAccountCompanion(chosenCompanion);
      success = "";
      Navigator.pushNamed(context, "/home");
    } else {
      setState(() {
        success = "Pick a companion before proceeding!";
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFDCF0F0),

      ),
      backgroundColor: Color(0xFFDCF0F0),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: FutureBuilder<List<Companion>> (
            future: getCompanions(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(),);
              }

              if (snapshot.hasError) {
                return Center(child: Text("Error occured while loading!: ${snapshot.error}"),);
              }

              final companions = snapshot.data!;
              print(companions.length);
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    Text("Meet your new Lifeplan Companion!",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.center,),
                    Text("Click on your desired companion . . .", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),),
                    SizedBox(height:50,),
                    Container(
                      decoration: BoxDecoration(
                          color: Color(0xFFD2E3E3),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),

                      width: double.infinity,
                      height: 550,
                      child:  Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 15 ,0),
                        child: GridView.count(
                          crossAxisCount: 2,
                          children: List.generate(companions.length, (index) {
                            return Center(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      currentIndex = index;
                                      bgColor = Colors.blueGrey;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: currentIndex == index ? bgColor : Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                        border: Border.all(color: Colors.blueGrey, width: 2)
                                    ),
                                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                    height: 250,
                                    width: 115,
                                    child: Image.asset(companions[index].image, fit: BoxFit.contain,),
                                  ),
                                )
                            );
                          }),
                        ),
                      ),
                    ),
                    SizedBox(height: 40,),
                    Text(success, style: TextStyle(color: Colors.red),),
                    SizedBox(height: 10,),
                    _button("Next", Colors.black, Colors.white, () {addCompanionToUserAccount();})
                  ],
                ),);
            }
        ),
      ),
    );
  }

  Widget _button(message, buttonColor, textColor, void Function() action) {
    return Container(
      height: 50,
      width: 250,
      decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 3,
                offset: Offset(0, 4)
            )
          ]
      ),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              elevation: 0
          ),
          onPressed: action,
          child: Text(message, style: TextStyle(color: textColor, fontSize: 17),)
      ),
    );
  }
}
