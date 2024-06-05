/*import 'dart:io';
import 'package:path/path.dart' as p;

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gradution_project/menu.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User _user;
  late String profileImage;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
  }

  Future<void> _uploadImage(List<XFile> files) async {
    final storageRef = FirebaseStorage.instance.ref();

    for (var file in files) {
      final imageFile = File(file.path);
      final imageName =
          p.basename(imageFile.path); // Use p.basename from path package
      final uploadTask = storageRef
          .child('profile_images')
          .child(_user.uid)
          .child(imageName)
          .putFile(imageFile);

      await uploadTask.whenComplete(() => null);

      final imageUrl = await storageRef
          .child('profile_images')
          .child(_user.uid)
          .child(imageName)
          .getDownloadURL();

      // Save the image URL in Firestore
      await FirebaseFirestore.instance
          .collection('Students')
          .doc(_user.uid)
          .update({
        'profileImageUrl': imageUrl,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6F3F3),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('Students')
            .doc(_user.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>?;

          if (userData == null) {
            return Center(child: Text('User data not found'));
          }

          // Check if user has a profile image URL, otherwise use default image based on gender
          var profileImageUrl = userData['profileImageUrl'];
          if (profileImageUrl == null) {
            final gender = userData['gender'];
            profileImageUrl = gender == 'male'
                ? 'https://i.pinimg.com/564x/22/ce/12/22ce126b77afdd24a5994ecb51736887.jpg'
                : 'https://i.pinimg.com/736x/8b/1f/9f/8b1f9f145889835124f968a6aa82b79f.jpg';
          }
          return SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 100), // Adjust spacing as needed
                  // Display profile image
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(profileImageUrl),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final picker = ImagePicker();
                      final pickedFile =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        _uploadImage([
                          pickedFile
                        ]); // Pass pickedFile in a list to _uploadImage
                      }
                    },
                    child: Text('Change Profile Picture'),
                  ),
                  Text(
                    '${userData['firstName']} ${userData['lastName']}' ?? 'N/A',
                    style: const TextStyle(
                      fontFamily: "Montserrat",
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    userData['major'] ?? 'N/A',
                    style: const TextStyle(
                      fontFamily: "Montserrat",
                      color: Color(0xFF111236),
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 24,
                      right: 24,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "PROFILE",
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            color: Color(0xFF111236),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 16),
                        listProfile(Icons.person, "Full Name",
                            '${userData['firstName']} ${userData['lastName']}'),
                        listProfile(
                            Icons.email, "Email", userData['email'] ?? 'N/A'),
                        listProfile(Icons.phone, "Phone Number",
                            userData['phoneNumber'] ?? 'N/A'),
                        listProfile(Icons.female, "Gender",
                            userData['gender'] ?? 'N/A'),
                        listProfile(Icons.school, "Department",
                            userData['Department'] ?? 'N/A'),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Students')
                              .doc(_user.uid)
                              .collection('TeachingSubjects')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }

                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            }

                            var subjects = <Widget>[];
                            snapshot.data!.docs.forEach((doc) {
                              var subjectData =
                                  doc.data() as Map<String, dynamic>;
                              var subjectWidget = listProfile(
                                  Icons.subject,
                                  subjectData['subject'],
                                  'Price: ${subjectData['price']}, Prefer Online: ${subjectData['preferOnline']}');
                              subjects.add(subjectWidget);
                            });

                            return Column(children: subjects);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      drawer: Menu(),
    );
  }

  Widget listProfile(IconData icon, String text1, String? text2) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
          ),
          const SizedBox(
            width: 24,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text1,
                style: const TextStyle(
                  color: Color(0xFF111236),
                  fontFamily: "Montserrat",
                  fontSize: 14,
                ),
              ),
              Text(
                text2 ?? 'N/A', // Display 'N/A' if text2 is null
                style: const TextStyle(
                  color: Color(0xFF111236),
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
*/
/*import 'dart:io';
import 'package:gradution_project/constant.dart';
import 'package:path/path.dart' as p;

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gradution_project/menu.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User _user;
  late String profileImage;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    profileImage = ''; // Initialize profileImage as empty
  }

  Future<void> _uploadImage(List<XFile> files) async {
    final storageRef = FirebaseStorage.instance.ref();

    for (var file in files) {
      final imageFile = File(file.path);
      final imageName =
          p.basename(imageFile.path); // Use p.basename from path package
      final uploadTask = storageRef
          .child('profile_images')
          .child(_user.uid)
          .child(imageName)
          .putFile(imageFile);

      await uploadTask.whenComplete(() => null);

      final imageUrl = await storageRef
          .child('profile_images')
          .child(_user.uid)
          .child(imageName)
          .getDownloadURL();

      // Save the image URL in Firestore
      await FirebaseFirestore.instance
          .collection('Students')
          .doc(_user.uid)
          .update({
        'profileImageUrl': imageUrl,
      });

      setState(() {
        profileImage = imageUrl; // Update profileImage with the new URL
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6F3F3),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('Students')
            .doc(_user.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>?;

          if (userData == null) {
            return Center(child: Text('User data not found'));
          }

          // Check if user has a profile image URL, otherwise use default image based on gender
          var profileImageUrl = userData['profileImageUrl'];
          if (profileImageUrl == null) {
            final gender = userData['gender'];
            profileImageUrl = gender == 'male'
                ? 'https://i.pinimg.com/564x/22/ce/12/22ce126b77afdd24a5994ecb51736887.jpg'
                : 'https://i.pinimg.com/736x/8b/1f/9f/8b1f9f145889835124f968a6aa82b79f.jpg';
          }

          profileImage =
              profileImageUrl; // Set profileImage to the URL from Firestore

          return SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 100), // Adjust spacing as needed
                  // Display profile image
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(profileImage),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final picker = ImagePicker();
                      final pickedFile =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        _uploadImage([
                          pickedFile
                        ]); // Pass pickedFile in a list to _uploadImage
                      }
                    },
                    child: Icon(
                      Icons.edit,
                      color: kPrimaryColor,
                    ),
                  ),
                  Text(
                    '${userData['firstName']} ${userData['lastName']}' ?? 'N/A',
                    style: const TextStyle(
                      fontFamily: "Montserrat",
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    userData['major'] ?? 'N/A',
                    style: const TextStyle(
                      fontFamily: "Montserrat",
                      color: Color(0xFF111236),
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 24,
                      right: 24,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "PROFILE",
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            color: Color(0xFF111236),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 16),
                        listProfile(Icons.person, "Full Name",
                            '${userData['firstName']} ${userData['lastName']}'),
                        listProfile(
                            Icons.email, "Email", userData['email'] ?? 'N/A'),
                        listProfile(Icons.phone, "Phone Number",
                            userData['phoneNumber'] ?? 'N/A'),
                        listProfile(Icons.female, "Gender",
                            userData['gender'] ?? 'N/A'),
                        listProfile(Icons.school, "Department",
                            userData['Department'] ?? 'N/A'),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Students')
                              .doc(_user.uid)
                              .collection('TeachingSubjects')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }

                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            }

                            var subjects = <Widget>[];
                            snapshot.data!.docs.forEach((doc) {
                              var subjectData =
                                  doc.data() as Map<String, dynamic>;
                              var subjectWidget = listProfile(
                                  Icons.subject,
                                  subjectData['subject'],
                                  'Price: ${subjectData['price']}, Prefer Online: ${subjectData['preferOnline']}');
                              subjects.add(subjectWidget);
                            });

                            return Column(children: subjects);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      drawer: Menu(),
    );
  }

  Widget listProfile(IconData icon, String text1, String? text2) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
          ),
          const SizedBox(
            width: 24,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text1,
                style: const TextStyle(
                  color: Color(0xFF111236),
                  fontFamily: "Montserrat",
                  fontSize: 14,
                ),
              ),
              Text(
                text2 ?? 'N/A', // Display 'N/A' if text2 is null
                style: const TextStyle(
                  color: Color(0xFF111236),
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
*/
import 'dart:io';
import 'package:appwithapi/Cstum/constant.dart';
import 'package:appwithapi/Cstum/menu.dart';
import 'package:path/path.dart' as p;

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User _user;
  late String profileImage;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    profileImage = ''; // Initialize profileImage as empty
  }

  Future<void> _uploadImage(List<XFile> files) async {
    final storageRef = FirebaseStorage.instance.ref();

    if (files.isEmpty) {
      // No image selected, set profileImageUrl based on gender
      final userData = await FirebaseFirestore.instance
          .collection('Students')
          .doc(_user.uid)
          .get()
          .then((snapshot) => snapshot.data() as Map<String, dynamic>);

      final gender = userData['gender'];
      final defaultImageUrl = gender == 'Male'
          ? 'https://i.pinimg.com/564x/22/ce/12/22ce126b77afdd24a5994ecb51736887.jpg'
          : 'https://i.pinimg.com/736x/8b/1f/9f/8b1f9f145889835124f968a6aa82b79f.jpg';

      await FirebaseFirestore.instance
          .collection('Students')
          .doc(_user.uid)
          .set({'profileImageUrl': defaultImageUrl});

      setState(() {
        profileImage = defaultImageUrl;
      });
    } else {
      for (var file in files) {
        final imageFile = File(file.path);
        final imageName = p.basename(imageFile.path);
        final uploadTask = storageRef
            .child('profile_images')
            .child(_user.uid)
            .child(imageName)
            .putFile(imageFile);

        await uploadTask.whenComplete(() => null);

        final imageUrl = await storageRef
            .child('profile_images')
            .child(_user.uid)
            .child(imageName)
            .getDownloadURL();

        await FirebaseFirestore.instance
            .collection('Students')
            .doc(_user.uid)
            .update({'profileImageUrl': imageUrl});

        setState(() {
          profileImage = imageUrl;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6F3F3),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('Students')
            .doc(_user.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>?;

          if (userData == null) {
            return Center(child: Text('User data not found'));
          }

          // Check if user has a profile image URL, otherwise use default image based on gender
          var profileImageUrl = userData['profileImageUrl'];
          if (profileImageUrl == null) {
            final gender = userData['gender'];
            profileImageUrl = gender == 'male'
                ? 'https://i.pinimg.com/564x/22/ce/12/22ce126b77afdd24a5994ecb51736887.jpg'
                : 'https://i.pinimg.com/736x/8b/1f/9f/8b1f9f145889835124f968a6aa82b79f.jpg';
          }

          profileImage =
              profileImageUrl; // Set profileImage to the URL from Firestore

          return SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 100), // Adjust spacing as needed
                  // Display profile image
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(profileImage),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final picker = ImagePicker();
                      final pickedFile =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        _uploadImage([
                          pickedFile
                        ]); // Pass pickedFile in a list to _uploadImage
                      }
                    },
                    child: Icon(
                      Icons.edit,
                      color: kPrimaryColor,
                    ),
                  ),
                  Text(
                    '${userData['firstName']} ${userData['lastName']}' ?? 'N/A',
                    style: const TextStyle(
                      fontFamily: "Montserrat",
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    userData['major'] ?? 'N/A',
                    style: const TextStyle(
                      fontFamily: "Montserrat",
                      color: Color(0xFF111236),
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 24,
                      right: 24,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "PROFILE",
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            color: Color(0xFF111236),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 16),
                        listProfile(Icons.person, "Full Name",
                            '${userData['firstName']} ${userData['lastName']}'),
                        listProfile(
                            Icons.email, "Email", userData['email'] ?? 'N/A'),
                        listProfile(Icons.phone, "Phone Number",
                            userData['phoneNumber'] ?? 'N/A'),
                        listProfile(Icons.female, "Gender",
                            userData['gender'] ?? 'N/A'),
                        listProfile(Icons.school, "Department",
                            userData['Department'] ?? 'N/A'),
                        /*StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Students')
                              .doc(_user.uid)
                              .collection('TeachingSubjects')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }

                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            }

                            var subjects = <Widget>[];
                            snapshot.data!.docs.forEach((doc) {
                              var subjectData =
                                  doc.data() as Map<String, dynamic>;
                              var subjectWidget = listProfile(
                                  Icons.subject,
                                  subjectData['subject'],
                                  'Price: ${subjectData['price']}, Prefer Online: ${subjectData['preferOnline']}');
                              subjects.add(subjectWidget);
                            });

                            return Column(children: subjects);
                          },
                        ),*/
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Students')
                              .doc(_user.uid)
                              .collection('TeachingSubjects')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }

                            if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            }

                            var subjects = <Widget>[];
                            snapshot.data!.docs.forEach((doc) {
                              var subjectData =
                                  doc.data() as Map<String, dynamic>;
                              var subjectWidget = listProfile(
                                  Icons.book,
                                  subjectData['subject'],
                                  null); // Pass null for text2 to omit displaying price and preferOnline
                              subjects.add(subjectWidget);
                            });

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: subjects,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      drawer: Menu(),
    );
  }

  Widget listProfile(IconData icon, String text1, String? text2) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
          ),
          const SizedBox(
            width: 24,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text1,
                style: const TextStyle(
                  color: Color(0xFF111236),
                  fontFamily: "Montserrat",
                  fontSize: 14,
                ),
              ),
              Text(
                text2 ?? '', // Display 'N/A' if text2 is null
                style: const TextStyle(
                  color: Color(0xFF111236),
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
