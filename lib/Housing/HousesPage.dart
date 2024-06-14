
/*
class housecards extends StatelessWidget {
  const housecards({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Image.asset(
              'images/house.jpg',
              width: 150,
              height: 150, 
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'title',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'price',
                    style: TextStyle(
                      fontSize: 14.0, color: Colors.yellow
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(Icons.people), 
                      SizedBox(width: 4.0),
                      Text(
                        "4", 
                        style: TextStyle(fontSize: 14.0), 
                      ),
                      SizedBox(width: 16.0),
                      Icon(Icons.home), 
                      SizedBox(width: 4.0),
                      Text(
                        "3", 
                        style: TextStyle(fontSize: 14.0), 
                      ),
                    ],
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
*/






















import 'package:appwithapi/Housing/addhousepage.dart';
import 'package:appwithapi/Housing/housedetailspage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';





/*


class HousingPage extends StatelessWidget {
  const HousingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Houses'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add House',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return AddHousePage();
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: StreamBuilder<QuerySnapshot>(
          stream: firestore.collectionGroup('houses').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final List<DocumentSnapshot> houseDocs = snapshot.data!.docs;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, 
              ),
              itemCount: houseDocs.length, 
              itemBuilder: (context, index) {
                final houseData = houseDocs[index].data() as Map<String, dynamic>;
                return HouseItem(
                  houseName: houseData['houseName'] ?? '',
                  housePrice: houseData['price'] ?? '',
                  occupants: int.tryParse(houseData['numOccupants'].toString()) ?? 0,
                  rooms: int.tryParse(houseData['numRooms'].toString()) ?? 0,
                );
              },
            );
          },
        ),
      ),
    );
  }
}


class HouseItem extends StatelessWidget {
  final String houseName;
  final String housePrice;
  final int occupants;
  final int rooms;

  const HouseItem({
    required this.houseName,
    required this.housePrice,
    required this.occupants,
    required this.rooms,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Image.asset(
              'images/house.jpg',
              width: 440,
              height: 200, 
            ),
          
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  houseName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Price: $housePrice',
                  style: TextStyle(color: Colors.yellow),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.people),
                    SizedBox(width: 4),
                    Text('Occupants: $occupants'),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.home),
                    SizedBox(width: 4),
                    Text('Rooms: $rooms'),
                   SizedBox(width: 8),

                      IconButton(
      icon: FaIcon(FontAwesomeIcons.toilet,
      color:  Colors.black,size: 20,), 
      onPressed: () {  }
     ),
                    SizedBox(width: 4),
                    Text('bathroom $rooms'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

*/






class HousingPage extends StatelessWidget {
  const HousingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Houses'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add House',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return AddHousePage();
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: StreamBuilder<QuerySnapshot>(
          stream: firestore.collectionGroup('houses').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final List<DocumentSnapshot> houseDocs = snapshot.data!.docs;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, 
              ),
              itemCount: houseDocs.length, 
              itemBuilder: (context, index) {
                final houseData = houseDocs[index].data() as Map<String, dynamic>;
                final List<String> imageUrls = List<String>.from(houseData['imageUrls'] ?? []);
                  return HouseItem(
                  houseName: houseData['houseName'] ?? '',
                  housePrice: houseData['price'] ?? '',
                  occupants: int.tryParse(houseData['numOccupants'].toString()) ?? 0,
                  rooms: int.tryParse(houseData['numRooms'].toString()) ?? 0,
                  imageUrls: imageUrls,
                  userId: houseData['userId'],
                  gender: houseData['gender'], // corrected to 'gender'
                  email: houseData['email'],
                  bathrooms: houseData['numBathrooms'], // added bathrooms
);
              },
            );
          },
        ),
      ),
    );
  }
}

class HouseItem extends StatelessWidget {
 final String houseName;
  final String housePrice;
  final int occupants;
  final int rooms;
  final List<String> imageUrls;
  final String gender; // corrected to 'gender'
  final String email;
  final String userId;
  final String bathrooms; // added bathrooms

  const HouseItem({
      required this.houseName,
    required this.housePrice,
    required this.occupants,
    required this.rooms,
    required this.imageUrls,
    required this.gender,
    required this.email,
    //required this.phone,
    required this.userId, required this.bathrooms,
  });

  @override
  Widget build(BuildContext context) {
    String? firstImageUrl = imageUrls.isNotEmpty ? imageUrls.first : null;

    return GestureDetector(
      onTap: (){
        
         Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>DisplayHouseDetailPage(
             houseDetails: HouseDetails(
                houseName: houseName,
                housePrice: housePrice,
                occupants: occupants,
                rooms: rooms,
                imageUrls: imageUrls,
                gender: gender,
                email: email,
                userId: userId,
                bathrooms: bathrooms,
              ),
            ),
          ),
        );
      },

      child: Card(
        
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            firstImageUrl != null ? Image.network(
              firstImageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ) : SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    houseName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Price: $housePrice',
                    style: TextStyle(color: Colors.yellow),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.people),
                      SizedBox(width: 4),
                      Text('Occupants: $occupants'),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.home),
                      SizedBox(width: 4),
                      Text('Rooms: $rooms'),
                     SizedBox(width: 8),
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.toilet, color: Colors.black, size: 20,), 
                        onPressed: () {},
                      ),
                      SizedBox(width: 4),
                      Text('bathroom $rooms'),
                    ],
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

