/*import 'package:appwithapi/tutoring/profile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Map<String, Map<String, List<String>>> categoryMap = {
  'Computer and Information Technology': {
    'Computer Science': [
      'Algorithms and Data Structures',
      'Computer Architecture',
      'Operating Systems',
      'Database Systems',
      'C++'
    ],
    'Information Technology': [
      'Subject 4',
      'Subject 5',
      'Subject 6',
    ],
  },
  'Engineering': {
    'Mechanical Engineering': [
      'Subject A',
      'Subject B',
      'Subject C',
    ],
    'Electrical Engineering': [
      'Subject X',
      'Subject Y',
      'Subject Z',
    ],
  },
};

class TeachOrNotScreen extends StatefulWidget {
  @override
  _TeachOrNotScreenState createState() => _TeachOrNotScreenState();
}

class _TeachOrNotScreenState extends State<TeachOrNotScreen> {
  String? Department;
  String? major;
  List<Map<String, dynamic>> subjectsToTeach = [];

  bool wantsToTeach = false;
  bool departmentAndMajorSelected = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6F3F3),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                DropdownButtonFormField<String>(
                  value: Department,
                  onChanged: (newValue) {
                    setState(() {
                      Department = newValue;
                      major = null;
                      subjectsToTeach.clear();
                      departmentAndMajorSelected =
                          false; // to make sure the user choose major && departmen
                    });
                  },
                  items: categoryMap.keys.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  hint: Text('Your department is '),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: major,
                  onChanged: (newValue) {
                    setState(() {
                      major = newValue;
                      subjectsToTeach.clear();
                      departmentAndMajorSelected = Department != null &&
                          major != null; // Check if both are selected
                    });
                  },
                  items: getSubcategories().map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  hint: Text('Your major is '),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: wantsToTeach,
                      onChanged: (value) {
                        setState(() {
                          wantsToTeach = value!;
                        });
                      },
                    ),
                    Text('I want to teach'),
                  ],
                ),
                if (wantsToTeach && Department != null && major != null)
                  Column(
                    children: [
                      Text('Subjects in ${major!}:'),
                      SizedBox(height: 10),
                      Wrap(
                        children: getSubjects().map((subject) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FilterChip(
                              label: Text(subject['name']),
                              selected: subjectsToTeach
                                  .map((e) => e['name'])
                                  .toList()
                                  .contains(subject['name']),
                              onSelected: (isSelected) async {
                                if (isSelected) {
                                  int? price = await showDialog<int>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Enter Price'),
                                      content: TextFormField(
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          subject['price'] =
                                              int.tryParse(value) ?? 0;
                                        },
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(
                                                context, subject['price']);
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (price != null) {
                                    String? preferOnline =
                                        await showDialog<String>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Prefer Online Teaching?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context,
                                                  'Yes'); // Return 'Yes' as String
                                            },
                                            child: Text('Yes'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context,
                                                  'No'); // Return 'No' as String
                                            },
                                            child: Text('No'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context,
                                                  "I don't care"); // Return "I don't care" as String
                                            },
                                            child: Text("I don't care"),
                                          ),
                                        ],
                                      ),
                                    );

                                    subject['preferOnline'] =
                                        preferOnline ?? false;
                                    setState(() {
                                      subjectsToTeach.add(subject);
                                    });
                                  }
                                } else {
                                  setState(() {
                                    subjectsToTeach.removeWhere((element) =>
                                        element['name'] == subject['name']);
                                  });
                                }
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  child: Text(
                    'Finish',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFFE6F3F3),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF111236),
                  ),
                  onPressed: () {
                    if (!departmentAndMajorSelected) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Missing Information'),
                            content: Text(
                                'Please select your department and major before finishing.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      saveInformationToFirestore();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => ProfileScreen()),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<String> getSubcategories() {
    if (Department != null) {
      return categoryMap[Department!]!.keys.toList();
    }
    return [];
  }

  List<Map<String, dynamic>> getSubjects() {
    if (Department != null && major != null) {
      return categoryMap[Department!]![major!]!
          .map((subject) => {
                'name': subject,
                'price': 0, // default price
                'preferOnline': 'No', // default preference
              })
          .toList();
    }
    return [];
  }

  void saveInformationToFirestore() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;

        // Update the user's general information
        await _firestore.collection('Students').doc(userId).update({
          'wantsToTeach': wantsToTeach,
          'Department': Department,
          'major': major,
        });

        // Create a subcollection for teaching subjects
        if (wantsToTeach) {
          // Create a subcollection for teaching subjects
          CollectionReference teachingSubjectsRef = _firestore
              .collection('Students')
              .doc(userId)
              .collection('TeachingSubjects');

          // Add each subject to the subcollection
          for (Map<String, dynamic> subject in subjectsToTeach) {
            await teachingSubjectsRef.add({
              'subject': subject['name'],
              'price': subject['price'],
              'preferOnline': subject['preferOnline'],
            });
          }
        }
      } else {
        // User is not signed in
        print('User is not signed in');
      }
    } catch (e) {
      // Show error message
      print('Error saving information: $e');
    }
  }
}
*/
import 'package:appwithapi/tutoring/profile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Map<String, Map<String, List<String>>> categoryMap = {
  'Computer and Information Technology': {
    'Computer Science': [
      'Algorithms and Data Structures',
      'Computer Architecture',
      'Operating Systems',
      'Database Systems',
      'C++'
    ],
    'Information Technology': [
      'Subject 4',
      'Subject 5',
      'Subject 6',
    ],
  },
  'Engineering': {
    'Mechanical Engineering': [
      'Subject A',
      'Subject B',
      'Subject C',
    ],
    'Electrical Engineering': [
      'Subject X',
      'Subject Y',
      'Subject Z',
    ],
  },
};

class TeachOrNotScreen extends StatefulWidget {
  @override
  _TeachOrNotScreenState createState() => _TeachOrNotScreenState();
}

class _TeachOrNotScreenState extends State<TeachOrNotScreen> {
  String? Department;
  String? major;
  List<Map<String, dynamic>> subjectsToTeach = [];

  bool wantsToTeach = false;
  bool departmentAndMajorSelected = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6F3F3),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                DropdownButtonFormField<String>(
                  value: Department,
                  onChanged: (newValue) {
                    setState(() {
                      Department = newValue;
                      major = null;
                      subjectsToTeach.clear();
                      departmentAndMajorSelected =
                          false; // to make sure the user choose major && departmen
                    });
                  },
                  items: categoryMap.keys.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  hint: Text('Your department is '),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: major,
                  onChanged: (newValue) {
                    setState(() {
                      major = newValue;
                      subjectsToTeach.clear();
                      departmentAndMajorSelected = Department != null &&
                          major != null; // Check if both are selected
                    });
                  },
                  items: getSubcategories().map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  hint: Text('Your major is '),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: wantsToTeach,
                      onChanged: (value) {
                        setState(() {
                          wantsToTeach = value!;
                        });
                      },
                    ),
                    Text('I want to teach'),
                  ],
                ),
                if (wantsToTeach && Department != null && major != null)
                  Column(
                    children: [
                      Text('Subjects in ${major!}:'),
                      SizedBox(height: 10),
                      Wrap(
                        children: getSubjects().map((subject) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FilterChip(
                              label: Text(subject['name']),
                              selected: subjectsToTeach
                                  .map((e) => e['name'])
                                  .toList()
                                  .contains(subject['name']),
                              onSelected: (isSelected) async {
                                if (isSelected) {
                                  int? price = await showDialog<int>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Enter Price'),
                                      content: TextFormField(
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          subject['price'] =
                                              int.tryParse(value) ?? 0;
                                        },
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(
                                                context, subject['price']);
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (price != null) {
                                    String? preferOnline =
                                        await showDialog<String>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Prefer Online Teaching?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context,
                                                  'Yes'); // Return 'Yes' as String
                                            },
                                            child: Text('Yes'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context,
                                                  'No'); // Return 'No' as String
                                            },
                                            child: Text('No'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context,
                                                  "I don't care"); // Return "I don't care" as String
                                            },
                                            child: Text("I don't care"),
                                          ),
                                        ],
                                      ),
                                    );

                                    subject['preferOnline'] =
                                        preferOnline ?? false;
                                    setState(() {
                                      subjectsToTeach.add(subject);
                                    });
                                  }
                                } else {
                                  setState(() {
                                    subjectsToTeach.removeWhere((element) =>
                                        element['name'] == subject['name']);
                                  });
                                }
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  child: Text(
                    'Finish',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFFE6F3F3),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF111236),
                  ),
                  onPressed: () {
                    if (!departmentAndMajorSelected) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Missing Information'),
                            content: Text(
                                'Please select your department and major before finishing.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      saveInformationToFirestore();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => ProfileScreen()),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<String> getSubcategories() {
    if (Department != null) {
      return categoryMap[Department!]!.keys.toList();
    }
    return [];
  }

  List<Map<String, dynamic>> getSubjects() {
    if (Department != null && major != null) {
      return categoryMap[Department!]![major!]!
          .map((subject) => {
                'name': subject,
                'price': 0, // default price
                'preferOnline': 'No', // default preference
              })
          .toList();
    }
    return [];
  }

  void saveInformationToFirestore() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;

        // Fetch the user's gender
        DocumentSnapshot userDoc =
            await _firestore.collection('Students').doc(userId).get();
        String gender = userDoc['gender'];

        // Determine the profile image URL based on the gender
        String profileImageUrl = gender == 'Male'
            ? 'https://i.pinimg.com/564x/22/ce/12/22ce126b77afdd24a5994ecb51736887.jpg'
            : 'https://i.pinimg.com/736x/8b/1f/9f/8b1f9f145889835124f968a6aa82b79f.jpg';

        // Update the user's general information
        await _firestore.collection('Students').doc(userId).update({
          'wantsToTeach': wantsToTeach,
          'Department': Department,
          'major': major,
          'profileImageUrl': profileImageUrl, // Add the profile image URL
        });

        // Create a subcollection for teaching subjects
        if (wantsToTeach) {
          CollectionReference teachingSubjectsRef = _firestore
              .collection('Students')
              .doc(userId)
              .collection('TeachingSubjects');

          for (Map<String, dynamic> subject in subjectsToTeach) {
            await teachingSubjectsRef.add({
              'subject': subject['name'],
              'price': subject['price'],
              'preferOnline': subject['preferOnline'],
            });
          }
        }
      } else {
        // User is not signed in
        print('User is not signed in');
      }
    } catch (e) {
      // Show error message
      print('Error saving information: $e');
    }
  }
}
