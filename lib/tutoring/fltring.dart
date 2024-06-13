/*import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradution_project/ReviewScreen.dart';
import 'package:gradution_project/constant.dart';
import 'package:gradution_project/constant.dart';
import 'package:gradution_project/menu.dart';
import 'package:gradution_project/visitProfile.dart';

class Fitring extends StatefulWidget {
  const Fitring({Key? key}) : super(key: key);

  @override
  State<Fitring> createState() => _FitringState();
}

class _FitringState extends State<Fitring> {
  List allResults = [];
  List ResultsList = [];
  final TextEditingController _searchController = TextEditingController();

  getClientStream() async {
    var studentData = await FirebaseFirestore.instance
        .collection('Students')
        .where('wantsToTeach', isEqualTo: true)
        .get();

    List<DocumentSnapshot> students = studentData.docs;
    List<Map<String, dynamic>> results = [];

    for (var student in students) {
      var teachingSubjectsData =
          await student.reference.collection('TeachingSubjects').get();

      for (var subjectDoc in teachingSubjectsData.docs) {
        String defaultImageUrl = student['gender'] == 'Male'
            ? 'https://i.pinimg.com/564x/22/ce/12/22ce126b77afdd24a5994ecb51736887.jpg'
            : 'https://i.pinimg.com/736x/8b/1f/9f/8b1f9f145889835124f968a6aa82b79f.jpg';
        results.add({
          'major': student['major'],
          'subject': subjectDoc['subject'],
          'price': subjectDoc['price'],
          'profileImageUrl': student['profileImageUrl'] ?? defaultImageUrl,
          'Whatprefer': subjectDoc['preferOnline'],
          'IDNumber': student['IDNumber'],
          "gender": student['gender']
        });
      }
    }

    setState(() {
      allResults = results;
    });

    SearchResultList();
  }

  @override
  void initState() {
    super.initState();
    getClientStream();
    _searchController.addListener(_onsearchChanged);
  }

  _onsearchChanged() {
    print(_searchController.text);
    SearchResultList();
  }

  SearchResultList() {
    var showResults = [];
    if (_searchController.text.isNotEmpty) {
      for (var clientSnapshot in allResults) {
        var subject = clientSnapshot['subject'].toString().toLowerCase();
        if (subject.contains(_searchController.text.toLowerCase())) {
          showResults.add(clientSnapshot);
        }
      }
    } else {
      showResults = List.from(allResults);
    }
    setState(() {
      ResultsList = showResults;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onsearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getClientStream();
    super.didChangeDependencies();
  }

  Widget buildPreferenceText(String preference) {
    if (preference == 'Yes') {
      return Text("Lessons will be online");
    } else if (preference == 'No') {
      return Text("Lessons will be onsite");
    } else {
      return Text("As Student want");
    }
  }

  void _showReviewScreen(
      BuildContext context, String subject, String teacherId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ReviewsScreen(subject: subject, teacherId: teacherId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ksecondaryColor,
      appBar: AppBar(
        backgroundColor: ksecondaryColor,
        title: CupertinoSearchTextField(
          controller: _searchController,
        ),
      ),
      body: ListView.builder(
        itemCount: ResultsList.length,
        itemBuilder: (context, index) {
          return Container(
              padding: EdgeInsets.only(left: 20, top: 20, right: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VistingProfileScreen(
                          studentId: ResultsList[index]['IDNumber']),
                    ),
                  );
                },
                child: Card(
                  color: Colors.white,
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                ResultsList[index]['profileImageUrl'],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ResultsList[index]['major'],
                                style: TextStyle(color: Colors.orange),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                ResultsList[index]['subject'],
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Row(
                                children: [
                                  Icon(Icons.attach_money,
                                      color: kPrimaryColor, size: 16),
                                  SizedBox(width: 5),
                                  Text(
                                    ResultsList[index]['price'].toString(),
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined,
                                      color: Colors.grey, size: 20),
                                  SizedBox(width: 5),
                                  buildPreferenceText(
                                      ResultsList[index]['Whatprefer']),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      _showReviewScreen(
                                          context,
                                          ResultsList[index]['subject'],
                                          ResultsList[index]['IDNumber']);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              kPrimaryColor),
                                    ),
                                    child: Text(
                                      'Feedback',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _showFeedbackDialog(
                                          context,
                                          ResultsList[index]['subject'],
                                          ResultsList[index]['IDNumber']);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              kPrimaryColor),
                                    ),
                                    child: Text(
                                      'your Feedback is',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
        },
      ),
      drawer: Menu(),
    );
  }
}

Future<void> _showFeedbackDialog(
    BuildContext context, String subject, String teacherId) async {
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
        iconColor: kPrimaryColor,
        backgroundColor: Colors.white,
        title: Text('Feedback and Rating for $subject'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 10),
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
              ),
              SizedBox(height: 10),
              Text('Rating: $rating'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Save feedback and rating to Firestore
              await FirebaseFirestore.instance.collection('Feedback').add({
                'auth': user.uid, // Include user's UID
                'subject': subject,
                'teacherId': teacherId,
                'feedback': feedback,
                'rating': rating,
                'timestamp': FieldValue.serverTimestamp(),
                "email": user.email,
              });
              Navigator.of(context).pop();
            },
            child: Text('Submit'),
          ),
        ],
      );
    },
  );
}*/

/*import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradution_project/ReviewScreen.dart';
import 'package:gradution_project/constant.dart';
import 'package:gradution_project/menu.dart';
import 'package:gradution_project/visitProfile.dart';

class Fitring extends StatefulWidget {
  const Fitring({Key? key}) : super(key: key);

  @override
  State<Fitring> createState() => _FitringState();
}

class _FitringState extends State<Fitring> {
  List allResults = [];
  List ResultsList = [];
  final TextEditingController _searchController = TextEditingController();
  String selectedGender = 'All'; // Add this variable

  getClientStream() async {
    var studentData = await FirebaseFirestore.instance
        .collection('Students')
        .where('wantsToTeach', isEqualTo: true)
        .get();

    List<DocumentSnapshot> students = studentData.docs;
    List<Map<String, dynamic>> results = [];

    for (var student in students) {
      var teachingSubjectsData =
          await student.reference.collection('TeachingSubjects').get();

      for (var subjectDoc in teachingSubjectsData.docs) {
        String defaultImageUrl = student['gender'] == 'Male'
            ? 'https://i.pinimg.com/564x/22/ce/12/22ce126b77afdd24a5994ecb51736887.jpg'
            : 'https://i.pinimg.com/736x/8b/1f/9f/8b1f9f145889835124f968a6aa82b79f.jpg';
        results.add({
          'major': student['major'],
          'subject': subjectDoc['subject'],
          'price': subjectDoc['price'],
          'profileImageUrl': student['profileImageUrl'] ?? defaultImageUrl,
          'Whatprefer': subjectDoc['preferOnline'],
          'IDNumber': student['IDNumber'],
          "gender": student['gender']
        });
      }
    }

    setState(() {
      allResults = results;
    });

    SearchResultList();
  }

  @override
  void initState() {
    super.initState();
    getClientStream();
    _searchController.addListener(_onsearchChanged);
  }

  _onsearchChanged() {
    SearchResultList();
  }

  SearchResultList() {
    var showResults = [];
    if (_searchController.text.isNotEmpty || selectedGender != 'All') {
      for (var clientSnapshot in allResults) {
        var subject = clientSnapshot['subject'].toString().toLowerCase();
        var gender = clientSnapshot['gender'];
        if (subject.contains(_searchController.text.toLowerCase()) &&
            (selectedGender == 'All' || gender == selectedGender)) {
          showResults.add(clientSnapshot);
        }
      }
    } else {
      showResults = List.from(allResults);
    }
    setState(() {
      ResultsList = showResults;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onsearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getClientStream();
    super.didChangeDependencies();
  }

  Widget buildPreferenceText(String preference) {
    if (preference == 'Yes') {
      return Text("Lessons will be online");
    } else if (preference == 'No') {
      return Text("Lessons will be onsite");
    } else {
      return Text("As Student want");
    }
  }

  void _showReviewScreen(
      BuildContext context, String subject, String teacherId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ReviewsScreen(subject: subject, teacherId: teacherId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ksecondaryColor,
      appBar: AppBar(
        backgroundColor: ksecondaryColor,
        title: Row(
          children: [
            Expanded(
              child: CupertinoSearchTextField(
                controller: _searchController,
              ),
            ),
            SizedBox(width: 10),
            DropdownButton<String>(
              value: selectedGender,
              items: <String>['All', 'Male', 'Female']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedGender = newValue!;
                });
                SearchResultList();
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: ResultsList.length,
        itemBuilder: (context, index) {
          return Container(
              padding: EdgeInsets.only(left: 20, top: 20, right: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VistingProfileScreen(
                          studentId: ResultsList[index]['IDNumber']),
                    ),
                  );
                },
                child: Card(
                  color: Colors.white,
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                ResultsList[index]['profileImageUrl'],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ResultsList[index]['major'],
                                style: TextStyle(color: Colors.orange),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                ResultsList[index]['subject'],
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Row(
                                children: [
                                  Icon(Icons.attach_money,
                                      color: kPrimaryColor, size: 16),
                                  SizedBox(width: 5),
                                  Text(
                                    ResultsList[index]['price'].toString(),
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined,
                                      color: Colors.grey, size: 20),
                                  SizedBox(width: 5),
                                  buildPreferenceText(
                                      ResultsList[index]['Whatprefer']),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      _showReviewScreen(
                                          context,
                                          ResultsList[index]['subject'],
                                          ResultsList[index]['IDNumber']);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              kPrimaryColor),
                                    ),
                                    child: Text(
                                      'Feedback',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _showFeedbackDialog(
                                          context,
                                          ResultsList[index]['subject'],
                                          ResultsList[index]['IDNumber']);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              kPrimaryColor),
                                    ),
                                    child: Text(
                                      'your Feedback is',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
        },
      ),
      drawer: Menu(),
    );
  }
}

Future<void> _showFeedbackDialog(
    BuildContext context, String subject, String teacherId) async {
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
        iconColor: kPrimaryColor,
        backgroundColor: Colors.white,
        title: Text('Feedback and Rating for $subject'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 10),
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
              ),
              SizedBox(height: 10),
              Text('Rating: $rating'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Save feedback and rating to Firestore
              await FirebaseFirestore.instance.collection('Feedback').add({
                'auth': user.uid, // Include user's UID
                'subject': subject,
                'teacherId': teacherId,
                'feedback': feedback,
                'rating': rating,
                'timestamp': FieldValue.serverTimestamp(),
                "email": user.email,
              });
              Navigator.of(context).pop();
            },
            child: Text('Submit'),
          ),
        ],
      );
    },
  );
}
*/

import 'dart:async';
import 'package:appwithapi/Cstum/constant.dart';
import 'package:appwithapi/Cstum/menu.dart';
import 'package:appwithapi/tutoring/ReviewScreen.dart';
import 'package:appwithapi/tutoring/visitProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Fitring extends StatefulWidget {
  const Fitring({Key? key}) : super(key: key);

  @override
  State<Fitring> createState() => _FitringState();
}

class _FitringState extends State<Fitring> {
  List allResults = [];
  List ResultsList = [];
  final TextEditingController _searchController = TextEditingController();
  String selectedGender = 'All'; // Add this variable

  getClientStream() async {
    var studentData = await FirebaseFirestore.instance
        .collection('Students')
        .where('wantsToTeach', isEqualTo: true)
        .get();

    List<DocumentSnapshot> students = studentData.docs;
    List<Map<String, dynamic>> results = [];

    for (var student in students) {
      var teachingSubjectsData =
          await student.reference.collection('TeachingSubjects').get();

      for (var subjectDoc in teachingSubjectsData.docs) {
        String defaultImageUrl = student['gender'] == 'Male'
            ? 'https://i.pinimg.com/564x/22/ce/12/22ce126b77afdd24a5994ecb51736887.jpg'
            : 'https://i.pinimg.com/736x/8b/1f/9f/8b1f9f145889835124f968a6aa82b79f.jpg';
        results.add({
          'major': student['major'],
          'subject': subjectDoc['subject'],
          'price': subjectDoc['price'],
          'profileImageUrl': student['profileImageUrl'] ?? defaultImageUrl,
          'Whatprefer': subjectDoc['preferOnline'],
          'IDNumber': student['IDNumber'],
          "gender": student['gender']
        });
      }
    }

    setState(() {
      allResults = results;
    });

    SearchResultList();
  }

  @override
  void initState() {
    super.initState();
    getClientStream();
    _searchController.addListener(_onsearchChanged);
  }

  _onsearchChanged() {
    SearchResultList();
  }

  SearchResultList() {
    var showResults = [];
    if (_searchController.text.isNotEmpty || selectedGender != 'All') {
      for (var clientSnapshot in allResults) {
        var subject = clientSnapshot['subject'].toString().toLowerCase();
        var gender = clientSnapshot['gender'];
        if (subject.contains(_searchController.text.toLowerCase()) &&
            (selectedGender == 'All' || gender == selectedGender)) {
          showResults.add(clientSnapshot);
        }
      }
    } else {
      showResults = List.from(allResults);
    }
    setState(() {
      ResultsList = showResults;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onsearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getClientStream();
    super.didChangeDependencies();
  }

  Widget buildPreferenceText(String preference) {
    if (preference == 'Yes') {
      return Text("Lessons will be online");
    } else if (preference == 'No') {
      return Text("Lessons will be onsite");
    } else {
      return Text("As Student want");
    }
  }

  void _showReviewScreen(
      BuildContext context, String subject, String teacherId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ReviewsScreen(subject: subject, teacherId: teacherId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ksecondaryColor,
      appBar: AppBar(
        backgroundColor: ksecondaryColor,
        title: Row(
          children: [
            Expanded(
              child: CupertinoSearchTextField(
                controller: _searchController,
              ),
            ),
            SizedBox(width: 10),
            DropdownButton<String>(
              value: selectedGender,
              items: <String>['All', 'Male', 'Female']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedGender = newValue!;
                });
                SearchResultList();
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: ResultsList.length,
        itemBuilder: (context, index) {
          return Container(
              padding: EdgeInsets.only(left: 20, top: 20, right: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VistingProfileScreen(
                          studentId: ResultsList[index]['IDNumber']),
                    ),
                  );
                },
                child: Card(
                  color: Colors.white,
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                ResultsList[index]['profileImageUrl'],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ResultsList[index]['major'],
                                style: TextStyle(color: Colors.orange),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                ResultsList[index]['subject'],
                                style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Row(
                                children: [
                                  Icon(Icons.attach_money,
                                      color: kPrimaryColor, size: 16),
                                  SizedBox(width: 5),
                                  Text(
                                    ResultsList[index]['price'].toString(),
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined,
                                      color: Colors.grey, size: 20),
                                  SizedBox(width: 5),
                                  buildPreferenceText(
                                      ResultsList[index]['Whatprefer']),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      _showReviewScreen(
                                          context,
                                          ResultsList[index]['subject'],
                                          ResultsList[index]['IDNumber']);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              kPrimaryColor),
                                    ),
                                    child: Text(
                                      'Feedback',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _showFeedbackDialog(
                                          context,
                                          ResultsList[index]['subject'],
                                          ResultsList[index]['IDNumber']);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              kPrimaryColor),
                                    ),
                                    child: Text(
                                      'your Feedback is',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
        },
      ),
    );
  }
}

Future<void> _showFeedbackDialog(
    BuildContext context, String subject, String teacherId) async {
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
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            iconColor: kPrimaryColor,
            backgroundColor: Colors.white,
            title: Text('Feedback and Rating for $subject'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 10),
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
                      setState(() {
                        rating = newRating;
                      });
                    },
                    min: 0,
                    max: 5,
                    divisions: 5,
                    label: rating.toString(),
                  ),
                  SizedBox(height: 10),
                  Text('Rating: $rating'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  // Save feedback and rating to Firestore
                  await FirebaseFirestore.instance.collection('Feedback').add({
                    'auth': user.uid, // Include user's UID
                    'subject': subject,
                    'teacherId': teacherId,
                    'feedback': feedback,
                    'rating': rating,
                    'timestamp': FieldValue.serverTimestamp(),
                    "email": user.email,
                  });
                  Navigator.of(context).pop();
                },
                child: Text('Submit'),
              ),
            ],
          );
        },
      );
    },
  );
}
