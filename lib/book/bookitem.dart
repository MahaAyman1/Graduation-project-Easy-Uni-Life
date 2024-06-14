import 'package:appwithapi/book/displaybookpage.dart';
import 'package:flutter/material.dart';

class BookItem extends StatelessWidget {
  final String? bookName;
  final String bookPrice;
  final List<String>? imageUrls;
  final String? email;
  final String? bookStatus;
  final String? additionalDetails;
  final String? bookId;
  final String? collegeId;
  final String? departmentId;
  final String? userId;

  BookItem({
    Key? key,
    this.bookName,
    required this.bookPrice,
    this.imageUrls,
    this.email,
    this.bookStatus,
    this.additionalDetails,
    this.bookId,
    this.collegeId,
    this.departmentId,
    this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? imageUrl =
        imageUrls != null && imageUrls!.isNotEmpty ? imageUrls!.first : null;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DisplayBookPage(
              bookName: bookName,
              bookPrice: bookPrice,
              imageUrls: imageUrls,
              email: email,
              additionalDetails: additionalDetails,
              bookStatus: bookStatus,
              bookId: bookId,
              collegeId: collegeId,
              departmentId: departmentId,
              userId: userId,
            ),
          ),
        );
      },
      child: Container(
        //  color: ksecondaryColor,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imageUrl != null
                ? Image.network(
                    imageUrl,
                    height: 130,
                    width: 130,
                    fit: BoxFit.cover,
                  )
                : SizedBox(
                    width: double.infinity,
                    height: 110,
                    child: Center(
                      child: Text('Image not available'),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Text(
                bookName ?? 'No title',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(1.0),
                child: Text(
                  '$bookPrice\$',
                  style: TextStyle(
                      fontSize: 15, color: Color.fromARGB(255, 37, 204, 101)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
