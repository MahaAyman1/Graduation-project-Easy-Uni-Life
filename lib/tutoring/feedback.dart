import 'package:appwithapi/Cstum/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> _showFeedbackDialog(BuildContext context, String subject) async {
  String feedback = '';
  double rating = 0.0;

  final User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    // Handle user not signed in
    return;
  }

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Feedback and Rating'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              onChanged: (value) {
                feedback = value;
              },
              decoration: InputDecoration(labelText: 'Feedback'),
            ),
            SizedBox(height: 10),
            Slider(
              value: rating,
              onChanged: (newRating) {
                rating = newRating;
              },
              min: 0,
              max: 5,
              divisions: 5,
              label: rating.toString(),
              activeColor: kPrimaryColor,
              inactiveColor: kPrimaryColor,
            ),
            SizedBox(height: 10),
            Text('Rating: $rating'),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(color: kPrimaryColor),
            ),
          ),
          TextButton(
            onPressed: () async {
              // Save feedback and rating to Firestore
              await FirebaseFirestore.instance.collection('Feedback').add({
                'auth': user.uid,
                'subject': subject,
                'feedback': feedback,
                'rating': rating,
                'timestamp': FieldValue.serverTimestamp(),
              });
              Navigator.of(context).pop();
            },
            child: Text('Submit', style: TextStyle(color: kPrimaryColor)),
          ),
        ],
      );
    },
  );
}
