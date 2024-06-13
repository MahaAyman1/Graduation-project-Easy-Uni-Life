import 'package:appwithapi/Cstum/constant.dart';
import 'package:appwithapi/Cstum/menu.dart';
import 'package:appwithapi/Cstum/widgitforconnect.dart';
import 'package:flutter/material.dart';

class Secondconnect extends StatelessWidget {
  const Secondconnect({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6F3F3),
      appBar: AppBar(
          title: Text(
            "Let's Study",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: kPrimaryColor,
          iconTheme: IconThemeData(color: Colors.white)),
      body: SafeArea(
        child: Center(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 50),
            children: [
              SizedBox(height: 100),
              buildButton(context, 'images/t4.jpg', 'Toutring', "Fitring"),
              // SizedBox(height: 30),
              buildButton(
                  context, 'images/g2.jpg', 'Study With Me', 'VotedList'),
            ],
          ),
        ),
      ),
      drawer: Menu(),
    );
  }
}
