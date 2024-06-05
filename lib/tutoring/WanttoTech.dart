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

/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gradution_project/constant.dart';
import 'package:gradution_project/menu.dart';

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
                                return '${subjectDoc['subject']} (${subjectDoc['price']} JOD - $preferOnlineText)';
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
                              Text(
                                'Teaching Subjects:',
                                style: TextStyle(color: Colors.black),
                              ),
                              SizedBox(height: 4),
                              Column(
                                children: subjects.map((subject) {
                                  return Text(
                                    subject,
                                    style: TextStyle(color: Colors.black),
                                  );
                                }).toList(),
                              ),
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
*/

/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gradution_project/constant.dart';
import 'package:gradution_project/menu.dart';

class StudentsWhoWantToTeachScreen extends StatefulWidget {
  @override
  _StudentsWhoWantToTeachScreenState createState() =>
      _StudentsWhoWantToTeachScreenState();
}

class _StudentsWhoWantToTeachScreenState
    extends State<StudentsWhoWantToTeachScreen> {
  String selectedGender = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ksecondaryColor,
      appBar: AppBar(
        shadowColor: ksecondaryColor,
        backgroundColor: ksecondaryColor,
      ),
      drawer: Menu(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Filtering Depend Gender',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          DropdownButton<String>(
            value: selectedGender,
            onChanged: (String? newValue) {
              setState(() {
                selectedGender = newValue!;
              });
            },
            items: <String>['All', 'Male', 'Female']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Students')
                  .where('wantsToTeach', isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                List<DocumentSnapshot> filteredDocs = selectedGender == 'All'
                    ? snapshot.data!.docs
                    : snapshot.data!.docs
                        .where((doc) => doc['gender'] == selectedGender)
                        .toList();

                return ListView(
                  children: filteredDocs.map((doc) {
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
                                  return '${subjectDoc['subject']} (${subjectDoc['price']} JOD - $preferOnlineText)';
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
                                Text(
                                  'Teaching Subjects:',
                                  style: TextStyle(color: Colors.black),
                                ),
                                SizedBox(height: 4),
                                Column(
                                  children: subjects.map((subject) {
                                    String subjectName = subject.split(' (')[0];
                                    return Text(
                                      subjectName,
                                      style: TextStyle(color: Colors.black),
                                    );
                                  }).toList(),
                                ),
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
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
*/
/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gradution_project/constant.dart';
import 'package:gradution_project/menu.dart';

class StudentsWhoWantToTeachScreen extends StatefulWidget {
  @override
  _StudentsWhoWantToTeachScreenState createState() =>
      _StudentsWhoWantToTeachScreenState();
}

class _StudentsWhoWantToTeachScreenState
    extends State<StudentsWhoWantToTeachScreen> {
  String selectedGender = 'All';
  bool showNoResults = false;
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ksecondaryColor,
      appBar: AppBar(
        shadowColor: ksecondaryColor,
        backgroundColor: ksecondaryColor,
      ),
      drawer: Menu(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Filtering Depend Gender',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: DropdownButton<String>(
                  value: selectedGender,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedGender = newValue!;
                    });
                  },
                  items: <String>['All', 'Male', 'Female']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                flex: 2,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search Subjects',
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('Students')
                  .where('wantsToTeach', isEqualTo: true)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                List<DocumentSnapshot> filteredDocs = selectedGender == 'All'
                    ? snapshot.data!.docs
                    : snapshot.data!.docs
                        .where((doc) => doc['gender'] == selectedGender)
                        .toList();

                if (searchQuery.isNotEmpty) {
                  filteredDocs = filteredDocs.where((doc) {
                    bool hasSubject = false;
                    doc.reference
                        .collection('TeachingSubjects')
                        .get()
                        .then((subjectSnapshot) {
                      hasSubject = subjectSnapshot.docs.any((subjectDoc) {
                        String subjectName =
                            subjectDoc['subject'].toString().toLowerCase();
                        return subjectName.contains(searchQuery.toLowerCase());
                      });
                    });
                    return hasSubject;
                  }).toList();
                }

                if (filteredDocs.isEmpty) {
                  showNoResults = true;
                } else {
                  showNoResults = false;
                }

                return ListView.builder(
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = filteredDocs[index];
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
                                  return '${subjectDoc['subject']} (${subjectDoc['price']} JOD - $preferOnlineText)';
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
                                Text(
                                  'Teaching Subjects:',
                                  style: TextStyle(color: Colors.black),
                                ),
                                SizedBox(height: 4),
                                Column(
                                  children: subjects.map((subject) {
                                    String subjectName = subject.split(' (')[0];
                                    return Text(
                                      subjectName,
                                      style: TextStyle(color: Colors.black),
                                    );
                                  }).toList(),
                                ),
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
                  },
                );
              },
            ),
          ),
          if (showNoResults)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('No Results'),
              ),
            ),
        ],
      ),
    );
  }
}
*/
/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubjectFilter extends StatefulWidget {
  @override
  _SubjectFilterState createState() => _SubjectFilterState();
}

class _SubjectFilterState extends State<SubjectFilter> {
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subject Filter'),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            onChanged: (value) {
              setState(() {
                _searchText = value.toLowerCase();
              });
            },
            decoration: InputDecoration(
              hintText: 'Search for subjects...',
            ),
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Students')
                .where('wantsToTeach', isEqualTo: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              List<DocumentSnapshot>? documents = snapshot.data?.docs;
              if (documents == null) {
                return Text('No subjects found.');
              }
              List<DocumentSnapshot> filteredSubjects = documents
                  .where((document) =>
                      (document.data()
                                  as Map<String, dynamic>)?['TeachingSubjects']
                              ?['subject']
                          ?.toLowerCase()
                          .contains(_searchText) ??
                      false)
                  .toList();
              return Expanded(
                child: ListView.builder(
                  itemCount: filteredSubjects.length,
                  itemBuilder: (context, index) {
                    var subject = filteredSubjects[index];
                    return ListTile(
                      title: Text((subject.data()
                                  as Map<String, dynamic>)?['TeachingSubjects']
                              ?['subject'] ??
                          ''),
                      subtitle: Text(
                          'Price: ${(subject.data() as Map<String, dynamic>)?['TeachingSubjects']?['price'] ?? ''}'),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
*/


