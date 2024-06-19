/*
import 'package:appwithapi/Cstum/DropdownButton.dart';
import 'package:appwithapi/Cstum/constant.dart';
import 'package:appwithapi/Cstum/customTextField.dart';
import 'package:appwithapi/authForStudent/Verify.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentRegistrationPage extends StatefulWidget {
  const StudentRegistrationPage({Key? key}) : super(key: key);

  @override
  _StudentRegistrationPageState createState() =>
      _StudentRegistrationPageState();
}

class _StudentRegistrationPageState extends State<StudentRegistrationPage> {
  late TextEditingController firstNameController = TextEditingController();
  late TextEditingController lastNameController = TextEditingController();
  late TextEditingController IDNumberController = TextEditingController();
  late TextEditingController phoneNumberController = TextEditingController();
  late TextEditingController emailController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();
  String? _selectedGender;
  DateTime? _selectedDate;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    IDNumberController.dispose();
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
        String IDNumber = IDNumberController.text;
        String phoneNumber = phoneNumberController.text;
        String email = emailController.text;
        String password = passwordController.text;

        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String userId = userCredential.user!.uid;

        await FirebaseFirestore.instance
            .collection('Students')
            .doc(userId)
            .set({
          'firstName': firstName,
          'lastName': lastName,
          'IDNumber': IDNumber,
          'phoneNumber': phoneNumber,
          'email': email,
          'password': password,
          'gender': _selectedGender,
          'birthday':
              _selectedDate != null ? Timestamp.fromDate(_selectedDate!) : null,
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
        backgroundColor: Color(0xFFE6F3F3),
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text(
            'Student Registration',
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
                  Text(
                      "Mind sharing a few details with us? We'll need some information!",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111236))),
                  const SizedBox(height: 20),
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
                  GenderDropdownButton(
                    items: ['Male', 'Female'],
                    selectedValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                    hint: 'Select Your gender', 
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                              selectableDayPredicate: (DateTime date) {
                                return true;
                              },
                              builder: (BuildContext context, Widget? child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    colorScheme: ColorScheme.light().copyWith(
                                      primary: kPrimaryColor,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null && picked != _selectedDate) {
                              setState(() {
                                _selectedDate = picked;
                              });
                            }
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              hintText: 'Select your birthday',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              _selectedDate != null
                                  ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                  : 'Select your birthday',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    hint: 'ID ',
                    controller: IDNumberController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your ID ';
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
                      } else if (!value.endsWith('.edu.jo')) {
                        return 'Email must end with .edu.jo domain';
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
                        return 'Password must contain at least one uppercase letter, one lowercase letter, and one digit';
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
*/

import 'package:appwithapi/Cstum/DropdownButton.dart';
import 'package:appwithapi/Cstum/constant.dart';
import 'package:appwithapi/Cstum/customTextField.dart';
import 'package:appwithapi/authForStudent/Verify.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentRegistrationPage extends StatefulWidget {
  const StudentRegistrationPage({Key? key}) : super(key: key);

  @override
  _StudentRegistrationPageState createState() =>
      _StudentRegistrationPageState();
}

class _StudentRegistrationPageState extends State<StudentRegistrationPage> {
  late TextEditingController firstNameController = TextEditingController();
  late TextEditingController lastNameController = TextEditingController();
  late TextEditingController IDNumberController = TextEditingController();
  late TextEditingController phoneNumberController = TextEditingController();
  late TextEditingController emailController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();
  String? _selectedGender;
  DateTime? _selectedDate;
  bool _isDateSelected = true; // Added boolean variable

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    IDNumberController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> registerUser() async {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      try {
        String firstName = firstNameController.text;
        String lastName = lastNameController.text;
        String IDNumber = IDNumberController.text;
        String phoneNumber = phoneNumberController.text;
        String email = emailController.text;
        String password = passwordController.text;

        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String userId = userCredential.user!.uid;

        await FirebaseFirestore.instance
            .collection('Students')
            .doc(userId)
            .set({
          'firstName': firstName,
          'lastName': lastName,
          'IDNumber': IDNumber,
          'phoneNumber': phoneNumber,
          'email': email,
          'password': password,
          'gender': _selectedGender,
          'birthday':
              _selectedDate != null ? Timestamp.fromDate(_selectedDate!) : null,
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => VerifyScreen()),
        );
      } catch (e) {
        print('Registration failed: $e');
      }
    } else if (_selectedDate == null) {
      setState(() {
        _isDateSelected =
            false; // Set the boolean to false to show error message
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFFE6F3F3),
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text(
            'Student Registration',
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
                  Text(
                      "Mind sharing a few details with us? We'll need some information!",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111236))),
                  const SizedBox(height: 20),
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
                  GenderDropdownButton(
                    items: ['Male', 'Female'],
                    selectedValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                    hint: 'Select Your gender',
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                              selectableDayPredicate: (DateTime date) {
                                return true;
                              },
                              builder: (BuildContext context, Widget? child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    colorScheme: ColorScheme.light().copyWith(
                                      primary: kPrimaryColor,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null && picked != _selectedDate) {
                              setState(() {
                                _selectedDate = picked;
                                _isDateSelected =
                                    true; // Reset the boolean to true on date selection
                              });
                            }
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              hintText: 'Select your birthday',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              _selectedDate != null
                                  ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                  : 'Select your birthday',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (!_isDateSelected)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '      Birthday is required',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 167, 29, 19),
                              fontSize: 12),
                        ),
                      ],
                    ),
                  SizedBox(height: 20),
                  CustomTextField(
                    hint: 'ID ',
                    controller: IDNumberController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your ID ';
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
                      if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                        return 'Phone number must contain only digits';
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
                      } else if (!value.endsWith('just.edu.jo')) {
                        return 'Email must end with just.edu.jo domain';
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
                              r'^(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[0-9]).{6,}$')
                          .hasMatch(value)) {
                        return 'Password must contain at least one uppercase letter, one lowercase letter, and one digit';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 60),
                  Center(
                    child: SizedBox(
                      width: 170,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate() &&
                              _selectedDate != null) {
                            registerUser();
                          } else if (_selectedDate == null) {
                            setState(() {
                              _isDateSelected =
                                  false; // Set the boolean to false to show error message
                            });
                          }
                        },
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
