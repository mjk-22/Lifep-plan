import 'package:flutter/material.dart';
import 'package:lifeplan/db/dbsetup.dart';
import 'package:lifeplan/entities/account.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  LifeplanDatabase db = LifeplanDatabase();
  String success = "";
  Color successColor = Colors.black;

  Future<void> validityOfAccount() async {
    bool valid = await db.login(emailController.text, passwordController.text);

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() {
        success = 'Please enter a valid input!';
        successColor = Colors.red;
      });
    } else {
      if (valid) {
        success = '';

        Navigator.pushNamed(context, '/home');
      } else {
        setState(() {
          success = 'Invalid account!';
          successColor = Colors.red;
        });
      }
    }
  }

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
              "Login Here",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Log back in and lets get back on track!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
              child: Column(
                children: [
                  _inputField(emailController, "Email", false),
                  SizedBox(
                    height: 20,
                  ),
                  _inputField(passwordController, "Password", true),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () async{
                            bool sent = await db.forgottenPassword(emailController.text);
                            if (sent) {
                              forgottenPasswordDialog();
                            } else {
                              success = 'Invalid Email account';
                              successColor = Colors.red;
                            }
                          },
                          child: Text(
                            "Forgot your password?",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          )),
                    ],
                  ),
                  SizedBox(height: 50),
                  Text(
                    success,
                    style: TextStyle(color: successColor),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _button("Sign in", Colors.black, Color(0xFFEEFFFF),
                      validityOfAccount),
                  SizedBox(
                    height: 20,
                  ),
                  _button(
                    "Create new Account",
                    Color(0xFFEEFFFF),
                    Colors.black,
                        () async {
                      Navigator.pushNamed(context, '/createaccount');
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField(controller, message, obscure) {
    return Container(
      height: 40,
      width: 300,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 3,
            offset: Offset(0, 4))
      ]),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            labelStyle: TextStyle(color: Colors.grey),
            labelText: message,
            fillColor: Color(0xFFEEFFFF),
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide.none)),
        obscureText: obscure,
      ),
    );
  }

  Widget _button(
      message, buttonColor, textColor, Future<void> Function() action) {
    return Container(
      height: 40,
      width: 250,
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
          onPressed: () async {
            await action();
          },
          child: Text(
            message,
            style: TextStyle(color: textColor, fontSize: 17),
          )),
    );
  }

  void forgottenPasswordDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Colors.white,
              title: Text("Reset Password"),
              content: Container(
                height: 100,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        "A password reset link was sent to your email account!"),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(width: 10,),
                        Container(
                          height: 30,
                          width: 115,
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
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Received",
                                style: TextStyle(color: Colors.white, fontSize: 15),
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ));
        });
  }
}