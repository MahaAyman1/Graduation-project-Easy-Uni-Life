/*


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/Housing/pages/HousesPage.dart';

class HouseDetails {
  final String houseName;
  final String housePrice;
  final int occupants;
  final int rooms;
  final List<String> imageUrls;
  final String gender;
  final String email;
  final String bathrooms;
  final String userId;

  HouseDetails({
    required this.houseName,
    required this.housePrice,
    required this.occupants,
    required this.rooms,
    required this.imageUrls,
    required this.gender,
    required this.email,
    required this.bathrooms,
    required this.userId,
  });

  factory HouseDetails.defaultData() {
    return HouseDetails(
      houseName: 'Example House',
      imageUrls: [
        'https://via.placeholder.com/300',
        'https://via.placeholder.com/300',
        'https://via.placeholder.com/300',
      ],
      occupants: 4,
      bathrooms: '2',
      rooms: 3,
      gender: 'Any',
      email: 'example@example.com',
      userId: 'defaultUserId',
      housePrice: 'price',
    );
  }
}

class DisplayHouseDetailPage extends StatelessWidget {
  final HouseDetails houseDetails;

  DisplayHouseDetailPage({Key? key, required this.houseDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    bool enabled = user != null && houseDetails.userId == user.uid;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(houseDetails.houseName),
        actions: [
          if (enabled)
            PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return [
                  if (enabled)
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 10),
                          Text('Edit'),
                        ],
                      ),
                      value: 'Edit',
                      onTap: () {
                        // Handle edit action
                      },
                    ),
                  if (enabled)
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.delete),
                          SizedBox(width: 10),
                          Text('Delete'),
                        ],
                      ),
                      value: 'Delete',
                      onTap: () async {
                        
    try {
      // Get a reference to the Firestore collection
      CollectionReference housesCollection = FirebaseFirestore.instance.collection('users').doc(houseDetails.userId).collection('houses');

      // Construct a query to find the document with the specified values
      QuerySnapshot querySnapshot = await housesCollection
        .where('houseName', isEqualTo: houseDetails.houseName)
      
        
        .get();

      // Check if the query returned any documents
      if (querySnapshot.docs.isNotEmpty) {
        // Delete the first document found (assuming there's only one document with the specified values)
        await housesCollection.doc(querySnapshot.docs.first.id).delete();
           
        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('House deleted successfully'),
          ),


        );
                              Navigator.push(context,MaterialPageRoute(builder: (context)=> HousingPage()));

      } else {
        // Show a message indicating that no matching house was found
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No matching house found'),
          ),
        );
      }
    } catch (e) {
      // Show an error message if deletion fails
      print('Error deleting house: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete house. Please try again later.'),
        ),
      );
    }
  },
                      





                    ),
                ];
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'title',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            // Display images
            Container(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: houseDetails.imageUrls.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      houseDetails.imageUrls[index],
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.people, color: Colors.blue),
              title: Text('Occupants: ${houseDetails.occupants}'),
            ),
            ListTile(
              leading: Icon(Icons.bathtub, color: Colors.blue),
              title: Text('Bathrooms: ${houseDetails.bathrooms}'),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.blue),
              title: Text('Rooms: ${houseDetails.rooms}'),
            ),
            ListTile(
              leading: Icon(Icons.person, color: Colors.blue),
              title: Text('Tenant Gender: ${houseDetails.gender}'),
            ),
            ListTile(
              leading: Icon(Icons.email, color: Colors.blue),
              title: Text('Email: ${houseDetails.email}'),
            ),
          ],
        ),
      ),
    );
  }
}
*/

import 'package:appwithapi/Cstum/constant.dart';
import 'package:appwithapi/Housing/HousesPage.dart';
import 'package:appwithapi/Housing/edithousepage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HouseDetails {
  final String houseName;
  final String housePrice;
  final int occupants;
  final int rooms;
  final List<String> imageUrls;
  final String gender;
  final String email;
  final String bathrooms;
  final String userId;

  HouseDetails({
    required this.houseName,
    required this.housePrice,
    required this.occupants,
    required this.rooms,
    required this.imageUrls,
    required this.gender,
    required this.email,
    required this.bathrooms,
    required this.userId,
  });

  factory HouseDetails.defaultData() {
    return HouseDetails(
      houseName: 'Example House',
      imageUrls: [
        'https://via.placeholder.com/300',
        'https://via.placeholder.com/300',
        'https://via.placeholder.com/300',
      ],
      occupants: 4,
      bathrooms: '2',
      rooms: 3,
      gender: 'Any',
      email: 'example@example.com',
      userId: 'defaultUserId',
      housePrice: 'price',
    );
  }
}

class DisplayHouseDetailPage extends StatelessWidget {
  final HouseDetails houseDetails;

  DisplayHouseDetailPage({Key? key, required this.houseDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    bool enabled = user != null && houseDetails.userId == user.uid;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(houseDetails.houseName),
        actions: [
          if (enabled)
            PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return [
                  if (enabled)
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 10),
                          Text('Edit'),
                        ],
                      ),
                      value: 'Edit',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditHousePage(
                              userId: houseDetails.userId,
                              houseData: {
                                'houseName': houseDetails.houseName,
                                'price': houseDetails.housePrice,
                                'numRooms': houseDetails.rooms.toString(),
                                'numBathrooms': houseDetails.bathrooms,
                                'gender': houseDetails.gender,
                                'numOccupants':
                                    houseDetails.occupants.toString(),
                                'email': houseDetails.email,
                                'imageUrls': houseDetails.imageUrls,
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  if (enabled)
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.delete),
                          SizedBox(width: 10),
                          Text('Delete'),
                        ],
                      ),
                      value: 'Delete',
                      onTap: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              //
                              //  title: Text('Confirm Deletion'),
                              content: Text(
                                  'Are you sure you want to delete this house?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(false); // Close the dialog
                                  },
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    try {
                                      CollectionReference housesCollection =
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(houseDetails.userId)
                                              .collection('houses');

                                      QuerySnapshot querySnapshot =
                                          await housesCollection
                                              .where('houseName',
                                                  isEqualTo:
                                                      houseDetails.houseName)
                                              .where('price',
                                                  isEqualTo:
                                                      houseDetails.housePrice)
                                              .where('email',
                                                  isEqualTo: houseDetails.email)
                                              .get();

                                      if (querySnapshot.docs.isNotEmpty) {
                                        await housesCollection
                                            .doc(querySnapshot.docs.first.id)
                                            .delete();

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'House deleted successfully'),
                                          ),
                                        );

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HousingPage()));
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content:
                                                Text('No matching house found'),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      print('Error deleting house: $e');
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Failed to delete house. Please try again later.'),
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
                ];
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /* Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'title',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),*/
            SizedBox(height: 10),
            // Display images
            Container(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: houseDetails.imageUrls.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      houseDetails.imageUrls[index],
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.people, color: kPrimaryColor),
              title: Text('Occupants: ${houseDetails.occupants}'),
            ),
            ListTile(
              leading: Icon(Icons.bathtub, color: kPrimaryColor),
              title: Text('Bathrooms: ${houseDetails.bathrooms}'),
            ),
            ListTile(
              leading: Icon(Icons.home, color: kPrimaryColor),
              title: Text('Rooms: ${houseDetails.rooms}'),
            ),
            ListTile(
              leading: Icon(Icons.person, color: kPrimaryColor),
              title: Text('Tenant Gender: ${houseDetails.gender}'),
            ),
            ListTile(
              leading: Icon(Icons.email, color: kPrimaryColor),
              title: Text('Email: ${houseDetails.email}'),
            ),
          ],
        ),
      ),
    );
  }
}
