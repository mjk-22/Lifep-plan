import 'package:flutter/material.dart';

class CompanionGender extends StatefulWidget {
  const CompanionGender({super.key});

  @override
  State<CompanionGender> createState() => _CompanionGenderState();
}

class _CompanionGenderState extends State<CompanionGender> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDCF0F0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Pick your companion", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
            Text("Take a moment, and pick wisely . . .", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),),
            SizedBox(height: 30,),
            _button("Feminine Features", Colors.black, Colors.white, () {Navigator.pushNamed(context, '/fem');}),
            SizedBox(height: 15,),
            _button("Masculine Features", Colors.black, Colors.white, () {Navigator.pushNamed(context, '/masc');})
          ],
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