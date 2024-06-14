import 'package:appwithapi/Cstum/constant.dart';
import 'package:appwithapi/Cstum/customTextField.dart';
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
  final _formKey = GlobalKey<FormState>();
  String _currentPassword = '';
  String _newPassword = '';
  String _confirmNewPassword = '';

  @override
  void initState() {
    super.initState();
    _auth = widget.auth;
  }

  String? _passwordValidator(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a password';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    } else if (!RegExp(r'^(?=.?[a-z])(?=.?[A-Z])(?=.*?[0-9]).{6,}$')
        .hasMatch(value)) {
      return 'Password must contain at least one uppercase letter,'
          ' one lowercase letter, and one digit';
    }
    return null;
  }

  String? _currentPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    } else if (value != _currentPassword) {
      return 'Current password does not match';
    }
    return null;
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
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              CustomTextField(
                hint: 'Current Password',
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    _currentPassword = value;
                  });
                },
                validator: _currentPasswordValidator,
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextField(
                hint: 'New Password',
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    _newPassword = value;
                  });
                },
                validator: _passwordValidator,
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextField(
                hint: 'Confirm New Password',
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    _confirmNewPassword = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  } else if (value != _newPassword) {
                    return ' not match';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _changePassword();
                  }
                },
                child: Text('Change Password'),
              ),
            ],
          ),
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
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Password changed successfully.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(); // Pop screen
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Handle errors
      if (e is FirebaseAuthException && e.code == 'wrong-password') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Current password is incorrect.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to change password. ${e.toString()}'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                ),
              ],
            );
          },
        );
      }
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
  late TextEditingController _newPhoneNumberController;
  String _newPhoneNumber = "";
  @override
  void initState() {
    super.initState();
    _auth = widget.auth;
    _fetchUserDetails();
    _newPhoneNumberController =
        TextEditingController(); // Initialize controller
  }

  @override
  void dispose() {
    _newPhoneNumberController.dispose(); // Dispose controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change Phone Number',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: kPrimaryColor, // Replace with your desired color
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Current Phone Number: $_oldPhoneNumber',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 14,
            ),
            CustomTextField(
              hint: ' Update Phone Number',
              controller: _newPhoneNumberController,
              onChanged: (value) {
                setState(() {
                  // Update _newPhoneNumber whenever text changes
                  _newPhoneNumber = value;
                });
              },
            ),
            SizedBox(
              height: 14,
            ),
            ElevatedButton(
              onPressed: () {
                _validateAndSavePhoneNumber(_auth.currentUser!.uid);
              },
              child: Text('Update Phone Number'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _validateAndSavePhoneNumber(String userId) async {
    // Validate the new phone number before updating
    if (_newPhoneNumberController.text.isEmpty ||
        _newPhoneNumberController.text.length != 10 ||
        ![
          '079',
          '078',
          '077'
        ].any((prefix) => _newPhoneNumberController.text.startsWith(prefix))) {
      // Show dialog for validation error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Invalid Phone Number'),
            content: Text('Please enter a valid phone number .'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                },
              ),
            ],
          );
        },
      );
      return;
    }

    // Update phone number in Firestore
    await _firestore.collection('Students').doc(userId).update({
      'phoneNumber': _newPhoneNumberController.text,
    });

    // Update _oldPhoneNumber with the new value
    setState(() {
      _oldPhoneNumber = _newPhoneNumberController.text;
    });

    // Show success message as a SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Phone number updated successfully")),
    );
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

class TeachOrEditScreen extends StatefulWidget {
  @override
  _TeachOrEditScreenState createState() => _TeachOrEditScreenState();
}

class _TeachOrEditScreenState extends State<TeachOrEditScreen> {
  List<Map<String, dynamic>> subjectsToTeach = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool wantsToTeach = false;

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
          wantsToTeach = studentData['wantsToTeach'] ?? false;
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
                const SizedBox(height: 20),
                CheckboxListTile(
                  activeColor: kPrimaryColor,
                  title: Text(
                    'Wants to Teach',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  value: wantsToTeach,
                  onChanged: (bool? value) {
                    _toggleWantsToTeach(value);
                  },
                ),
                const SizedBox(height: 20),
                if (wantsToTeach) ...[
                  SizedBox(
                    width: 10,
                  ),
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a price';
                        }
                        if (!RegExp(r'^\d+$').hasMatch(value)) {
                          return 'Please enter a valid price';
                        }
                        return null;
                      },
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
        preferOnlineTeaching != null &&
        RegExp(r'^\d+$').hasMatch(_priceController.text.trim())) {
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
          content: Text('Please fill all fields correctly'),
        ),
      );
    }
  }

  void _editSubject(Map<String, dynamic> subject) {
    TextEditingController _priceController =
        TextEditingController(text: subject['price'].toString());
    String? preferOnlineTeaching = subject['preferOnline'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Subject'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a price';
                      }
                      if (!RegExp(r'^\d+$').hasMatch(value)) {
                        return 'Please enter a valid price';
                      }
                      return null;
                    },
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
                      items: ['Yes', 'No', "I don't care"].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
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
            TextButton(
              onPressed: () {
                _deleteSubject(subject);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                if (RegExp(r'^\d+$').hasMatch(_priceController.text.trim())) {
                  _updateSubjectInFirestore(
                      subject, _priceController.text, preferOnlineTeaching);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a valid price'),
                    ),
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _updateSubjectInFirestore(
      Map<String, dynamic> subject, String price, String? preferOnline) async {
    try {
      int priceValue = int.tryParse(price.trim()) ?? 0;
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;
        await _firestore
            .collection('Students')
            .doc(userId)
            .collection('TeachingSubjects')
            .doc(subject['id'])
            .update({
          'price': priceValue,
          'preferOnline': preferOnline,
        });
        setState(() {
          int index =
              subjectsToTeach.indexWhere((s) => s['id'] == subject['id']);
          if (index != -1) {
            subjectsToTeach[index]['price'] = priceValue;
            subjectsToTeach[index]['preferOnline'] = preferOnline;
          }
        });
        Navigator.of(context).pop();
      }
    } catch (e) {
      print('Error updating subject: $e');
    }
  }

  void _deleteSubject(Map<String, dynamic> subject) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;
        await _firestore
            .collection('Students')
            .doc(userId)
            .collection('TeachingSubjects')
            .doc(subject['id'])
            .delete();
        setState(() {
          subjectsToTeach.removeWhere((s) => s['id'] == subject['id']);
        });
      }
    } catch (e) {
      print('Error deleting subject: $e');
    }
  }

  void _toggleWantsToTeach(bool? value) async {
    // Store the current state before showing the dialog
    bool previousValue = wantsToTeach;

    // Show the confirmation dialog
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: Text(value == true
              ? 'Are you sure you want to start teaching?'
              : 'Are you sure you want to stop teaching and remove all subjects?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User cancels
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User confirms
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );

    // If the user confirmed the action, proceed with the update
    if (confirm) {
      try {
        User? user = _auth.currentUser;
        if (user != null) {
          String userId = user.uid;
          if (value == true) {
            await _firestore.collection('Students').doc(userId).update({
              'wantsToTeach': true,
            });
          } else {
            // If wantsToTeach is false, delete all subjects and the TeachingSubjects subcollection
            await _firestore
                .collection('Students')
                .doc(userId)
                .collection('TeachingSubjects')
                .get()
                .then((snapshot) {
              for (DocumentSnapshot ds in snapshot.docs) {
                ds.reference.delete();
              }
            });
            await _firestore.collection('Students').doc(userId).update({
              'wantsToTeach': false,
            });
            setState(() {
              subjectsToTeach.clear();
            });
          }
          setState(() {
            wantsToTeach = value ?? false;
          });
        }
      } catch (e) {
        print('Error toggling wantsToTeach: $e');
      }
    } else {
      // If the user canceled, revert the checkbox state
      setState(() {
        wantsToTeach = previousValue;
      });
    }
  }
}
