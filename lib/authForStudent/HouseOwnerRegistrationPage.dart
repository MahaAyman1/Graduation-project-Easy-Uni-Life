import 'package:appwithapi/Cstum/constant.dart';
import 'package:appwithapi/Cstum/customTextField.dart';
import 'package:appwithapi/authForStudent/Verify.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HouseOwnerRegistrationPage extends StatefulWidget {
  const HouseOwnerRegistrationPage({Key? key}) : super(key: key);

  @override
  _HouseOwnerRegistrationPageState createState() =>
      _HouseOwnerRegistrationPageState();
}

class _HouseOwnerRegistrationPageState
    extends State<HouseOwnerRegistrationPage> {
  late TextEditingController firstNameController = TextEditingController();
  late TextEditingController lastNameController = TextEditingController();
  late TextEditingController nationalNumberController = TextEditingController();
  late TextEditingController phoneNumberController = TextEditingController();
  late TextEditingController emailController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    nationalNumberController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> registerUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        String firstName = firstNameController.text;
        String lastName = lastNameController.text;
        String nationalNumber = nationalNumberController.text;
        String phoneNumber = phoneNumberController.text;
        String email = emailController.text;
        String password = passwordController.text;

        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String userId = userCredential.user!.uid;

        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'firstName': firstName,
          'lastName': lastName,
          'nationalNumber': nationalNumber,
          'phoneNumber': phoneNumber,
          'email': email,
          'password': password
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => VerifyScreen()),
        );
      } catch (e) {
        print('Registration failed: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text(
            'House Owner Registration',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 40),
                  CustomTextField(
                    hint: 'First Name',
                    controller: firstNameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    hint: 'Last Name',
                    controller: lastNameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    hint: 'National Number',
                    controller: nationalNumberController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your national number';
                      }
                      if (value.length != 10) {
                        return 'National Number must be exactly 10 digits';
                      }
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'National Number must contain only digits';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    hint: 'Phone Number',
                    controller: phoneNumberController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (value.length != 10) {
                        return 'Phone number must be 10 digits long';
                      }
                      if (!['079', '078', '077']
                          .any((prefix) => value.startsWith(prefix))) {
                        return 'Phone number must start with 079, 078 or 077';
                      }

                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'phone Number must contain only digits';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    hint: 'Email',
                    controller: emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    hint: 'Password',
                    obscureText: true,
                    controller: passwordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      } else if (!RegExp(
                              r'^(?=.?[a-z])(?=.?[A-Z])(?=.*?[0-9]).{6,}$')
                          .hasMatch(value)) {
                        return 'Password must contain at least one uppercase letter,\n one lowercase letter, and one digit';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 60),
                  Center(
                    child: SizedBox(
                      width: 170,
                      child: ElevatedButton(
                        onPressed: registerUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
