import 'package:flutter/material.dart';
import 'package:lifeplan/validateInput/Validation.dart';
import 'package:lifeplan/db/dbsetup.dart';


class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  LifeplanDatabase db = new LifeplanDatabase();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  String success = '';
  Color successColor = Colors.black;

  bool validInput(){
    return (emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty && confirmController.text.isNotEmpty);
  }

  Future<void>? inputSuccess() async{
    if (!validInput()) {
      setState(() {
        success = 'Please fill all fields!';
        successColor = Colors.red;
      });
      return;
    }

    if (!Validation.validPasswordLength(passwordController.text)) {
      setState(() {
        success = 'Password needs to contain minimum 12 characters!';
        successColor = Colors.red;
      });
      return;
    }

    if (!Validation.validConfirmPassword(passwordController.text, confirmController.text)) {
      setState(() {
        success = 'Passwords do not match!';
        successColor = Colors.red;
      });
      return;
    }

    bool codeSent = await db.registerAndSendCode(emailController.text, passwordController.text);
    setState(() {
      if (codeSent) {
        success = 'A verification code was sent to your email';
        successColor = Colors.green;
      } else {
        success = 'Invalid Input!';
        successColor = Colors.red;
      }
    });
  }

  Future<void> verifiedAccount() async{
    bool verified = await db.verifyUserAndAdd();

    if (verified) {
      Navigator.pushNamed(context, '/companiongender');
    } else {
      setState(() {
        success = 'Email has not been validated!';
        successColor = Colors.red;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDCF0F0),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 150,),
            Text("Create Account", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
            SizedBox(height: 15,),
            SizedBox(
              width: 300,
              child: Text("Create an account to get started. It’s quick and easy!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15), textAlign: TextAlign.center,),
            ),
            SizedBox(height: 50,),
            Padding(
              padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
              child: Column(
                children: [
                  _inputField(emailController, "Email", false),
                  SizedBox(height: 20,),
                  _inputField(passwordController, "Password", true),
                  SizedBox(height: 20,),
                  _inputField(confirmController, "Confirm Password", true),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: verifiedAccount,
                          child: Text("Check Email Verification", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),)
                      ),
                    ],
                  ),
                  SizedBox(height: 15,),
                  Text(success, style: TextStyle(color: successColor, fontWeight: FontWeight.w500), textAlign: TextAlign.center,),
                  SizedBox(height: 20,),
                  _button("Sign Up", Colors.black, Color(0xFFEEFFFF), 17.0, inputSuccess),
                  SizedBox(height: 20,),
                  _button("Already have an account?",Color(0xFFEEFFFF), Colors.black, 13.0, () {Navigator.pushNamed(context, '/login');})
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

  Widget _button(message, buttonColor, textColor, textSize, void Function() function) {
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
          onPressed: function,
          child: Text(message, style: TextStyle(color: textColor, fontSize: textSize),)
      ),
    );
  }

}
