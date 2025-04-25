import 'package:flutter/material.dart';

class ViewAccount extends StatefulWidget {
  const ViewAccount({super.key});

  @override
  State<ViewAccount> createState() => _ViewAccountState();
}

class _ViewAccountState extends State<ViewAccount> {
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController notificationController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(),
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
      backgroundColor: Color(0xFFDCF0F0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_circle_rounded, color: Colors.blueGrey, size: 100,),
            Text("USER123",style: TextStyle(fontSize: 25),),
SizedBox(height: 30,),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(10),
              width: 300,
              height: 350,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Email Address"),
                      SizedBox(
                        height: 30,
                        width: 150,
                        child: TextFormField(
                          controller: emailController,
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "email",
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
                    ],
                  ),
                  SizedBox(height: 25,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("username"),
                      SizedBox(
                        height: 30,
                        width: 150,
                        child: TextFormField(
                          controller: emailController,
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "username",
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
                    ],
                  )
                  ,
                  SizedBox(height: 25,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Password"),
                      SizedBox(
                        height: 30,
                        width: 150,
                        child: TextFormField(
                          controller: emailController,
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "password",
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
                    ],
                  )
                  ,
                  SizedBox(height: 25,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Notifications"),
                      SizedBox(
                        height: 30,
                        width: 150,
                        child: TextFormField(
                          controller: emailController,
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Notification On",
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
                    ],
                  )
                  ,
                  SizedBox(height: 25,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Current Points"),
                      SizedBox(
                        height: 30,
                        width: 150,
                        child: TextFormField(
                          controller: emailController,
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "360 points",
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
                    ],
                  ),
                  SizedBox(height: 25,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Current Companion"),
                      SizedBox(
                        height: 30,
                        width: 150,
                        child: TextFormField(
                          controller: emailController,
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Alissa John",
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
                    ],
                  ),

                ],

              ),

            ),
            SizedBox(height: 200,)
          ],
        ),
      ),
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
}
