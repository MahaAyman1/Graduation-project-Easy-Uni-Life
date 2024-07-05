import 'package:appwithapi/Cstum/customTextField.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appwithapi/Cstum/constant.dart';
import 'package:geocoding/geocoding.dart';

import '../Map/MarkerMapPage.dart';

class CustomDropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final String hint;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;

  CustomDropdown({
    required this.items,
    required this.hint,
    this.value,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}

class CustomDateTimePicker extends StatelessWidget {
  final DateTime? initialDateTime;
  final void Function(DateTime?)? onDateTimeChanged;

  CustomDateTimePicker({
    this.initialDateTime,
    this.onDateTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final DateTime now = DateTime.now();
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: initialDateTime ?? now,
          firstDate: now, // Only allow future dates
          lastDate: DateTime(2100),
        );

        if (pickedDate != null) {
          final TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(now),
          );

          if (pickedTime != null) {
            final DateTime selectedDateTime = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              pickedTime.minute,
            );

            // Ensure the selected date and time is in the future
            if (selectedDateTime.isAfter(now)) {
              onDateTimeChanged?.call(selectedDateTime);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please select time of meeting ')),
              );
            }
          }
        }
      },
      child: Text(initialDateTime == null
          ? 'Select Time of meeting '
          : 'Date and Time Selected'),
    );
  }
}

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

  //String _preferredGender = 'Any';
  String? _preferredGender;
  String? _selectedDepartment;
  //= 'Computer and Information Technology';
  String? _selectedMajor;
  String? _selectedSubject;
  double? latitude;
  double? longitude;
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
        'Mobile Application Development',
        'Human-Computer Interaction',
        'Data Science',
      ],
      'Artificial Intelligence': [
        'Machine Learning',
        'Robotics',
        'Deep Learning',
        'AI in Business'
      ]
    },
    'Engineering': {
      'Mechanical Engineering': [
        'Fluid Mechanics',
        'Mechatronics',
        'Automotive Engineering',
      ],
      'Electrical Engineering': [
        'Power Electronics',
        'Control Systems',
        'Digital Electronics',
      ],
    },
  };
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDateTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select time of meeting ')),
        );
        return;
      }

      /* if (_latitude == null || _longitude == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a location')),
        );
        return;
      }*/

      try {
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          DocumentSnapshot userData = await FirebaseFirestore.instance
              .collection('Students')
              .doc(user.uid)
              .get();

          String idNumber = userData['IDNumber'];
          String gender = userData['gender'];

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
            'latitude': latitude,
            'longitude': longitude,
            'gender': gender
          });

          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Vote created!')));
          Navigator.pop(context);
        } else {
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
              latitude = latLng.latitude;
              longitude = latLng.longitude;
              _locationController.text = 'Location Selected';
            });
          },
        ),
      ),
    );

    if (selectedLocation == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please select a location')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(title: Text('Create Vote')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              CustomTextField(
                controller: _questionController,
                hint: 'Session Purpose and Goals',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Goals of this Session ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              CustomTextField(
                controller: _optionAController,
                hint: 'Option 1',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Option 1';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              CustomTextField(
                controller: _optionBController,
                hint: 'Option 2',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Option 2';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              CustomTextField1(
                hint: 'Location',
                controller: _locationController,
                readOnly: true,
                onTap: () async {
                  final location = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MarkerMapPage(
                        onLocationSelected: (location) {
                          setState(() {
                            latitude = location.latitude;
                            longitude = location.longitude;
                          });
                        },
                      ),
                    ),
                  );

                  if (latitude != null && longitude != null) {
                    List<Placemark> placemarks =
                        await placemarkFromCoordinates(latitude!, longitude!);
                    if (placemarks.isNotEmpty) {
                      Placemark place = placemarks[0];
                      _locationController.text =
                          " ${place.subLocality}, ${place.locality}, ${place.country}";
                    }
                  }
                },
              ),
              SizedBox(height: 12),
              CustomDropdown(
                value: _preferredGender,
                items: [
                  'Any',
                  'Male',
                  'Female',
                ],
                hint: 'Preferred Gender',
                onChanged: (value) {
                  setState(() {
                    _preferredGender = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a gender';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              CustomDropdown(
                value: _selectedDepartment,
                items: _departmentMajorSubject.keys.toList(),
                hint: 'Department',
                onChanged: (value) {
                  setState(() {
                    _selectedDepartment = value!;
                    _selectedMajor = null;
                    _selectedSubject = null;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a department';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              if (_selectedDepartment != null)
                CustomDropdown(
                  value: _selectedMajor,
                  items: _departmentMajorSubject[_selectedDepartment]!
                      .keys
                      .toList(),
                  hint: 'Major',
                  onChanged: (value) {
                    setState(() {
                      _selectedMajor = value!;
                      _selectedSubject = null;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a major';
                    }
                    return null;
                  },
                ),
              SizedBox(height: 12),
              if (_selectedDepartment != null && _selectedMajor != null)
                CustomDropdown(
                  value: _selectedSubject,
                  items: _departmentMajorSubject[_selectedDepartment]![
                      _selectedMajor]!,
                  hint: 'Subject',
                  onChanged: (value) {
                    setState(() {
                      _selectedSubject = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a subject';
                    }
                    return null;
                  },
                ),
              SizedBox(height: 12),
              CustomDateTimePicker(
                initialDateTime: _selectedDateTime,
                onDateTimeChanged: (dateTime) {
                  setState(() {
                    _selectedDateTime = dateTime;
                  });
                },
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

class CustomTextField1 extends StatelessWidget {
  final String? label;
  final String hint;
  final int maxLines;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final Function(String)? onChanged;
  final Future<void> Function()? onTap;
  final TextInputType? keyboardType;
  final bool? readOnly;

  CustomTextField1({
    Key? key,
    this.label,
    required this.hint,
    this.maxLines = 1,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.onTap,
    this.readOnly,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            label!,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        if (label != null) SizedBox(height: 8),
        TextFormField(
          obscureText: obscureText,
          onChanged: onChanged,
          controller: controller,
          onSaved: onSaved,
          validator: (value) {
            if (validator != null) {
              return validator!(value);
            } else {
              if (value?.isEmpty ?? true) {
                return 'Field is required';
              } else {
                return null;
              }
            }
          },
          cursorColor: kPrimaryColor,
          maxLines: maxLines,
          onTap: onTap,
          readOnly: readOnly ?? false,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hint,
            border: buildBorder(),
            enabledBorder: buildBorder(kPrimaryColor),
            focusedBorder: buildBorder(kPrimaryColor),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder buildBorder([Color? color]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: color ?? Colors.white),
    );
  }
}
