import 'package:appwithapi/Cstum/constant.dart';
import 'package:appwithapi/connectingPage/firstconnetc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: kPrimaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Firstconnet()),
            );
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Change Password'),
            trailing: Icon(Icons.arrow_right),
            leading: Icon(Icons.lock),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangePasswordScreen(auth: _auth),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Change Phone Number'),
            trailing: Icon(Icons.arrow_right),
            leading: Icon(Icons.phone),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangePhoneNumberScreen(auth: _auth),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Change Teaching Info'),
            trailing: Icon(Icons.arrow_right),
            leading: Icon(Icons.edit_document),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TeachOrEditScreen()
                    // ChangeTeachingInfoScreen(auth: _auth),
                    ),
              );
            },
          ),
          ListTile(
            title: Text('Delete Account'),
            trailing: Icon(Icons.arrow_right),
            leading: Icon(Icons.person),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Confirm Delete'),
                    content:
                        Text('Are you sure you want to delete your account?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          _deleteAccount(_auth.currentUser!.uid);
                          Navigator.pop(context);
                        },
                        child: Text('Delete'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccount(String userId) async {
    // Delete user's document from Firestore
    await _firestore.collection('Students').doc(userId).delete();
    // Navigate back to previous screen or handle account deletion
  }
}

class ChangePasswordScreen extends StatefulWidget {
  final FirebaseAuth auth;

  const ChangePasswordScreen({required this.auth});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late FirebaseAuth _auth;
  String _currentPassword = '';
  String _newPassword = '';
  String _confirmNewPassword = '';

  @override
  void initState() {
    super.initState();
    _auth = widget.auth;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Change Password',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: kPrimaryColor,
          iconTheme: IconThemeData(color: Colors.white)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: 'Current Password',
              ),
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  _currentPassword = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'New Password',
              ),
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  _newPassword = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
              ),
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  _confirmNewPassword = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_newPassword == _confirmNewPassword) {
                  _changePassword();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Passwords do not match")),
                  );
                }
              },
              child: Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _changePassword() async {
    try {
      User user = _auth.currentUser!;
      // Reauthenticate the user with their current password
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: _currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      // Update password
      await user.updatePassword(_newPassword);
      // Password updated successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password changed successfully")),
      );
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to change password. ${e.toString()}")),
      );
    }
  }
}

class ChangePhoneNumberScreen extends StatefulWidget {
  final FirebaseAuth auth;

  const ChangePhoneNumberScreen({required this.auth});

  @override
  _ChangePhoneNumberScreenState createState() =>
      _ChangePhoneNumberScreenState();
}

class _ChangePhoneNumberScreenState extends State<ChangePhoneNumberScreen> {
  late FirebaseAuth _auth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _oldPhoneNumber = '';
  String _newPhoneNumber = '';

  @override
  void initState() {
    super.initState();
    _auth = widget.auth;
    _fetchUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Change Phone Number',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: kPrimaryColor,
          iconTheme: IconThemeData(color: Colors.white)),
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
          ],
        ),
      ),
    );
  }

  Future<void> _updatePhoneNumber(String userId) async {
    // Update phone number in Firestore
    await _firestore.collection('Students').doc(userId).update({
      'phoneNumber': _newPhoneNumber,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Phone number updated successfully")),
    );
    setState(() {
      _oldPhoneNumber = _newPhoneNumber;
    });
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

  Future<void> _fetchPhoneNumber(String userId) async {
    // Fetch old phone number from Firestore
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('Students').doc(userId).get();
    setState(() {
      _oldPhoneNumber = snapshot.data()?['phoneNumber'] ?? '';
    });
  }
}

/*class TeachOrEditScreen extends StatefulWidget {
  @override
  _TeachOrEditScreenState createState() => _TeachOrEditScreenState();
}

class _TeachOrEditScreenState extends State<TeachOrEditScreen> {
  List<Map<String, dynamic>> subjectsToTeach = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  String? Department;
  String? major;
  String? selectedSubject;
  String? preferOnlineTeaching;
  TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;

        DocumentSnapshot studentSnapshot =
            await _firestore.collection('Students').doc(userId).get();
        Map<String, dynamic> studentData =
            studentSnapshot.data() as Map<String, dynamic>;

        setState(() {
          Department = studentData['Department'];
          major = studentData['major'];
        });

        CollectionReference subjectsRef = _firestore
            .collection('Students')
            .doc(userId)
            .collection('TeachingSubjects');
        QuerySnapshot subjectsSnapshot = await subjectsRef.get();
        setState(() {
          subjectsToTeach = subjectsSnapshot.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            return data;
          }).toList();
        });
      } else {
        print('User is not signed in');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6F3F3),
      appBar: AppBar(
          title: Text(
            "Change teching info",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: kPrimaryColor,
          iconTheme: IconThemeData(color: Colors.white)),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                Text(
                  'Your Teaching Subjects:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: subjectsToTeach.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildSubjectTile(subjectsToTeach[index]);
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  child: Text(
                    'Add Subject',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFFE6F3F3),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF111236),
                  ),
                  onPressed: _addSubject,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectTile(Map<String, dynamic> subject) {
    return Card(
      child: ListTile(
        title: Text(subject['subject']),
        subtitle: Text('Price: \$${subject['price']}'),
        trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () => _editSubject(subject),
        ),
      ),
    );
  }

  void _addSubject() {
    List<String> subjects = [];

    if (Department != null && major != null) {
      subjects = categoryMap[Department!]?[major!] ?? [];
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Subject'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (subjects.isNotEmpty) ...[
                    DropdownButtonFormField<String>(
                      value: selectedSubject,
                      onChanged: (newValue) {
                        setState(() {
                          selectedSubject = newValue;
                        });
                      },
                      items: subjects.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      hint: Text('Select Subject'),
                    ),
                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Price',
                      ),
                    ),
                    ListTile(
                      title: Text('Prefer Online Teaching?'),
                      trailing: DropdownButton<String>(
                        value: preferOnlineTeaching,
                        onChanged: (String? value) {
                          setState(() {
                            preferOnlineTeaching = value;
                          });
                        },
                        items:
                            ['Yes', 'No', "I don't care"].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ] else
                    Text(
                      'No subjects available for your department and major',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            if (subjects.isNotEmpty)
              TextButton(
                onPressed: () {
                  _addSubjectToFirestore();
                  Navigator.of(context).pop();
                },
                child: Text('Save'),
              ),
          ],
        );
      },
    );
  }

  void _addSubjectToFirestore() async {
    String? subject = selectedSubject;
    int price = int.tryParse(_priceController.text.trim()) ?? 0;
    if (subject != null && subject.isNotEmpty && price > 0) {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;
        DocumentReference docRef = await _firestore
            .collection('Students')
            .doc(userId)
            .collection('TeachingSubjects')
            .add({
          'subject': subject,
          'price': price,
          'preferOnline':
              preferOnlineTeaching, // Add preferOnlineTeaching field
        });
        setState(() {
          subjectsToTeach.add({
            'id': docRef.id,
            'subject': subject,
            'price': price,
            'preferOnline':
                preferOnlineTeaching, // Also add it to the local list
          });
        });
        Navigator.of(context).pop();
      }
    }
  }

  void _editSubject(Map<String, dynamic> subject) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController _priceController =
            TextEditingController(text: subject['price'].toString());
        return AlertDialog(
          title: Text('Edit Subject'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: subject['subject'],
                enabled: false,
                decoration: InputDecoration(labelText: 'Subject'),
              ),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Price'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _updateSubjectInFirestore(subject, _priceController.text);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _updateSubjectInFirestore(
      Map<String, dynamic> subject, String newPrice) async {
    int price = int.tryParse(newPrice.trim()) ?? 0;
    if (price > 0) {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;
        DocumentReference subjectRef = _firestore
            .collection('Students')
            .doc(userId)
            .collection('TeachingSubjects')
            .doc(subject['id']);
        await subjectRef.update({'price': price});
        setState(() {
          subject['price'] = price;
        });
        Navigator.of(context).pop();
      }
    }
  }
}
*/

/*class TeachOrEditScreen extends StatefulWidget {
  @override
  _TeachOrEditScreenState createState() => _TeachOrEditScreenState();
}

class _TeachOrEditScreenState extends State<TeachOrEditScreen> {
  List<Map<String, dynamic>> subjectsToTeach = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  String? Department;
  String? major;
  String? selectedSubject;
  String? preferOnlineTeaching;
  TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;

        DocumentSnapshot studentSnapshot =
            await _firestore.collection('Students').doc(userId).get();
        Map<String, dynamic> studentData =
            studentSnapshot.data() as Map<String, dynamic>;

        setState(() {
          Department = studentData['Department'];
          major = studentData['major'];
        });

        CollectionReference subjectsRef = _firestore
            .collection('Students')
            .doc(userId)
            .collection('TeachingSubjects');
        QuerySnapshot subjectsSnapshot = await subjectsRef.get();
        setState(() {
          subjectsToTeach = subjectsSnapshot.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            return data;
          }).toList();
        });
      } else {
        print('User is not signed in');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6F3F3),
      appBar: AppBar(
        title: Text(
          "Change teching info",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: kPrimaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                Text(
                  'Your Teaching Subjects:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: subjectsToTeach.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildSubjectTile(subjectsToTeach[index]);
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  child: Text(
                    'Add Subject',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFFE6F3F3),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF111236),
                  ),
                  onPressed: _addSubject,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectTile(Map<String, dynamic> subject) {
    return Card(
      child: ListTile(
        title: Text(subject['subject']),
        subtitle: Text('Price: \$${subject['price']}'),
        trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () => _editSubject(subject),
        ),
      ),
    );
  }

  void _addSubject() {
    List<String> subjects = [];

    if (Department != null && major != null) {
      subjects = categoryMap[Department!]?[major!] ?? [];
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Subject'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (subjects.isNotEmpty) ...[
                    DropdownButtonFormField<String>(
                      value: selectedSubject,
                      onChanged: (newValue) {
                        setState(() {
                          selectedSubject = newValue;
                        });
                      },
                      items: subjects.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      hint: Text('Select Subject'),
                    ),
                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Price',
                      ),
                    ),
                    ListTile(
                      title: Text('Prefer Online Teaching?'),
                      trailing: DropdownButton<String>(
                        value: preferOnlineTeaching,
                        onChanged: (String? value) {
                          setState(() {
                            preferOnlineTeaching = value;
                          });
                        },
                        items:
                            ['Yes', 'No', "I don't care"].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ] else
                    Text(
                      'No subjects available for your department and major',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            if (subjects.isNotEmpty)
              TextButton(
                onPressed: () {
                  _addSubjectToFirestore();
                  Navigator.of(context).pop();
                },
                child: Text('Save'),
              ),
          ],
        );
      },
    );
  }

  void _addSubjectToFirestore() async {
    String? subject = selectedSubject;
    int price = int.tryParse(_priceController.text.trim()) ?? 0;
    if (subject != null && subject.isNotEmpty && price > 0) {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;
        DocumentReference docRef = await _firestore
            .collection('Students')
            .doc(userId)
            .collection('TeachingSubjects')
            .add({
          'subject': subject,
          'price': price,
          'preferOnline': preferOnlineTeaching,
        });
        setState(() {
          subjectsToTeach.add({
            'id': docRef.id,
            'subject': subject,
            'price': price,
            'preferOnline': preferOnlineTeaching,
          });
        });
        Navigator.of(context).pop();
      }
    }
  }

  void _editSubject(Map<String, dynamic> subject) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController _priceController =
            TextEditingController(text: subject['price'].toString());
        return AlertDialog(
          title: Text('Edit Subject'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: subject['subject'],
                enabled: false,
                decoration: InputDecoration(labelText: 'Subject'),
              ),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Price'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteSubject(subject);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                _updateSubjectInFirestore(subject, _priceController.text);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _updateSubjectInFirestore(
      Map<String, dynamic> subject, String newPrice) async {
    int price = int.tryParse(newPrice.trim()) ?? 0;
    if (price > 0) {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;
        DocumentReference subjectRef = _firestore
            .collection('Students')
            .doc(userId)
            .collection('TeachingSubjects')
            .doc(subject['id']);
        await subjectRef.update({'price': price});
        setState(() {
          subject['price'] = price;
        });
        Navigator.of(context).pop();
      }
    }
  }

  void _deleteSubject(Map<String, dynamic> subject) async {
    User? user = _auth.currentUser;
    if (user != null) {
      String userId = user.uid;
      DocumentReference subjectRef = _firestore
          .collection('Students')
          .doc(userId)
          .collection('TeachingSubjects')
          .doc(subject['id']);
      await subjectRef.delete();
      setState(() {
        subjectsToTeach.remove(subject);
      });
    }
  }
}
*/

class TeachOrEditScreen extends StatefulWidget {
  @override
  _TeachOrEditScreenState createState() => _TeachOrEditScreenState();
}

class _TeachOrEditScreenState extends State<TeachOrEditScreen> {
  List<Map<String, dynamic>> subjectsToTeach = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  String? Department;
  String? major;
  String? selectedSubject;
  String? preferOnlineTeaching;
  TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;

        DocumentSnapshot studentSnapshot =
            await _firestore.collection('Students').doc(userId).get();
        Map<String, dynamic> studentData =
            studentSnapshot.data() as Map<String, dynamic>;

        setState(() {
          Department = studentData['Department'];
          major = studentData['major'];
        });

        CollectionReference subjectsRef = _firestore
            .collection('Students')
            .doc(userId)
            .collection('TeachingSubjects');
        QuerySnapshot subjectsSnapshot = await subjectsRef.get();
        setState(() {
          subjectsToTeach = subjectsSnapshot.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            return data;
          }).toList();
        });
      } else {
        print('User is not signed in');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6F3F3),
      appBar: AppBar(
        title: Text(
          "Change teaching info",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: kPrimaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                Text(
                  'Your Teaching Subjects:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: subjectsToTeach.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildSubjectTile(subjectsToTeach[index]);
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  child: Text(
                    'Add Subject',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFFE6F3F3),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF111236),
                  ),
                  onPressed: _addSubject,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectTile(Map<String, dynamic> subject) {
    return Card(
      child: ListTile(
        title: Text(subject['subject']),
        subtitle: Text('Price: \$${subject['price']}'),
        trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () => _editSubject(subject),
        ),
      ),
    );
  }

  void _addSubject() {
    List<String> subjects = [];

    if (Department != null && major != null) {
      subjects = categoryMap[Department!]?[major!] ?? [];
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Subject'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (subjects.isNotEmpty) ...[
                    DropdownButtonFormField<String>(
                      value: selectedSubject,
                      onChanged: (newValue) {
                        setState(() {
                          selectedSubject = newValue;
                        });
                      },
                      items: subjects.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      hint: Text('Select Subject'),
                    ),
                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Price',
                      ),
                    ),
                    ListTile(
                      title: Text('Prefer Online Teaching?'),
                      trailing: DropdownButton<String>(
                        value: preferOnlineTeaching,
                        onChanged: (String? value) {
                          setState(() {
                            preferOnlineTeaching = value;
                          });
                        },
                        items:
                            ['Yes', 'No', "I don't care"].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ] else
                    Text(
                      'No subjects available for your department and major',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            if (subjects.isNotEmpty)
              TextButton(
                onPressed: () {
                  _addSubjectToFirestore(context);
                },
                child: Text('Save'),
              ),
          ],
        );
      },
    );
  }

  void _addSubjectToFirestore(BuildContext context) async {
    String? subject = selectedSubject;
    int price = int.tryParse(_priceController.text.trim()) ?? 0;
    if (subject != null &&
        subject.isNotEmpty &&
        price >= 0 &&
        preferOnlineTeaching != null) {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;
        DocumentReference docRef = await _firestore
            .collection('Students')
            .doc(userId)
            .collection('TeachingSubjects')
            .add({
          'subject': subject,
          'price': price,
          'preferOnline': preferOnlineTeaching,
        });
        setState(() {
          subjectsToTeach.add({
            'id': docRef.id,
            'subject': subject,
            'price': price,
            'preferOnline': preferOnlineTeaching,
          });
        });
        Navigator.of(context).pop();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill the  fields'),
        ),
      );
    }
  }

  void _editSubject(Map<String, dynamic> subject) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController _priceController =
            TextEditingController(text: subject['price'].toString());
        return AlertDialog(
          title: Text('Edit Subject'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: subject['subject'],
                enabled: false,
                decoration: InputDecoration(labelText: 'Subject'),
              ),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Price'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteSubject(subject);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                _updateSubjectInFirestore(subject, _priceController.text);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _updateSubjectInFirestore(
      Map<String, dynamic> subject, String newPrice) async {
    int price = int.tryParse(newPrice.trim()) ?? 0;
    if (price > 0) {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;
        DocumentReference subjectRef = _firestore
            .collection('Students')
            .doc(userId)
            .collection('TeachingSubjects')
            .doc(subject['id']);
        await subjectRef.update({'price': price});
        setState(() {
          subject['price'] = price;
        });
        Navigator.of(context).pop();
      }
    }
  }

  void _deleteSubject(Map<String, dynamic> subject) async {
    User? user = _auth.currentUser;
    if (user != null) {
      String userId = user.uid;
      DocumentReference subjectRef = _firestore
          .collection('Students')
          .doc(userId)
          .collection('TeachingSubjects')
          .doc(subject['id']);
      await subjectRef.delete();
      setState(() {
        subjectsToTeach.remove(subject);
      });
    }
  }
}
