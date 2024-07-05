import 'package:appwithapi/Cstum/constant.dart';
import 'package:appwithapi/Cstum/menu.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentsWhoWantToTeachScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ksecondaryColor,
      appBar: AppBar(
        shadowColor: ksecondaryColor,
        backgroundColor: ksecondaryColor,
      ),
      drawer: Menu(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Students')
            .where('wantsToTeach', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data?.docs.map((doc) {
                  return FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('Students')
                        .doc(doc.id)
                        .collection('TeachingSubjects')
                        .get(),
                    builder: (context, subjectSnapshot) {
                      if (subjectSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return ListTile(
                          title: Text('Loading...'),
                        );
                      }

                      if (subjectSnapshot.hasError) {
                        return ListTile(
                          title: Text('Error: ${subjectSnapshot.error}'),
                        );
                      }

                      List<String> subjects =
                          subjectSnapshot.data?.docs.map((subjectDoc) {
                                String preferOnlineText =
                                    subjectDoc['preferOnline'] == 'Yes'
                                        ? 'Online'
                                        : subjectDoc['preferOnline'] == 'No'
                                            ? 'On-site'
                                            : "I don't care";
                                return ' ${subjectDoc['subject']} (${subjectDoc['price']} JOD - $preferOnlineText)';
                              }).toList() ??
                              [];

                      return Card(
                        color: Colors.white,
                        shadowColor: Colors.grey,
                        child: ListTile(
                          title: Text(
                            '${doc['major']}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kPrimaryColor),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Phone Number: ${doc['phoneNumber']}'),
                              Text('Teaching Subjects: ${subjects.join(', ')}'),
                            ],
                          ),
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(doc['profileImageUrl']),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList() ??
                [],
          );
        },
      ),
    );
  }
}
