import 'package:appwithapi/Cstum/constant.dart';
import 'package:appwithapi/book/editbookpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        iconTheme: IconThemeData(color: ksecondaryColor),
        title: Text('Book Details', style: TextStyle(color: ksecondaryColor)),
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

                              await bookCollection.doc(bookId).delete();

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Book deleted successfully'),
                                ),
                              );

                              Navigator.pop(context); // Close the dialog
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
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Colleges')
            .doc(collegeId)
            .collection('Departments')
            .doc(departmentId)
            .collection('Books')
            .doc(bookId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Book not found'));
          }

          var bookData = snapshot.data!.data() as Map<String, dynamic>;
          String? bookName = bookData['bookName'];
          String? bookPrice = bookData['bookPrice'];
          List<String>? imageUrls =
              List<String>.from(bookData['imageUrls'] ?? []);
          String? email = bookData['email'];
          String? additionalDetails = bookData['additionalDetails'];
          String? bookStatus = bookData['bookStatus'];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(60.0),
                  child: Container(
                    height: 300,
                    width: double.infinity,
                    child: imageUrls.isNotEmpty
                        ? Image.network(
                            imageUrls[0],
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
                      ListTile(
                        leading: Icon(Icons.book, color: kPrimaryColor),
                        title: Text(
                          'Book Name: ${bookName ?? 'Not available'}',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 10),
                      ListTile(
                        leading: Icon(Icons.attach_money_sharp,
                            color: kPrimaryColor),
                        title: Text(
                          'Price: ${bookPrice ?? 'Not available'}\$',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      SizedBox(height: 10),
                      ListTile(
                        leading: Icon(Icons.email, color: kPrimaryColor),
                        title: Text('Email: ${email ?? 'Not available'}'),
                        onTap: email != null ? () => _launchEmail(email) : null,
                      ),
                      SizedBox(height: 10),
                      ListTile(
                        leading: Icon(Icons.more, color: kPrimaryColor),
                        title: Text(
                          'Additional Details: ${additionalDetails ?? 'Not available'}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      SizedBox(height: 10),
                      ListTile(
                        leading: Icon(Icons.check_circle, color: kPrimaryColor),
                        title: Text(
                          'Book Status: ${bookStatus ?? 'Not available'}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Images:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: imageUrls.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Image.network(
                                imageUrls[index],
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
          );
        },
      ),
    );
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunch(emailLaunchUri.toString())) {
      await launch(emailLaunchUri.toString());
    } else {
      throw 'Could not launch email';
    }
  }
}
