import 'package:appwithapi/Cstum/constant.dart';
import 'package:appwithapi/Cstum/menu.dart';
import 'package:appwithapi/Cstum/widgitforconnect.dart';
import 'package:flutter/material.dart';

class Firstconnet extends StatelessWidget {
  const Firstconnet({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6F3F3),
      appBar: AppBar(
          title: Text(
            'Home',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: kPrimaryColor,
          iconTheme: IconThemeData(color: Colors.white)),
      body: SafeArea(
        child: Center(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 50),
            children: [
              //  SizedBox(height: 100),
              buildButton(
                  context, 'images/1.jpg', 'Housing', "ForgotPasswordScreen"),
              //  SizedBox(height: 30),
              buildButton(context, 'images/e2.jpg', 'Exchang Book',
                  'ResetPasswordPage'),
              //'CollegeListPage'),
              buildButton(
                  context, 'images/y2.jpg', "Let's Study", 'Secondconnect')
            ],
          ),
        ),
      ),
      drawer: Menu(),
    );
  }
}
