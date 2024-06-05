/*import 'dart:async';
import 'package:appwithapi/Cstum/menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReviewsScreen extends StatefulWidget {
  final String subject;
  final String teacherId;

  ReviewsScreen({required this.subject, required this.teacherId});

  @override
  _ReviewsScreenState createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  late StreamController<List<Map<String, dynamic>>> _reviewsController;

  @override
  void initState() {
    super.initState();
    _reviewsController = StreamController<List<Map<String, dynamic>>>();
    _loadReviews();
  }

  @override
  void dispose() {
    _reviewsController.close();
    super.dispose();
  }

  void _loadReviews() async {
    try {
      List<Map<String, dynamic>> reviews =
          await getReviews(widget.subject, widget.teacherId);
      _reviewsController.add(reviews);
    } catch (e) {
      _reviewsController.addError(e);
    }
  }

  Widget buildStarRating(double rating) {
    int numberOfStars = rating.round();
    List<Widget> stars = List.generate(5, (index) {
      if (index < numberOfStars) {
        return Icon(
          Icons.star,
          color: Colors.yellow,
          size: 13,
        );
      } else {
        return Icon(Icons.star_border,
            color: const Color.fromARGB(255, 190, 176, 47), size: 14);
      }
    });

    return Row(mainAxisAlignment: MainAxisAlignment.start, children: stars);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _reviewsController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            List<Map<String, dynamic>> reviews = snapshot.data ?? [];
            return ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                String imageUrl = reviews[index]['profileImageUrl'];
                DateTime? date;
                if (reviews[index]['timestamp'] != null) {
                  date = reviews[index]['timestamp'].toDate();
                }
                String formattedDate = date != null
                    ? DateFormat('dd MMMM yyyy').format(date)
                    : 'Unknown date';
                return Container(
                  color: const Color.fromARGB(255, 219, 216, 216),
                  padding: EdgeInsets.only(left: 10, right: 10, top: 20),
                  margin: EdgeInsets.only(left: 10, right: 10, top: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(imageUrl),
                            child: reviews[index]['profileImageUrl'] == null
                                ? Text(reviews[index]['auth'][0].toUpperCase())
                                : null,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text('${reviews[index]['email']}'),
                          SizedBox(
                            width: 40,
                          ),
                          IconButton(
                            icon: Icon(Icons.more_vert),
                            onPressed: () {
                              if (reviews[index]['auth'] ==
                                  FirebaseAuth.instance.currentUser?.uid) {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      child: Wrap(
                                        children: <Widget>[
                                          ListTile(
                                            leading: Icon(Icons.delete),
                                            title: Text('Delete'),
                                            onTap: () async {
                                              // Query the collection to find the document ID
                                              var query =
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('Feedback')
                                                      .where('auth',
                                                          isEqualTo:
                                                              reviews[index]
                                                                  ['auth'])
                                                      .get();

                                              if (query.docs.isNotEmpty) {
                                                var docId = query.docs.first.id;

                                                await FirebaseFirestore.instance
                                                    .collection('Feedback')
                                                    .doc(docId)
                                                    .delete();

                                                setState(() async {
                                                  _loadReviews();
                                                });

                                                Navigator.pop(context);
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            buildStarRating(
                              reviews[index]['rating'],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('$formattedDate')
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        " ${reviews[index]['feedback']} ",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No reviews found'));
          }
        },
      ),
      drawer: Menu(),
    );
  }
}

Future<List<Map<String, dynamic>>> getReviews(
    String subject, String teacherId) async {
  var reviewsData = await FirebaseFirestore.instance
      .collection('Feedback')
      .where('subject', isEqualTo: subject)
      .where('teacherId', isEqualTo: teacherId)
      .get();

  List<DocumentSnapshot> reviews = reviewsData.docs;
  List<Map<String, dynamic>> results = [];

  for (var review in reviews) {
    var userData = await FirebaseFirestore.instance
        .collection('Students')
        .doc(review['auth'])
        .get();
    results.add({
      'auth': review['auth'],
      'feedback': review['feedback'],
      'rating': review['rating'],
      'email': review['email'],
      'profileImageUrl': userData['profileImageUrl'],
      'firstName': userData['firstName'],
      'gender': userData['gender'],
      'timestamp': review['timestamp']
    });
  }

  return results;
}*/

import 'dart:async';
import 'package:appwithapi/Cstum/menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReviewsScreen extends StatefulWidget {
  final String subject;
  final String teacherId;

  ReviewsScreen({required this.subject, required this.teacherId});

  @override
  _ReviewsScreenState createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  late StreamController<List<Map<String, dynamic>>> _reviewsController;

  @override
  void initState() {
    super.initState();
    _reviewsController = StreamController<List<Map<String, dynamic>>>();
    _loadReviews();
  }

  @override
  void dispose() {
    _reviewsController.close();
    super.dispose();
  }

  Future<void> _loadReviews() async {
    try {
      List<Map<String, dynamic>> reviews =
          await getReviews(widget.subject, widget.teacherId);
      _reviewsController.add(reviews);
    } catch (e) {
      _reviewsController.addError(e);
    }
  }

  Widget buildStarRating(double rating) {
    int numberOfStars = rating.round();
    List<Widget> stars = List.generate(5, (index) {
      if (index < numberOfStars) {
        return Icon(
          Icons.star,
          color: Colors.yellow,
          size: 13,
        );
      } else {
        return Icon(Icons.star_border,
            color: const Color.fromARGB(255, 190, 176, 47), size: 14);
      }
    });

    return Row(mainAxisAlignment: MainAxisAlignment.start, children: stars);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _reviewsController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            List<Map<String, dynamic>> reviews = snapshot.data ?? [];
            return ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                String imageUrl = reviews[index]['profileImageUrl'];
                DateTime? date;
                if (reviews[index]['timestamp'] != null) {
                  date = reviews[index]['timestamp'].toDate();
                }
                String formattedDate = date != null
                    ? DateFormat('dd MMMM yyyy').format(date)
                    : 'Unknown date';
                return Container(
                  color: const Color.fromARGB(255, 219, 216, 216),
                  padding: EdgeInsets.only(left: 10, right: 10, top: 20),
                  margin: EdgeInsets.only(left: 10, right: 10, top: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(imageUrl),
                            child: reviews[index]['profileImageUrl'] == null
                                ? Text(reviews[index]['auth'][0].toUpperCase())
                                : null,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text('${reviews[index]['email']}'),
                          SizedBox(
                            width: 40,
                          ),
                          IconButton(
                            icon: Icon(Icons.more_vert),
                            onPressed: () {
                              if (reviews[index]['auth'] ==
                                  FirebaseAuth.instance.currentUser?.uid) {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      child: Wrap(
                                        children: <Widget>[
                                          ListTile(
                                            leading: Icon(Icons.delete),
                                            title: Text('Delete'),
                                            onTap: () async {
                                              // Query the collection to find the document ID
                                              var query =
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('Feedback')
                                                      .where('auth',
                                                          isEqualTo:
                                                              reviews[index]
                                                                  ['auth'])
                                                      .get();

                                              if (query.docs.isNotEmpty) {
                                                var docId = query.docs.first.id;

                                                await FirebaseFirestore.instance
                                                    .collection('Feedback')
                                                    .doc(docId)
                                                    .delete();

                                                // Reload reviews after deletion
                                                _loadReviews();

                                                Navigator.pop(context);
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            buildStarRating(
                              reviews[index]['rating'],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('$formattedDate')
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        " ${reviews[index]['feedback']} ",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No reviews found'));
          }
        },
      ),
      drawer: Menu(),
    );
  }
}

Future<List<Map<String, dynamic>>> getReviews(
    String subject, String teacherId) async {
  var reviewsData = await FirebaseFirestore.instance
      .collection('Feedback')
      .where('subject', isEqualTo: subject)
      .where('teacherId', isEqualTo: teacherId)
      .get();

  List<DocumentSnapshot> reviews = reviewsData.docs;
  List<Map<String, dynamic>> results = [];

  for (var review in reviews) {
    var userData = await FirebaseFirestore.instance
        .collection('Students')
        .doc(review['auth'])
        .get();
    results.add({
      'auth': review['auth'],
      'feedback': review['feedback'],
      'rating': review['rating'],
      'email': review['email'],
      'profileImageUrl': userData['profileImageUrl'],
      'firstName': userData['firstName'],
      'gender': userData['gender'],
      'timestamp': review['timestamp']
    });
  }

  return results;
}
