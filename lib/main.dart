import 'package:appwithapi/Cstum/menu.dart';
import 'package:appwithapi/Housing/HousesPage.dart';
import 'package:appwithapi/Housing/addhousepage.dart';
import 'package:appwithapi/Housing/housedetailspage.dart';
import 'package:appwithapi/authForStudent/HouseOwnerLoginPage.dart';
import 'package:appwithapi/authForStudent/HouseOwnerRegistrationPage.dart';
import 'package:appwithapi/authForStudent/ResetPasswordPage.dart';
import 'package:appwithapi/authForStudent/studentLoginPag.dart';
import 'package:appwithapi/authForStudent/studentRegistrationPage.dart';
import 'package:appwithapi/book/addbookpage.dart';
import 'package:appwithapi/book/collegelistpage.dart';
import 'package:appwithapi/book/departmentlistpage.dart';
import 'package:appwithapi/book/displaybookpage.dart';
import 'package:appwithapi/book/exchangebookpage.dart';
import 'package:appwithapi/connectingPage/firstconnetc.dart';
import 'package:appwithapi/connectingPage/secondconnect.dart';
import 'package:appwithapi/connectingPage/Welcomepage.dart';
import 'package:appwithapi/poll/CreateVoteForm.dart';
import 'package:appwithapi/poll/list.dart';
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
        initialRoute: "Welcomepage",
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
          'VotedList': (context) => VotedList(),
          'TeachOrNotScreen': (context) => TeachOrNotScreen(),
          'Secondconnect': (context) => Secondconnect(),
          'Firstconnet': (context) => Firstconnet(),
          'CollegeListPage': (context) => CollegeListPage(),
          ' AddBookPage': (context) => AddBookPage(),
          ' DepartmentListPage': (context) => DepartmentListPage(),
          'ExchangeBookPage': (context) => ExchangeBookPage(),
          'DisplayBookPage': (context) => DisplayBookPage(),
          '/houses': (context) => HousingPage(),
          '/addHouse': (context) => AddHousePage(),
          '/HouseDetailsPage': (context) =>
              DisplayHouseDetailPage(houseDetails: HouseDetails.defaultData()),
          'ResetPasswordPage': (context) => ResetPasswordPage(),
          'houseownerloginpage': (context) => HouseOwnerLoginPage(),
          'houseownerregister': (context) => HouseOwnerRegistrationPage(),
          "Welcomepage": (context) => Welcomepage()
        });
  }
}
