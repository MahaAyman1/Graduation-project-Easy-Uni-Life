import 'package:appwithapi/Cstum/constant.dart';
import 'package:appwithapi/book/editbookpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DisplayBookPage extends StatelessWidget {
  final String? bookName;
  final String? bookPrice;
  final List<String>? imageUrls;
  final String? email;
  final String? additionalDetails;
  final String? bookStatus;
  final String? bookId;
  final String? collegeId;
  final String? departmentId;
  final String? userId;

  const DisplayBookPage({
    this.bookName,
    this.bookPrice,
    this.imageUrls,
    this.email,
    this.additionalDetails,
    this.bookStatus,
    this.bookId,
    this.collegeId,
    this.departmentId,
    this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    print('7:51----------------------gggggggggggggggggggggg');
    print('user id from widget $userId ');
    print('User ID: ${user?.uid}');

    print("now at 1:6 i am trying to find the error");
    print('Book Name: $bookName');
    print('Book Price: $bookPrice');
    print('Email: $email');
    print('Additional Details: $additionalDetails');
    print('Book Status: $bookStatus');
    print('College ID: $collegeId');
    print('Department ID: $departmentId');
    print('Book ID: $bookId');

    return Scaffold(
      //backgroundColor: ksecondaryColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        iconTheme: IconThemeData(color: ksecondaryColor),
        title: Text(
          'Book Details',
          style: TextStyle(color: ksecondaryColor),
        ),
        actions: [
          if (user != null && userId == user.uid)
            IconButton(
              icon: Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditBookPage(bookData: {
                      'bookName': bookName,
                      'bookPrice': bookPrice,
                      'imageUrls': imageUrls,
                      'additionalDetails': additionalDetails,
                      'bookStatus': bookStatus,
                      'bookId': bookId,
                      'collegeId': collegeId,
                      'departmentId': departmentId,
                    }),
                  ),
                );
              },
            ),
          if (user != null && userId == user.uid)
            IconButton(
              icon: Icon(Icons.delete, color: Colors.white),
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content:
                          Text('Are you sure you want to delete this book?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            try {
                              CollectionReference bookCollection =
                                  FirebaseFirestore.instance
                                      .collection('Colleges')
                                      .doc(collegeId)
                                      .collection('Departments')
                                      .doc(departmentId)
                                      .collection('Books');

                              QuerySnapshot querySnapshot = await bookCollection
                                  .where('bookName', isEqualTo: bookName)
                                  .where('bookPrice', isEqualTo: bookPrice)
                                  .where('email', isEqualTo: email)
                                  .get();

                              if (querySnapshot.docs.isNotEmpty) {
                                await bookCollection
                                    .doc(querySnapshot.docs.first.id)
                                    .delete();

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Book deleted successfully'),
                                  ),
                                );

                                Navigator.pop(context); // Close the dialog
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('No matching book found'),
                                  ),
                                );
                              }
                            } catch (e) {
                              print('Error deleting book: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Failed to delete book. Please try again later.'),
                                ),
                              );
                            }
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(60.0),
              child: Container(
                height: 300,
                width: double.infinity,
                child: imageUrls != null && imageUrls!.isNotEmpty
                    ? Image.network(
                        imageUrls![0],
                        fit: BoxFit.cover,
                      )
                    : Center(
                        child: Text('Image not available'),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Book Name: ${bookName ?? 'Not available'}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Price: ${bookPrice ?? 'Not available'}\$',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Owner Email: ${email ?? 'Not available'}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Additional Details: ${additionalDetails ?? 'Not available'}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Book Status: ${bookStatus ?? 'Not available'}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Images:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: imageUrls != null ? imageUrls!.length : 0,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Image.network(
                            imageUrls![index],
                            fit: BoxFit.contain,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
