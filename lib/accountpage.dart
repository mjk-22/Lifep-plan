import 'package:flutter/material.dart';

void main() {
  runApp(SecondScreen());
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AccountPage(),
    );
  }
}

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFCDE7EF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 70,),
            Image.asset('assets/accountpage.png', height: 250,),
            SizedBox(
              width: 350,
              child: Text("Find the planner that fits your life perfectly", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35,), textAlign: TextAlign.justify,),
            ),
            SizedBox(height: 20,),
            SizedBox(
              width: 300,
              child: Text("Explore all available planners tailored to your interests and lifestyle", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
            ),
            SizedBox(height: 80,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 150,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: Offset(0, 6)
                      )
                    ]
                  ),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(35, 10, 35, 10),
                        backgroundColor: Colors.black,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)

                        ),
                      ),
                      onPressed: () {},
                      child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 20),)
                  ),
                ),
                Container(
                  width: 150,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(0, 6)
                        )
                      ]
                  ),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(35, 10, 35, 10),
                        backgroundColor: Color(0xFFDEECF0),
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)

                        ),
                      ),
                      onPressed: () {},
                      child: Text("Register", style: TextStyle(color: Colors.black, fontSize: 20),)
                  ),
                ),

              ],
            )
          ],
        ),
      ),
    );
  }
}

