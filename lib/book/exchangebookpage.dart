import 'package:appwithapi/Cstum/constant.dart';
import 'package:appwithapi/book/addbookpage.dart';
import 'package:appwithapi/book/bookitem.dart';
import 'package:appwithapi/book/displaybookpage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExchangeBookPage extends StatefulWidget {
  final String? collegeId;
  final String? departmentId;

  ExchangeBookPage({Key? key, this.collegeId, this.departmentId})
      : super(key: key);

  @override
  _ExchangeBookPageState createState() => _ExchangeBookPageState();
}

class _ExchangeBookPageState extends State<ExchangeBookPage> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        iconTheme: IconThemeData(color: ksecondaryColor),
        title: Text(
          'Books ',
          style: TextStyle(color: ksecondaryColor),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return AddBookPage(
                      collegeId: widget.collegeId,
                      departmentId: widget.departmentId,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          ////////////////
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search by book name',
                  hintStyle: TextStyle(color: kPrimaryColor),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: kPrimaryColor),
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                  isDense: true,
                ),
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Colleges')
                  .doc(widget.collegeId)
                  .collection('Departments')
                  .doc(widget.departmentId)
                  .collection('Books')
                  .orderBy('bookName')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No books found'));
                }

                List<QueryDocumentSnapshot> filteredBooks = snapshot.data!.docs;
                if (searchController.text.isNotEmpty) {
                  filteredBooks = snapshot.data!.docs
                      .where((book) => book['bookName']
                          .toString()
                          .toLowerCase()
                          .contains(searchController.text.toLowerCase()))
                      .toList();
                }

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: filteredBooks.length,
                  itemBuilder: (context, index) {
                    final book = filteredBooks[index];
                    List<dynamic> imageUrlsDynamic = book['imageUrls'] ?? [];
                    List<String> imageUrls =
                        imageUrlsDynamic.map((url) => url.toString()).toList();

                    String bookId = book.id;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DisplayBookPage(
                              bookName: book['bookName'],
                              bookPrice: book['bookPrice'],
                              imageUrls: imageUrls,
                              email: book['email'],
                              additionalDetails: book['additionalDetails'],
                              bookStatus: book['bookStatus'],
                              bookId: bookId,
                              collegeId: widget.collegeId,
                              departmentId: widget.departmentId,
                              userId: book['userId'],
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BookItem(
                          bookName: book['bookName'],
                          bookPrice: book['bookPrice'],
                          imageUrls: imageUrls,
                          email: book['email'],
                          additionalDetails: book['additionalDetails'],
                          bookStatus: book['bookStatus'],
                          bookId: bookId,
                          collegeId: widget.collegeId,
                          departmentId: widget.departmentId,
                          userId: book['userId'],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
