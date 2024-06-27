import 'dart:io';

import 'package:appwithapi/Cstum/constant.dart';
import 'package:appwithapi/Cstum/customTextField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import 'package:image_picker/image_picker.dart';

import '../Map/MarkerMapPage.dart';

class AddHousePage extends StatefulWidget {
  @override
  _AddHousePageState createState() => _AddHousePageState();
}

class _AddHousePageState extends State<AddHousePage> {
  final TextEditingController houseNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController numRoomsController = TextEditingController();
  final TextEditingController numBathroomsController = TextEditingController();
  final TextEditingController numOccupantsController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  double? latitude;
  double? longitude;
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController additionalDetailsController1 =
      TextEditingController();

  bool isAvailable = true;
  bool hasFreeInternet = false;
  List<String> imageUrls = [];
  String? selectedGender;
  bool Notavailable = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    List<XFile>? images = await picker.pickMultiImage();
    if (images != null) {
      for (var image in images) {
        setState(() {
          imageUrls.add(image.path);
        });
        print('Added image: ${image.path}');
      }
    }
  }

  void _validateAndAddHouse() {
    if (_formKey.currentState!.validate()) {
      _addHouse();
    }
  }

  void _addHouse() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      List<String> uploadedImageUrls = [];
      for (var imagePath in imageUrls) {
        File imageFile = File(imagePath);
        if (imageFile.existsSync()) {
          try {
            String uploadedImageUrl =
                await firestoreService.uploadImage(imageFile);
            uploadedImageUrls.add(uploadedImageUrl);
          } catch (error) {
            print('Error uploading image: $error');
          }
        } else {
          print('File does not exist: $imagePath');
        }
      }

      final houseData = {
        'userId': user.uid,
        'houseName': houseNameController.text,
        'price': double.parse(priceController.text),
        'numRooms': int.parse(numRoomsController.text),
        'numBathrooms': int.parse(numBathroomsController.text),
        'gender': selectedGender,
        'numOccupants': int.parse(numOccupantsController.text),
        'email': user.email,
        'imageUrls': uploadedImageUrls,
        'location': locationController.text,
        'latitude': latitude,
        'longitude': longitude,
        'isAvailable': isAvailable,
        'hasFreeInternet': hasFreeInternet,
        //'Notavailable':Notavailable,
        'additionalDetails': additionalDetailsController1.text.isNotEmpty
            ? additionalDetailsController1.text
            : null,
      };

      await firestoreService.addHouse(user.uid, houseData);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Add House',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                CustomTextField(
                  hint: 'House Name',
                  controller: houseNameController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'House name is required';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 20),
                CustomTextField(
                  hint: 'Price',
                  controller: priceController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Price is required';
                    } else if (double.tryParse(value!) == null) {
                      return 'Enter a valid price';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 20),
                CustomTextField(
                  hint: 'Number of Rooms',
                  controller: numRoomsController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Number of rooms is required';
                    } else if (int.tryParse(value!) == null) {
                      return 'Enter a valid number';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 20),
                CustomTextField(
                  hint: 'Number of Bathrooms',
                  controller: numBathroomsController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Number of bathrooms is required';
                    } else if (int.tryParse(value!) == null) {
                      return 'Enter a valid number';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 20),
                CustomTextField(
                  hint: 'Number of Occupants',
                  controller: numOccupantsController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Number of occupants is required';
                    } else if (int.tryParse(value!) == null) {
                      return 'Enter a valid number';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    border: Border.all(color: kPrimaryColor),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DropdownButtonFormField<String>(
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 40,
                      elevation: 16,
                      hint: Text('Select Gender'),
                      value: selectedGender,
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a gender';
                        } else {
                          return null;
                        }
                      },
                      items: [
                        DropdownMenuItem(
                          value: 'female',
                          child: Text(
                            'Female',
                            style: TextStyle(
                                color: const Color.fromARGB(255, 98, 97, 97)),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'male',
                          child: Text(
                            'Male',
                            style: TextStyle(
                                color: const Color.fromARGB(255, 98, 97, 97)),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'male and female',
                          child: Text(
                            'Male and female',
                            style: TextStyle(
                                color: const Color.fromARGB(255, 98, 97, 97)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(height: 20),
                CustomTextField(
                  hint: 'Location',
                  controller: locationController,
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
                        locationController.text =
                            " ${place.subLocality}, ${place.locality}, ${place.country}";
                      }
                    }
                  },
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: isAvailable,
                      onChanged: (value) {
                        setState(() {
                          isAvailable = value!;
                        });
                      },
                    ),
                    Text('Available')
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: hasFreeInternet,
                      onChanged: (value) {
                        setState(() {
                          hasFreeInternet = value!;
                        });
                      },
                    ),
                    Text('Free internet')
                  ],
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Additional Details (optional)',
                    // hintText: 'Include any extra details of the house , for example if it has free internet or not or any details ',
                    hintText: 'Include any extra details of the house',
                  ),
                  controller: additionalDetailsController1,
                  maxLines: 3,
                ),
                SizedBox(height: 40),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: MaterialButton(
                    onPressed: _pickImages,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload_outlined),
                        SizedBox(width: 2),
                        Text('Upload Image'),
                      ],
                    ),
                  ),
                ),
                if (imageUrls.isNotEmpty)
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: imageUrls.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.file(
                            File(imageUrls[index]),
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                SizedBox(height: 30),
                SizedBox(height: 20),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _validateAndAddHouse,
                    child: Text('Add House'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<void> addHouse(String userId, Map<String, dynamic> houseData) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('houses')
        .add(houseData);
  }

  Future<String> uploadImage(File imageFile) async {
    String fileName =
        'images/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg';
    TaskSnapshot taskSnapshot =
        await _firebaseStorage.ref(fileName).putFile(imageFile);
    return await taskSnapshot.ref.getDownloadURL();
  }
}

class CustomTextField extends StatelessWidget {
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

  CustomTextField({
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
