import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDCF0F0),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 150,),
            Text("Login Here", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
            SizedBox(height: 15,),
            Text("Log back in and lets get back on track!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
            SizedBox(height: 50,),
            Padding(
                padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
              child: Column(
                children: [
                  _inputField(emailController, "Email", false),
                  SizedBox(height: 20,),
                  _inputField(passwordController,"Password", true),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {},
                          child: Text("Forgot your password?", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),)
                      ),
                    ],
                  ),
                  SizedBox(height: 40,),
                  _button("Sign in", Colors.black, Color(0xFFEEFFFF), () {}),
                  SizedBox(height: 20,),
                  _button("Create new Account",Color(0xFFEEFFFF), Colors.black, () {Navigator.pushNamed(context, '/createaccount');})
                ],
              ),
            ),
            SizedBox(height: 50,),
            Text("Or continue with", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
            SizedBox(height: 10),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Color(0xFFEEFFFF),
                borderRadius: BorderRadius.circular(5)
              ),
              child: Padding(
                  padding: EdgeInsets.all(5),
                child: Image.asset("assets/google.png", width: 10, height: 10,),
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
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 3,
                offset: Offset(0, 4)
            )
          ]
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelStyle: TextStyle(color: Colors.grey),
            labelText: message,
            fillColor: Color(0xFFEEFFFF),
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide.none
            )
        ),
        obscureText: obscure,
      ),
    );
  }

  Widget _button(message, buttonColor, textColor, void Function() action) {
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


