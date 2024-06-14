import 'dart:io';

import 'package:appwithapi/Cstum/constant.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditBookPage extends StatefulWidget {
  final Map<String, dynamic> bookData;

  EditBookPage({Key? key, required this.bookData}) : super(key: key) {
    print('Constructor - bookData: $bookData');
  }

  @override
  State<EditBookPage> createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController bookNameController = TextEditingController();
  final TextEditingController bookPriceController = TextEditingController();
  final TextEditingController additionalDetailsController =
      TextEditingController();
  List<String> imageUrls = [];
  List<File> newImages = [];
  final FirestoreService firestoreService = FirestoreService();
  String bookStatus = 'New';

  @override
  void initState() {
    super.initState();
    print('initState - bookData: ${widget.bookData}');
    bookNameController.text = widget.bookData['bookName'];
    bookPriceController.text = widget.bookData['bookPrice'];
    additionalDetailsController.text =
        widget.bookData['additionalDetails'] ?? '';
    imageUrls = List<String>.from(widget.bookData['imageUrls']);
    bookStatus = widget.bookData['bookStatus'] ?? 'New';
    print('initState - bookNameController: ${bookNameController.text}');
    print('initState - bookPriceController: ${bookPriceController.text}');
    print(
        'initState - additionalDetailsController: ${additionalDetailsController.text}');
    print('initState - imageUrls: $imageUrls');
    print('initState - bookStatus: $bookStatus');
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    List<XFile>? images = await picker.pickMultiImage();
    if (images != null) {
      setState(() {
        newImages = images.map((image) => File(image.path)).toList();
      });
      print('Added images: ${newImages.map((file) => file.path).toList()}');
    }
  }

  Future<List<String>> _uploadImages() async {
    List<String> uploadedImageUrls = [];
    for (var imageFile in newImages) {
      if (imageFile.existsSync()) {
        try {
          String uploadedImageUrl =
              await firestoreService.uploadImage(imageFile);
          uploadedImageUrls.add(uploadedImageUrl);
          print('Uploaded image URL: $uploadedImageUrl');
        } catch (error) {
          print('Error uploading image: $error');
        }
      } else {
        print('File does not exist: ${imageFile.path}');
      }
    }
    return uploadedImageUrls;
  }

  Future<void> saveBookToFirestore(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      List<String> uploadedImageUrls = await _uploadImages();

      // Combine existing and new image URLs
      List<String> finalImageUrls = List.from(imageUrls)
        ..addAll(uploadedImageUrls);

      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // Debug information before updating Firestore
        /*
        String collegeId = widget.bookData['collegeId'];
        String departmentId = widget.bookData['departmentId'];
        String bookId = widget.bookData['id'];*/
        String collegeId = widget.bookData['collegeId'] ?? '';
        String departmentId = widget.bookData['departmentId'] ?? '';
        String bookId = widget.bookData['bookId'] ?? '';

        print('saveBookToFirestore - bookName: ${bookNameController.text}');
        print('saveBookToFirestore - bookPrice: ${bookPriceController.text}');
        print('saveBookToFirestore - finalImageUrls: $finalImageUrls');
        print('saveBookToFirestore - bookStatus: $bookStatus');
        print(
            'saveBookToFirestore - additionalDetails: ${additionalDetailsController.text}');
        print('saveBookToFirestore - collegeId: $collegeId');
        print('saveBookToFirestore - departmentId: $departmentId');
        print('saveBookToFirestore - bookId: $bookId');

        // Update existing book
        await FirebaseFirestore.instance
            .collection('Colleges')
            .doc(collegeId)
            .collection('Departments')
            .doc(departmentId)
            .collection('Books')
            .doc(bookId)
            .update({
          'bookName': bookNameController.text,
          'bookPrice': bookPriceController.text,
          'imageUrls': finalImageUrls,
          'bookStatus': bookStatus,
          'additionalDetails': additionalDetailsController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Book updated successfully!'),
        ));

        Navigator.pop(context);
      } else {
        print('saveBookToFirestore - currentUser is null');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text('Edit Book',
            style: TextStyle(
              color: Colors.white,
            )),
        iconTheme: IconThemeData(color: Colors.white),
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
                if (imageUrls.isNotEmpty || newImages.isNotEmpty)
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: imageUrls.length + newImages.length,
                      itemBuilder: (context, index) {
                        if (index < imageUrls.length) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                              imageUrls[index],
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.file(
                              newImages[index - imageUrls.length],
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    saveBookToFirestore(context);
                  },
                  child: Text('Save Changes'),
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
