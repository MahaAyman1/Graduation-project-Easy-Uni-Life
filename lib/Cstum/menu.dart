import 'package:appwithapi/authForStudent/studentLoginPag.dart';
import 'package:appwithapi/tutoring/Setting.dart';
import 'package:appwithapi/tutoring/homepage.dart';
import 'package:appwithapi/tutoring/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  late String userId;

  @override
  void initState() {
    super.initState();
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      userId = currentUser.uid;
    }
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference students =
        FirebaseFirestore.instance.collection('Students');

    return FutureBuilder<DocumentSnapshot>(
      future: students.doc(userId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: Text('User not found'));
        }

        Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;

        String? profileImageUrl = data['profileImageUrl'];
        String? email = data['email'];
        String? firstName = data['firstName'];
        String? lastName = data['lastName'];
        String gender = data['gender'];

        String defaultImageUrl = gender == 'Male'
            ? 'https://i.pinimg.com/564x/22/ce/12/22ce126b77afdd24a5994ecb51736887.jpg'
            : 'https://i.pinimg.com/736x/8b/1f/9f/8b1f9f145889835124f968a6aa82b79f.jpg';

        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  radius: 200,
                  backgroundImage: profileImageUrl != null
                      ? NetworkImage(profileImageUrl) as ImageProvider
                      : NetworkImage(defaultImageUrl),
                ),
                accountEmail: Text(email ?? ''),
                accountName: Text('$firstName $lastName' ?? ''),
                decoration: BoxDecoration(
                  color: Colors.black87,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text(
                  'Setting',
                  style: TextStyle(fontSize: 20.0),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => SettingsPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.house),
                title: const Text(
                  'Home',
                  style: TextStyle(fontSize: 20.0),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const Home(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text(
                  'Profile',
                  style: TextStyle(fontSize: 20.0),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => ProfileScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 20.0),
                ),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => StudentLoginPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
