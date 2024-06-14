import 'dart:io';
import 'package:appwithapi/Cstum/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/painting.dart';

class AddBookPage extends StatefulWidget {
  final String? collegeId;
  final String? departmentId;

  AddBookPage({Key? key, this.collegeId, this.departmentId});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController bookNameController = TextEditingController();
  final TextEditingController bookPriceController = TextEditingController();
  final TextEditingController additionalDetailsController =
      TextEditingController();
  List<String> imageUrls = [];
  final FirestoreService firestoreService = FirestoreService();
  String bookStatus = 'New'; // Default status

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    List<XFile>? images = await picker.pickMultiImage();
    if (images != null) {
      setState(() {
        imageUrls = images.map((image) => image.path).toList();
      });
      print('Added images: $imageUrls');
    }
  }

  Future<List<String>> _uploadImages() async {
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
    return uploadedImageUrls;
  }

  Future<void> addBookToFirestore(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      List<String> uploadedImageUrls = await _uploadImages();

      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // Generate a new document ID
        DocumentReference docRef = FirebaseFirestore.instance
            .collection('Colleges')
            .doc(widget.collegeId)
            .collection('Departments')
            .doc(widget.departmentId)
            .collection('Books')
            .doc();

        String bookId = docRef.id;

        await docRef.set({
          'bookId': bookId,
          'bookName': bookNameController.text,
          'bookPrice': bookPriceController.text,
          'imageUrls': uploadedImageUrls,
          'email': currentUser.email, // Use authenticated user's email
          'userId': currentUser.uid,
          'bookStatus': bookStatus,
          'additionalDetails': additionalDetailsController.text,
          'collegeId': widget.collegeId,
          'departmentId': widget.departmentId,
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Book added successfully!'),
        ));

        bookNameController.clear();
        bookPriceController.clear();
        additionalDetailsController.clear();
        setState(() {
          imageUrls.clear();
          bookStatus = 'New'; // Reset status
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Add Book', style: TextStyle(color: Colors.white)),
        backgroundColor: kPrimaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Book Name'),
                  controller: bookNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter book name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Book Price'),
                  controller: bookPriceController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter book price';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Book Status'),
                    Column(
                      children: [
                        RadioListTile<String>(
                          title: const Text('New'),
                          value: 'New',
                          groupValue: bookStatus,
                          onChanged: (value) {
                            setState(() {
                              bookStatus = value!;
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('Good'),
                          value: 'Good',
                          groupValue: bookStatus,
                          onChanged: (value) {
                            setState(() {
                              bookStatus = value!;
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('Half-half'),
                          value: 'Half-half',
                          groupValue: bookStatus,
                          onChanged: (value) {
                            setState(() {
                              bookStatus = value!;
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('Bad'),
                          value: 'Bad',
                          groupValue: bookStatus,
                          onChanged: (value) {
                            setState(() {
                              bookStatus = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Additional Details (optional)',
                    hintText:
                        'Include any extra details or mention the book name that you want to exchange it with your book',
                  ),
                  controller: additionalDetailsController,
                  maxLines: 3,
                ),
                SizedBox(height: 20),
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
                        Text('Upload Images'),
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
                ElevatedButton(
                  onPressed: () {
                    addBookToFirestore(context);
                  },
                  child: Text('Add Book'),
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
  Future<String> uploadImage(File imageFile) async {
    try {
      // Generate a unique ID for the image
      String imageName = DateTime.now().millisecondsSinceEpoch.toString();

      // Reference to the Firebase Storage bucket
      Reference storageReference =
          FirebaseStorage.instance.ref().child('booksimages/$imageName');

      // Upload the image file to Firebase Storage
      UploadTask uploadTask = storageReference.putFile(imageFile);

      // Get the download URL of the uploaded image
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      // Return the URL of the uploaded image
      return imageUrl;
    } catch (error) {
      // Handle any errors that occur during the upload process
      print('Error uploading image: $error');
      throw error;
    }
  }
}
