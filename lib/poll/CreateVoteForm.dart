/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateVoteForm extends StatefulWidget {
  @override
  _CreateVoteFormState createState() => _CreateVoteFormState();
}

class _CreateVoteFormState extends State<CreateVoteForm> {
  final _formKey = GlobalKey<FormState>();
  final _optionAController = TextEditingController();
  final _optionBController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('Votes').add({
          'studentId': 'studentId123', // Replace with the actual student ID
          'optionA': _optionAController.text,
          'optionB': _optionBController.text,
          'optionAVotes': 0,
          'optionBVotes': 0,
          'optionAVoters': [],
          'optionBVoters': [],
        });

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Vote created!')));
        Navigator.pop(context); // Close the form after submission
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to create vote: $e')));
      }
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
                controller: _optionAController,
                decoration: InputDecoration(labelText: 'Option A'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter Option A' : null,
              ),
              TextFormField(
                controller: _optionBController,
                decoration: InputDecoration(labelText: 'Option B'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter Option B' : null,
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

/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateVoteForm extends StatefulWidget {
  @override
  _CreateVoteFormState createState() => _CreateVoteFormState();
}

class _CreateVoteFormState extends State<CreateVoteForm> {
  final _formKey = GlobalKey<FormState>();
  final _optionAController = TextEditingController();
  final _optionBController = TextEditingController();
  final _questionController = TextEditingController();
  final _timeController = TextEditingController();
  final _subjectController = TextEditingController();
  final _locationController = TextEditingController();
  String _preferredGender = 'Any';

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('Votes').add({
          'studentId': 'studentId123', // Replace with the actual student ID
          'question': _questionController.text,
          'optionA': _optionAController.text,
          'optionB': _optionBController.text,
          'optionAVotes': 0,
          'optionBVotes': 0,
          'optionAVoters': [],
          'optionBVoters': [],
          'time': _timeController.text,
          'subject': _subjectController.text,
          'location': _locationController.text,
          'preferredGender': _preferredGender,
        });

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Vote created!')));
        Navigator.pop(context); // Close the form after submission
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to create vote: $e')));
      }
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
                decoration: InputDecoration(labelText: 'Question'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the question' : null,
              ),
              TextFormField(
                controller: _optionAController,
                decoration: InputDecoration(labelText: 'Option A'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter Option A' : null,
              ),
              TextFormField(
                controller: _optionBController,
                decoration: InputDecoration(labelText: 'Option B'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter Option B' : null,
              ),
              TextFormField(
                controller: _timeController,
                decoration: InputDecoration(labelText: 'Time'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter Time' : null,
              ),
              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(labelText: 'Subject'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter Subject' : null,
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter Location' : null,
              ),
              DropdownButtonFormField<String>(
                value: _preferredGender,
                onChanged: (String? newValue) {
                  setState(() {
                    _preferredGender = newValue!;
                  });
                },
                items: <String>['Any', 'Male', 'Female']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Preferred Gender'),
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
/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateVoteForm extends StatefulWidget {
  @override
  _CreateVoteFormState createState() => _CreateVoteFormState();
}

class _CreateVoteFormState extends State<CreateVoteForm> {
  final _formKey = GlobalKey<FormState>();
  final _optionAController = TextEditingController();
  final _optionBController = TextEditingController();
  final _questionController = TextEditingController();
  final _subjectController = TextEditingController();
  final _locationController = TextEditingController();
  String _selectedTime = 'Year';
  String _preferredGender = 'Any';

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('Votes').add({
          'studentId': 'studentId123', // Replace with the actual student ID
          'question': _questionController.text,
          'optionA': _optionAController.text,
          'optionB': _optionBController.text,
          'optionAVotes': 0,
          'optionBVotes': 0,
          'optionAVoters': [],
          'optionBVoters': [],
          'subject': _subjectController.text,
          'location': _locationController.text,
          'preferredGender': _preferredGender,
          'time': _selectedTime,
        });

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Vote created!')));
        Navigator.pop(context); // Close the form after submission
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to create vote: $e')));
      }
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
                decoration: InputDecoration(labelText: 'Question'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a question' : null,
              ),
              TextFormField(
                controller: _optionAController,
                decoration: InputDecoration(labelText: 'Option A'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter Option A' : null,
              ),
              TextFormField(
                controller: _optionBController,
                decoration: InputDecoration(labelText: 'Option B'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter Option B' : null,
              ),
              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(labelText: 'Subject'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a subject' : null,
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a location' : null,
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

/*import 'package:appwithapi/Map/MarkerMapPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final _subjectController = TextEditingController();
  final _locationController = TextEditingController();
  String _selectedTime = 'Year';
  String _preferredGender = 'Any';

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('Votes').add({
          'studentId': 'studentId123', // Replace with the actual student ID
          'question': _questionController.text,
          'optionA': _optionAController.text,
          'optionB': _optionBController.text,
          'optionAVotes': 0,
          'optionBVotes': 0,
          'optionAVoters': [],
          'optionBVoters': [],
          'subject': _subjectController.text,
          'location': _locationController.text,
          'preferredGender': _preferredGender,
          'time': _selectedTime,
        });

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Vote created!')));
        Navigator.pop(context); // Close the form after submission
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to create vote: $e')));
      }
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
                decoration: InputDecoration(labelText: 'Question'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a question' : null,
              ),
              TextFormField(
                controller: _optionAController,
                decoration: InputDecoration(labelText: 'Option A'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter Option A' : null,
              ),
              TextFormField(
                controller: _optionBController,
                decoration: InputDecoration(labelText: 'Option B'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter Option B' : null,
              ),
              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(labelText: 'Subject'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a subject' : null,
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MarkerMapPage(
                            onLocationSelected: (selectedLocation) {
                              setState(() {
                                _locationController.text = selectedLocation;
                              });
                            },
                          ),
                        ),
                      );
                    },
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
/*import 'package:appwithapi/Map/MarkerMapPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final _subjectController = TextEditingController();
  final _locationController = TextEditingController();
  String _selectedTime = 'Year';
  String _preferredGender = 'Any';
  double? _latitude;
  double? _longitude;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('Votes').add({
          'studentId': 'studentId123', // Replace with the actual student ID
          'question': _questionController.text,
          'optionA': _optionAController.text,
          'optionB': _optionBController.text,
          'optionAVotes': 0,
          'optionBVotes': 0,
          'optionAVoters': [],
          'optionBVoters': [],
          'subject': _subjectController.text,
          'location': _locationController.text,
          'preferredGender': _preferredGender,
          'time': _selectedTime,
          'latitude': _latitude,
          'longitude': _longitude,
        });

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Vote created!')));
        Navigator.pop(context); // Close the form after submission
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
                decoration: InputDecoration(labelText: 'Question'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a question' : null,
              ),
              TextFormField(
                controller: _optionAController,
                decoration: InputDecoration(labelText: 'Option A'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter Option A' : null,
              ),
              TextFormField(
                controller: _optionBController,
                decoration: InputDecoration(labelText: 'Option B'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter Option B' : null,
              ),
              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(labelText: 'Subject'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a subject' : null,
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
import 'package:appwithapi/Map/MarkerMapPage.dart';
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
  final _subjectController = TextEditingController();
  final _locationController = TextEditingController();
  String _selectedTime = 'Year';
  String _preferredGender = 'Any';
  double? _latitude;
  double? _longitude;

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
          String Department = userData['Department'];

          await FirebaseFirestore.instance.collection('Votes').add({
            'studentId': idNumber,
            'Department': Department,
            'question': _questionController.text,
            'optionA': _optionAController.text,
            'optionB': _optionBController.text,
            'optionAVotes': 0,
            'optionBVotes': 0,
            'optionAVoters': [],
            'optionBVoters': [],
            'subject': _subjectController.text,
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
                decoration: InputDecoration(labelText: 'Question'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a question' : null,
              ),
              TextFormField(
                controller: _optionAController,
                decoration: InputDecoration(labelText: 'Option A'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter Option A' : null,
              ),
              TextFormField(
                controller: _optionBController,
                decoration: InputDecoration(labelText: 'Option B'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter Option B' : null,
              ),
              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(labelText: 'Subject'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a subject' : null,
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
