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
  State<ExchangeBookPage> createState() => _ExchangeBookPageState();
}

class _ExchangeBookPageState extends State<ExchangeBookPage> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> allResults = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> filteredBooks = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getBookStream();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  _onSearchChanged() {
    filterBooks();
  }

  getBookStream() async {
    try {
      String? collegeId = widget.collegeId;
      String? departmentId = widget.departmentId;

      if (collegeId == null || departmentId == null) {
        print('collegeId or departmentId is null');
        return;
      }

      QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore
          .instance
          .collection('Colleges')
          .doc(collegeId)
          .collection('Departments')
          .doc(departmentId)
          .collection('Books')
          .orderBy('bookName')
          .get();

      // Debug: Print fetched data
      data.docs.forEach((doc) => print('Fetched book: ${doc.data()}'));

      setState(() {
        allResults = data.docs;
        filteredBooks = allResults;
      });

      print('Fetched ${data.docs.length} books');
    } catch (e) {
      print('Error fetching books: $e');
    }
  }

  filterBooks() {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> results = [];
    if (searchController.text.isEmpty) {
      results = allResults;
    } else {
      results = allResults
          .where((book) => book['bookName']
              .toString()
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    }
    setState(() {
      filteredBooks = results;
      print('Filtered to ${results.length} books');
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

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
            icon: const Icon(Icons.add),
            tooltip: 'Add Book',
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
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 22, top: 5),
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
              child: filteredBooks.isEmpty
                  ? Center(
                      child: Text('No books found',
                          style: TextStyle(color: Colors.white)))
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: filteredBooks.length,
                      itemBuilder: (context, index) {
                        final book = filteredBooks[index];
                        List<dynamic> imageUrlsDynamic =
                            book['imageUrls'] ?? [];
                        List<String> imageUrls = imageUrlsDynamic
                            .map((url) => url.toString())
                            .toList();

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
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
