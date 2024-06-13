import 'package:appwithapi/Cstum/menu.dart';
import 'package:appwithapi/authForStudent/studentLoginPag.dart';
import 'package:appwithapi/authForStudent/studentRegistrationPage.dart';
import 'package:appwithapi/connectingPage/firstconnetc.dart';
import 'package:appwithapi/connectingPage/secondconnect.dart';
import 'package:appwithapi/poll/CreateVoteForm.dart';
import 'package:appwithapi/poll/list.dart';
import 'package:appwithapi/poll/votelist.dart';
import 'package:appwithapi/poll/voting.dart';
import 'package:appwithapi/tutoring/Setting.dart';
import 'package:appwithapi/tutoring/ThechingOrNot.dart';
import 'package:appwithapi/tutoring/WanttoTech.dart';
import 'package:appwithapi/tutoring/fltring.dart';
import 'package:appwithapi/tutoring/homepage.dart';
import 'package:appwithapi/tutoring/profile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student LoginPage',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/ LoginStateless',
      routes: {
        '/ LoginStateless': (context) => StudentLoginPage(),
        '/ StudentrRegistrationPage': (context) => StudentRegistrationPage(),
        '/Home': (context) => Home(),
        'ProfileScreen': (context) => ProfileScreen(),
        'SettingForStudents': (context) => SettingsPage(),
        'StudentsWhoWantToTeachScreen': (context) =>
            StudentsWhoWantToTeachScreen(),
        "Menu": (context) => Menu(),
        "Fitring": (context) => Fitring(),
        'Dashboured': (context) => Dashboured(),
        'VotingScreen': (context) => VotingScreen(),
        'CreateVoteForm': (context) => CreateVoteForm(),
        "VoteList": (context) => VoteList(),
        'VotedList': (context) => VotedList(),
        'TeachOrNotScreen': (context) => TeachOrNotScreen(),
        'Secondconnect': (context) => Secondconnect(),
        'Firstconnet': (context) => Firstconnet()
      },
    );
  }
}
