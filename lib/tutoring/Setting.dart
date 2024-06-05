import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _oldPhoneNumber = '';
  String _newPhoneNumber = '';

  Future<void> _fetchPhoneNumber(String userId) async {
    // Fetch old phone number from Firestore
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('Students').doc(userId).get();
    setState(() {
      _oldPhoneNumber = snapshot.data()?['phone'] ?? '';
    });
  }

  Future<void> _updatePhoneNumber(String userId) async {
    // Update phone number in Firestore
    await _firestore.collection('Students').doc(userId).update({
      'phone': _newPhoneNumber,
    });
    setState(() {
      _oldPhoneNumber = _newPhoneNumber;
    });
  }

  Future<void> _deleteAccount(String userId) async {
    // Delete user's document from Firestore
    await _firestore.collection('Students').doc(userId).delete();
    // Navigate back to previous screen or handle account deletion
  }

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    // Get the current user
    User? user = _auth.currentUser;
    if (user != null) {
      // Fetch user ID and phone number
      String userId = user.uid;
      await _fetchPhoneNumber(userId);
    } else {
      // User not signed in, handle accordingly
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Current Phone Number: $_oldPhoneNumber'),
            TextField(
              decoration: InputDecoration(
                labelText: 'New Phone Number',
              ),
              onChanged: (value) {
                setState(() {
                  _newPhoneNumber = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                _updatePhoneNumber(_auth.currentUser!.uid);
              },
              child: Text('Update Phone Number'),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteAccount(_auth.currentUser!.uid);
              },
              child: Text('Delete Account'),
            ),
          ],
        ),
      ),
    );
  }
}
