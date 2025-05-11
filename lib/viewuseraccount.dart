import 'package:flutter/material.dart';
import 'package:lifeplan/db/dbsetup.dart';
import 'package:lifeplan/entities/account.dart';

class ViewAccount extends StatefulWidget {
  const ViewAccount({super.key});

  @override
  State<ViewAccount> createState() => _ViewAccountState();
}

class _ViewAccountState extends State<ViewAccount> {
  LifeplanDatabase db = LifeplanDatabase();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController notificationController = TextEditingController();
  TextEditingController companionController = TextEditingController();

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

          emailController.text = userAccount.email.toString();
          usernameController.text = userAccount.username!;
          notificationController.text = userAccount.isNotificationOn == false ? "Off" : "On";
          companionController.text = userAccount.companion!.name;

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
                  Text("Your Account", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.blueGrey),),
                  Icon(Icons.account_circle_rounded, color: Colors.blueGrey, size: 130,),
                  Text(userAccount.username!,style: TextStyle(fontSize: 25, color: Colors.black),),
                  SizedBox(height: 30,),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        color: Colors.white60,
                      ),
                      padding: EdgeInsets.all(10),
                      width: 300,
                      height: 370,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 40,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Email Address:"),
                            SizedBox(
                              height: 30,
                              width: 150,
                              child: TextFormField(
                                controller: emailController,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  contentPadding:  EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                            SizedBox(height: 40,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("username:"),
                                SizedBox(
                                  height: 30,
                                  width: 150,
                                  child: TextFormField(
                                    controller: usernameController,
                                    cursorColor: Colors.black,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      contentPadding:  EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                            ),
                            SizedBox(height: 40,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Notifications:"),
                                SizedBox(
                                  height: 30,
                                  width: 150,
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: notificationController,
                                    cursorColor: Colors.black,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      contentPadding:  EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      labelText: "notification",
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
                            SizedBox(height: 40,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Companion:"),
                                SizedBox(
                                  height: 30,
                                  width: 150,
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: companionController,
                                    cursorColor: Colors.black,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      contentPadding:  EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      labelText: 'name',
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
                      )

                  ),
                  SizedBox(height: 40,),
                  Container(
                    height: 40,
                    width: 140,
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
                        onPressed: ()async{
                          await db.updateAccountUsername(usernameController.text);
                          setState(() {});
                        },
                        child: Text(
                          "Save",
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        )),
                  ),
                  SizedBox(height: 60,)
                ],
              ),
            ),
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
}
