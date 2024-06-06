/*import 'package:appwithapi/Map/MarkerMapPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateVoteForm extends StatefulWidget {
  @override
  _CreateVoteFormState createState() => _CreateVoteFormState();
}

class _CreateVoteFormState extends State<CreateVoteForm> {
  final _formKey = GlobalKey<FormState>();
  final _optionAController = TextEditingController();
  final _optionBController = TextEditingController();
  final _questionController = TextEditingController();
  final _locationController = TextEditingController();
  String _selectedTime = 'Year';
  String _preferredGender = 'Any';
  String _selectedDepartment =
      'Computer and Information Technology'; // Default value
  String? _selectedMajor;
  String? _selectedSubject;
  double? _latitude;
  double? _longitude;

  final Map<String, Map<String, List<String>>> _departmentMajorSubject = {
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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Retrieve the authenticated user
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          DocumentSnapshot userData = await FirebaseFirestore.instance
              .collection('Students')
              .doc(user.uid)
              .get();

          String idNumber = userData['IDNumber'];
          String gender = userData['gender'];
          String department = userData['Department'];

          await FirebaseFirestore.instance.collection('Votes').add({
            'studentId': idNumber,
            'Department': _selectedDepartment,
            'Major': _selectedMajor,
            'Subject': _selectedSubject,
            'question': _questionController.text,
            'optionA': _optionAController.text,
            'optionB': _optionBController.text,
            'optionAVotes': 0,
            'optionBVotes': 0,
            'optionAVoters': [],
            'optionBVoters': [],
            'location': _locationController.text,
            'preferredGender': _preferredGender,
            'time': _selectedTime,
            'latitude': _latitude,
            'longitude': _longitude,
            'gender': gender
          });

          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Vote created!')));
          Navigator.pop(context); // Close the form after submission
        } else {
          // Handle the case where the user is not authenticated
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('User is not authenticated. Please sign in.')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to create vote: $e')));
      }
    }
  }

  void _selectLocation() async {
    final selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MarkerMapPage(
          onLocationSelected: (latLng) {
            setState(() {
              _latitude = latLng.latitude;
              _longitude = latLng.longitude;
              _locationController.text = 'Selected Location';
            });
          },
        ),
      ),
    );

    if (selectedLocation != null) {
      setState(() {
        _locationController.text = 'Location Selected';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Vote')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _questionController,
                decoration: InputDecoration(
                    labelText: ' Describe session purpose and goals'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a question' : null,
              ),
              TextFormField(
                controller: _optionAController,
                decoration: InputDecoration(labelText: 'Option 1'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter Option A' : null,
              ),
              TextFormField(
                controller: _optionBController,
                decoration: InputDecoration(labelText: 'Option 2'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter Option B' : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(labelText: 'Location'),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter a location' : null,
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _selectLocation,
                    child: Text('Pick Location'),
                  ),
                ],
              ),
              DropdownButtonFormField<String>(
                value: _selectedTime,
                items: ['Year', 'Month', 'Day', 'Clock']
                    .map((time) => DropdownMenuItem(
                          child: Text(time),
                          value: time,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTime = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Time'),
                validator: (value) =>
                    value == null ? 'Please select a time' : null,
              ),
              DropdownButtonFormField<String>(
                value: _preferredGender,
                items: ['Any', 'Male', 'Female']
                    .map((gender) => DropdownMenuItem(
                          child: Text(gender),
                          value: gender,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _preferredGender = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Preferred Gender'),
                validator: (value) =>
                    value == null ? 'Please select a gender' : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedDepartment,
                items: _departmentMajorSubject.keys
                    .map((department) => DropdownMenuItem(
                          child: Text(department),
                          value: department,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDepartment = value!;
                    _selectedMajor =
                        null; // Reset major when department changes
                    _selectedSubject =
                        null; // Reset subject                    when department changes
                  });
                },
                decoration: InputDecoration(labelText: 'Department'),
                validator: (value) =>
                    value == null ? 'Please select a department' : null,
              ),
              if (_selectedDepartment != null)
                DropdownButtonFormField<String>(
                  value: _selectedMajor,
                  items: _departmentMajorSubject[_selectedDepartment]!
                      .keys
                      .map((major) => DropdownMenuItem(
                            child: Text(major),
                            value: major,
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedMajor = value!;
                      _selectedSubject =
                          null; // Reset subject when major changes
                    });
                  },
                  decoration: InputDecoration(labelText: 'Major'),
                  validator: (value) =>
                      value == null ? 'Please select a major' : null,
                ),
              if (_selectedDepartment != null && _selectedMajor != null)
                DropdownButtonFormField<String>(
                  value: _selectedSubject,
                  items: _departmentMajorSubject[_selectedDepartment]![
                          _selectedMajor]!
                      .map((subject) => DropdownMenuItem(
                            child: Text(subject),
                            value: subject,
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSubject = value!;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Subject'),
                  validator: (value) =>
                      value == null ? 'Please select a subject' : null,
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Create Vote'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appwithapi/Map/MarkerMapPage.dart';

class CreateVoteForm extends StatefulWidget {
  @override
  _CreateVoteFormState createState() => _CreateVoteFormState();
}

class _CreateVoteFormState extends State<CreateVoteForm> {
  final _formKey = GlobalKey<FormState>();
  final _optionAController = TextEditingController();
  final _optionBController = TextEditingController();
  final _questionController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime? _selectedDateTime;

  // String _selectedTime = 'Year';
  String _preferredGender = 'Any';
  String _selectedDepartment =
      'Computer and Information Technology'; // Default value
  String? _selectedMajor;
  String? _selectedSubject;
  double? _latitude;
  double? _longitude;

  final Map<String, Map<String, List<String>>> _departmentMajorSubject = {
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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Retrieve the authenticated user
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          DocumentSnapshot userData = await FirebaseFirestore.instance
              .collection('Students')
              .doc(user.uid)
              .get();

          String idNumber = userData['IDNumber'];
          String gender = userData['gender'];
          // String department = userData['Department'];

          await FirebaseFirestore.instance.collection('Votes').add({
            'studentId': idNumber,
            'Department': _selectedDepartment,
            'Major': _selectedMajor,
            'Subject': _selectedSubject,
            'question': _questionController.text,
            'optionA': _optionAController.text,
            'optionB': _optionBController.text,
            'optionAVotes': 0,
            'optionBVotes': 0,
            'optionAVoters': [],
            'optionBVoters': [],
            'location': _locationController.text,
            'preferredGender': _preferredGender,
            'time': _selectedDateTime,
            'latitude': _latitude,
            'longitude': _longitude,
            'gender': gender
          });

          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Vote created!')));
          Navigator.pop(context); // Close the form after submission
        } else {
          // Handle the case where the user is not authenticated
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('User is not authenticated. Please sign in.')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to create vote: $e')));
      }
    }
  }

  void _selectLocation() async {
    final selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MarkerMapPage(
          onLocationSelected: (latLng) {
            setState(() {
              _latitude = latLng.latitude;
              _longitude = latLng.longitude;
              _locationController.text = 'Selected Location';
            });
          },
        ),
      ),
    );

    if (selectedLocation != null) {
      setState(() {
        _locationController.text = 'Location Selected';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Vote')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _questionController,
                decoration: InputDecoration(
                    labelText: ' Describe session purpose and goals'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a question' : null,
              ),
              TextFormField(
                controller: _optionAController,
                decoration: InputDecoration(labelText: 'Option 1'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter Option A' : null,
              ),
              TextFormField(
                controller: _optionBController,
                decoration: InputDecoration(labelText: 'Option 2'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter Option B' : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(labelText: 'Location'),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter a location' : null,
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _selectLocation,
                    child: Text('Pick Location'),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  final DateTime? pickedDateTime = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDateTime != null) {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        _selectedDateTime = DateTime(
                          pickedDateTime.year,
                          pickedDateTime.month,
                          pickedDateTime.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                      });
                    }
                  }
                },
                child: Text('Select Date and Time'),
              ),
              DropdownButtonFormField<String>(
                value: _preferredGender,
                items: ['Any', 'Male', 'Female']
                    .map((gender) => DropdownMenuItem(
                          child: Text(gender),
                          value: gender,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _preferredGender = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Preferred Gender'),
                validator: (value) =>
                    value == null ? 'Please select a gender' : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedDepartment,
                items: _departmentMajorSubject.keys
                    .map((department) => DropdownMenuItem(
                          child: Text(department),
                          value: department,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDepartment = value!;
                    _selectedMajor =
                        null; // Reset major when department changes
                    _selectedSubject =
                        null; // Reset subject when department changes
                  });
                },
                decoration: InputDecoration(labelText: 'Department'),
                validator: (value) =>
                    value == null ? 'Please select a department' : null,
              ),
              if (_selectedDepartment != null)
                DropdownButtonFormField<String>(
                  value: _selectedMajor,
                  items: _departmentMajorSubject[_selectedDepartment]!
                      .keys
                      .map((major) => DropdownMenuItem(
                            child: Text(major),
                            value: major,
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedMajor = value!;
                      _selectedSubject =
                          null; // Reset subject when major changes
                    });
                  },
                  decoration: InputDecoration(labelText: 'Major'),
                  validator: (value) =>
                      value == null ? 'Please select a major' : null,
                ),
              if (_selectedDepartment != null && _selectedMajor != null)
                DropdownButtonFormField<String>(
                  value: _selectedSubject,
                  items: _departmentMajorSubject[_selectedDepartment]![
                          _selectedMajor]!
                      .map((subject) => DropdownMenuItem(
                            child: Text(subject),
                            value: subject,
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSubject = value!;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Subject'),
                  validator: (value) =>
                      value == null ? 'Please select a subject' : null,
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Create Vote'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
