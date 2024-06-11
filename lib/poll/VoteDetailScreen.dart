/*

Is Perfect 
import 'package:appwithapi/Cstum/SlideBanner.dart';
import 'package:appwithapi/Cstum/constant.dart';
import 'package:appwithapi/poll/voterinfo.dart';
import 'package:appwithapi/poll/voterlistscreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';

class VoteDetailScreen extends StatefulWidget {
  final DocumentReference voteRef;

  VoteDetailScreen({required this.voteRef});

  @override
  _VoteDetailScreenState createState() => _VoteDetailScreenState();
}

class _VoteDetailScreenState extends State<VoteDetailScreen> {
  late Stream<DocumentSnapshot> _voteStream;
  bool votedUp = false;
  bool votedDown = false;

  @override
  void initState() {
    super.initState();
    _voteStream = widget.voteRef.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _voteStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator while waiting for data
        }

        if (!snapshot.hasData) {
          return Text('No data found'); // Show message if no data available
        }

        final voteData = snapshot.data!.data() as Map<String, dynamic>;
        final int optionAVotes = (voteData['optionAVotes'] ?? 0).toInt();
        final int optionBVotes = (voteData['optionBVotes'] ?? 0).toInt();
        final double latitude = voteData['latitude'] as double;
        final double longitude = voteData['longitude'] as double;

        double getValidPercent(int votes) {
          double percent = votes / 10;
          if (percent < 0.0) {
            percent = 0.0;
          } else if (percent > 1.0) {
            percent = 1.0;
          }
          return percent;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Vote Details'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  /* if (voteData['preferredGender'] != "Any")
                    Text(
                      "This meeting is for " +
                          voteData['preferredGender'] +
                          "only",
                      style: TextStyle(
                          color: Colors.white,
                          backgroundColor: kPrimaryColor,
                          fontSize: 20),
                    ),*/
                  if (voteData['preferredGender'] != "Any")
                    /*  Container(
                      width: double.infinity,
                      color: Colors.red,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text(
                        "This meeting is for ${voteData['preferredGender']} only",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),*/
                    SlideBanner(
                      message:
                          "This meeting is for ${voteData['preferredGender']} only",
                    ),
                  Text(
                    voteData['Subject'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 200,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(latitude, longitude),
                        zoom: 14,
                      ),
                      markers: {
                        Marker(
                          markerId: MarkerId('voteLocation'),
                          position: LatLng(latitude, longitude),
                        ),
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.emoji_people),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "For " + voteData['Major'] + "  Students",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          Text(
                            voteData['question'],
                            style: TextStyle(
                                color: Color.fromARGB(255, 2, 0, 3),
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          LinearPercentIndicator(
                            width: MediaQuery.of(context).size.width - 100,
                            animation: true,
                            lineHeight: 60,
                            animationDuration: 1000,
                            percent: getValidPercent(optionAVotes),
                            barRadius: const Radius.circular(20),
                            progressColor: // Colors.green,
                                kPrimaryColor,
                            backgroundColor:
                                const Color.fromARGB(255, 224, 217, 217),
                            center: Text(
                              voteData['optionA'],
                              style: TextStyle(
                                color: Color.fromARGB(255, 2, 0, 3),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          LinearPercentIndicator(
                            width: MediaQuery.of(context).size.width - 100,
                            animation: true,
                            lineHeight: 60,
                            animationDuration: 1000,
                            percent: getValidPercent(optionBVotes),
                            barRadius: const Radius.circular(20),
                            progressColor: // Colors.green,
                                kPrimaryColor,
                            backgroundColor: Color.fromARGB(255, 224, 217, 217),
                            center: Text(
                              voteData['optionB'],
                              style: TextStyle(
                                color: Color.fromARGB(255, 2, 0, 3),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(Icons.thumb_up,
                                    color: votedUp ? kPrimaryColor : null),
                                //Colors.blue : null),
                                onPressed: () =>
                                    _vote(widget.voteRef, 'optionA', true),
                              ),
                              Text(optionAVotes.toString()),
                              IconButton(
                                icon: Icon(Icons.thumb_down,
                                    color: votedDown
                                        ? const Color.fromARGB(255, 161, 16, 6)
                                        : null),
                                onPressed: () =>
                                    _vote(widget.voteRef, 'optionB', false),
                              ),
                              Text(optionBVotes.toString()),
                              IconButton(
                                icon: Icon(Icons.people),
                                onPressed: () => _showVoters(context),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Time of the meeting can be added here
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _vote(DocumentReference voteRef, String field, bool isUpVote) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must be signed in to vote')),
      );
      return;
    }

    String userId = user.uid;

    // Check if user has already voted
    final voteDoc = await voteRef.get();
    final voteData = voteDoc.data() as Map<String, dynamic>;
    final voters = voteData['voters'] as Map<String, dynamic>?;

    if (voters != null && voters.containsKey(userId)) {
      final previousVote = voters[userId] as String;
      if (previousVote == field) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You have already voted for this option')),
        );
        return;
      }
    }

    // Update the UI
    setState(() {
      if (isUpVote) {
        votedUp = true;
        votedDown = false;
      } else {
        votedUp = false;
        votedDown = true;
      }
    });

    // Update Firestore
    String voteField = isUpVote ? 'optionAVotes' : 'optionBVotes';

    final batch = FirebaseFirestore.instance.batch();

    // Update vote counts
    batch.update(voteRef, {
      'voters.$userId': field,
      voteField: FieldValue.increment(1),
    });

    // Remove previous vote count
    if (voters != null) {
      final previousVote = voters[userId] as String;
      batch.update(voteRef, {
        'option${previousVote.substring(6)}Votes': FieldValue.increment(-1),
      });
    }

    await batch.commit();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Vote submitted')),
    );
  }

  void _showVoters(BuildContext context) async {
    final voteDoc = await widget.voteRef.get();
    final voteData = voteDoc.data() as Map<String, dynamic>;
    final voters = voteData['voters'] as Map<String, dynamic>?;

    if (voters == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No voters found')),
      );
      return;
    }

    List<VoterInfo> voterInfoList = [];

    for (String userId in voters.keys) {
      DocumentSnapshot studentDoc = await FirebaseFirestore.instance
          .collection('Students')
          .doc(userId)
          .get();

      if (studentDoc.exists) {
        final studentData = studentDoc.data() as Map<String, dynamic>;
        voterInfoList.add(VoterInfo(
            name: studentData['email'] ?? 'Unknown',
            profileImageUrl: studentData['profileImageUrl'] ?? '',
            voteOption: voters[userId] ?? '',
            IDNumber: studentData['IDNumber'] ?? '00000'));
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VotersListScreen(voterInfoList: voterInfoList),
      ),
    );
  }
}

*/

/*import 'package:appwithapi/Cstum/SlideBanner.dart';
import 'package:appwithapi/Cstum/constant.dart';
import 'package:appwithapi/poll/voterinfo.dart';
import 'package:appwithapi/poll/voterlistscreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';

class VoteDetailScreen extends StatefulWidget {
  final DocumentReference voteRef;

  VoteDetailScreen({required this.voteRef});

  @override
  _VoteDetailScreenState createState() => _VoteDetailScreenState();
}

class _VoteDetailScreenState extends State<VoteDetailScreen> {
  late Stream<DocumentSnapshot> _voteStream;
  bool votedUp = false;
  bool votedDown = false;

  @override
  void initState() {
    super.initState();
    _voteStream = widget.voteRef.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _voteStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator while waiting for data
        }

        if (!snapshot.hasData) {
          return Text('No data found'); // Show message if no data available
        }

        final voteData = snapshot.data!.data() as Map<String, dynamic>;
        final int optionAVotes = (voteData['optionAVotes'] ?? 0).toInt();
        final int optionBVotes = (voteData['optionBVotes'] ?? 0).toInt();
        final double latitude = voteData['latitude'] as double;
        final double longitude = voteData['longitude'] as double;

        double getValidPercent(int votes) {
          double percent = votes / (optionAVotes + optionBVotes).toDouble();
          if (percent < 0.0) {
            percent = 0.0;
          } else if (percent > 1.0) {
            percent = 1.0;
          }
          return percent;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Vote Details'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (voteData['preferredGender'] != "Any")
                    SlideBanner(
                      message:
                          "This meeting is for ${voteData['preferredGender']} only",
                    ),
                  Text(
                    voteData['Subject'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 200,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(latitude, longitude),
                        zoom: 14,
                      ),
                      markers: {
                        Marker(
                          markerId: MarkerId('voteLocation'),
                          position: LatLng(latitude, longitude),
                        ),
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.emoji_people),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "For " + voteData['Major'] + "  Students",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            voteData['question'],
                            style: TextStyle(
                                color: Color.fromARGB(255, 2, 0, 3),
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () => _vote(widget.voteRef, 'optionA', true),
                            onLongPress: () => _showVoters(context, 'optionA'),
                            child: LinearPercentIndicator(
                              width: MediaQuery.of(context).size.width - 100,
                              animation: true,
                              lineHeight: 60,
                              animationDuration: 1000,
                              percent: getValidPercent(optionAVotes),
                              barRadius: const Radius.circular(20),
                              progressColor: kPrimaryColor,
                              backgroundColor:
                                  const Color.fromARGB(255, 224, 217, 217),
                              center: Text(
                                voteData['optionA'],
                                style: TextStyle(
                                  color: Color.fromARGB(255, 2, 0, 3),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () =>
                                _vote(widget.voteRef, 'optionB', false),
                            onLongPress: () => _showVoters(context, 'optionB'),
                            child: LinearPercentIndicator(
                              width: MediaQuery.of(context).size.width - 100,
                              animation: true,
                              lineHeight: 60,
                              animationDuration: 1000,
                              percent: getValidPercent(optionBVotes),
                              barRadius: const Radius.circular(20),
                              progressColor: kPrimaryColor,
                              backgroundColor:
                                  const Color.fromARGB(255, 224, 217, 217),
                              center: Text(
                                voteData['optionB'],
                                style: TextStyle(
                                  color: Color.fromARGB(255, 2, 0, 3),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _vote(DocumentReference voteRef, String field, bool isUpVote) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must be signed in to vote')),
      );
      return;
    }

    String userId = user.uid;

    final voteDoc = await voteRef.get();
    final voteData = voteDoc.data() as Map<String, dynamic>;
    final voters = voteData['voters'] as Map<String, dynamic>?;

    if (voters != null && voters.containsKey(userId)) {
      final previousVote = voters[userId] as String;
      if (previousVote == field) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You have already voted for this option')),
        );
        return;
      }
    }

    setState(() {
      if (isUpVote) {
        votedUp = true;
        votedDown = false;
      } else {
        votedUp = false;
        votedDown = true;
      }
    });

    String voteField = isUpVote ? 'optionAVotes' : 'optionBVotes';

    final batch = FirebaseFirestore.instance.batch();

    batch.update(voteRef, {
      'voters.$userId': field,
      voteField: FieldValue.increment(1),
    });

    if (voters != null) {
      final previousVote = voters[userId] as String;
      batch.update(voteRef, {
        'option${previousVote.substring(6)}Votes': FieldValue.increment(-1),
      });
    }

    await batch.commit();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Vote submitted')),
    );
  }

  void _showVoters(BuildContext context, String option) async {
    final voteDoc = await widget.voteRef.get();
    final voteData = voteDoc.data() as Map<String, dynamic>;
    final voters = voteData['voters'] as Map<String, dynamic>?;

    if (voters == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No voters found')),
      );
      return;
    }

    List<VoterInfo> voterInfoList = [];

    for (String userId in voters.keys) {
      if (voters[userId] == option) {
        DocumentSnapshot studentDoc = await FirebaseFirestore.instance
            .collection('Students')
            .doc(userId)
            .get();

        if (studentDoc.exists) {
          final studentData = studentDoc.data() as Map<String, dynamic>;
          voterInfoList.add(VoterInfo(
              name: studentData['email'] ?? 'Unknown',
              profileImageUrl: studentData['profileImageUrl'] ?? '',
              voteOption: voters[userId] ?? '',
              IDNumber: studentData['IDNumber'] ?? '00000'));
        }
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VotersListScreen(voterInfoList: voterInfoList),
      ),
    );
  }
}
*/
/*


goooooood 
import 'package:appwithapi/Cstum/SlideBanner.dart';
import 'package:appwithapi/Cstum/constant.dart';
import 'package:appwithapi/poll/voterinfo.dart';
import 'package:appwithapi/poll/voterlistscreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';

class VoteDetailScreen extends StatefulWidget {
  final DocumentReference voteRef;

  VoteDetailScreen({required this.voteRef});

  @override
  _VoteDetailScreenState createState() => _VoteDetailScreenState();
}

class _VoteDetailScreenState extends State<VoteDetailScreen> {
  late Stream<DocumentSnapshot> _voteStream;
  bool votedUp = false;
  bool votedDown = false;

  @override
  void initState() {
    super.initState();
    _voteStream = widget.voteRef.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _voteStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator while waiting for data
        }

        if (!snapshot.hasData || snapshot.data!.data() == null) {
          return Text('No data found'); // Show message if no data available
        }

        final voteData = snapshot.data!.data() as Map<String, dynamic>;
        final int optionAVotes = (voteData['optionAVotes'] ?? 0).toInt();
        final int optionBVotes = (voteData['optionBVotes'] ?? 0).toInt();
        final Map<String, dynamic> voters =
            (voteData['voters'] ?? {}) as Map<String, dynamic>;
        final int totalVoters = voters.length;
        final double latitude = voteData['latitude'] is int
            ? (voteData['latitude'] as int).toDouble()
            : (voteData['latitude'] ?? 0.0).toDouble();
        final double longitude = voteData['longitude'] is int
            ? (voteData['longitude'] as int).toDouble()
            : (voteData['longitude'] ?? 0.0).toDouble();

        double getValidPercent(int votes) {
          double totalVotes = (optionAVotes + optionBVotes).toDouble();
          double percent = totalVotes > 0 ? votes / totalVotes : 0.0;
          return percent.clamp(0.0, 1.0);
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Vote Details'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (voteData['preferredGender'] != "Any")
                    SlideBanner(
                      message:
                          "This meeting is for ${voteData['preferredGender']} only",
                    ),
                  Text(
                    voteData['Subject'] ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 200,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(latitude, longitude),
                        zoom: 14,
                      ),
                      markers: {
                        Marker(
                          markerId: MarkerId('voteLocation'),
                          position: LatLng(latitude, longitude),
                        ),
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.emoji_people),
                              SizedBox(width: 20),
                              Text(
                                "For " + voteData['Major'] + " Students",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            voteData['question'] ?? '',
                            style: TextStyle(
                              color: Color.fromARGB(255, 2, 0, 3),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () => _vote(widget.voteRef, 'optionA', true),
                            onLongPress: () => _showVoters(context, 'optionA'),
                            child: LinearPercentIndicator(
                              width: MediaQuery.of(context).size.width - 100,
                              animation: true,
                              lineHeight: 60,
                              animationDuration: 1000,
                              percent: getValidPercent(optionAVotes),
                              barRadius: const Radius.circular(20),
                              progressColor: kPrimaryColor,
                              backgroundColor:
                                  const Color.fromARGB(255, 224, 217, 217),
                              center: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    voteData['optionA'] ?? '',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 2, 0, 3)),
                                  ),
                                  Text(
                                    '$optionAVotes votes',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 2, 0, 3)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () =>
                                _vote(widget.voteRef, 'optionB', false),
                            onLongPress: () => _showVoters(context, 'optionB'),
                            child: LinearPercentIndicator(
                              width: MediaQuery.of(context).size.width - 100,
                              animation: true,
                              lineHeight: 60,
                              animationDuration: 1000,
                              percent: getValidPercent(optionBVotes),
                              barRadius: const Radius.circular(20),
                              progressColor: kPrimaryColor,
                              backgroundColor:
                                  const Color.fromARGB(255, 224, 217, 217),
                              center: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    voteData['optionB'] ?? '',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 2, 0, 3)),
                                  ),
                                  Text(
                                    '$optionBVotes votes',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 2, 0, 3)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Total Voters: $totalVoters',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _vote(DocumentReference voteRef, String field, bool isUpVote) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must be signed in to vote')),
      );
      return;
    }

    String userId = user.uid;

    final voteDoc = await voteRef.get();
    final voteData = voteDoc.data() as Map<String, dynamic>;
    final voters = voteData['voters'] as Map<String, dynamic>?;

    if (voters != null && voters.containsKey(userId)) {
      final previousVote = voters[userId] as String?;
      if (previousVote == field) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You have already voted for this option')),
        );
        return;
      }
    }

    setState(() {
      if (isUpVote) {
        votedUp = true;
        votedDown = false;
      } else {
        votedUp = false;
        votedDown = true;
      }
    });

    String voteField = isUpVote ? 'optionAVotes' : 'optionBVotes';

    final batch = FirebaseFirestore.instance.batch();

    batch.update(voteRef, {
      'voters.$userId': field,
      voteField: FieldValue.increment(1),
    });

    if (voters != null) {
      final previousVote = voters[userId] as String?;
      if (previousVote != null) {
        batch.update(voteRef, {
          'option${previousVote.substring(6)}Votes': FieldValue.increment(-1),
        });
      }
    }

    await batch.commit();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Vote submitted')),
    );
  }

  void _showVoters(BuildContext context, String option) async {
    final voteDoc = await widget.voteRef.get();
    final voteData = voteDoc.data() as Map<String, dynamic>;
    final voters = voteData['voters'] as Map<String, dynamic>?;

    if (voters == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No voters found')),
      );
      return;
    }

    List<VoterInfo> voterInfoList = [];

    for (String userId in voters.keys) {
      if (voters[userId] == option) {
        DocumentSnapshot studentDoc = await FirebaseFirestore.instance
            .collection('Students')
            .doc(userId)
            .get();

        if (studentDoc.exists) {
          final studentData = studentDoc.data() as Map<String, dynamic>;
          voterInfoList.add(VoterInfo(
              name: studentData['email'] ?? 'Unknown',
              profileImageUrl: studentData['profileImageUrl'] ?? '',
              voteOption: voters[userId] ?? '',
              IDNumber: studentData['IDNumber'] ?? '00000'));
        }
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VotersListScreen(voterInfoList: voterInfoList),
      ),
    );
  }
}
*/
/*
import 'package:appwithapi/Cstum/SlideBanner.dart';
import 'package:appwithapi/Cstum/constant.dart';
import 'package:appwithapi/poll/voterinfo.dart';
import 'package:appwithapi/poll/voterlistscreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';

class VoteDetailScreen extends StatefulWidget {
  final DocumentReference voteRef;

  VoteDetailScreen({required this.voteRef});

  @override
  _VoteDetailScreenState createState() => _VoteDetailScreenState();
}

class _VoteDetailScreenState extends State<VoteDetailScreen> {
  late Stream<DocumentSnapshot> _voteStream;
  bool votedUp = false;
  bool votedDown = false;

  @override
  void initState() {
    super.initState();
    _voteStream = widget.voteRef.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _voteStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator while waiting for data
        }

        if (!snapshot.hasData || snapshot.data!.data() == null) {
          return Text('No data found'); // Show message if no data available
        }

        final voteData = snapshot.data!.data() as Map<String, dynamic>;
        final int optionAVotes = (voteData['optionAVotes'] ?? 0).toInt();
        final int optionBVotes = (voteData['optionBVotes'] ?? 0).toInt();
        final Map<String, dynamic> voters =
            (voteData['voters'] ?? {}) as Map<String, dynamic>;
        final int totalVoters = voters.length;
        final double latitude = voteData['latitude'] is int
            ? (voteData['latitude'] as int).toDouble()
            : (voteData['latitude'] ?? 0.0).toDouble();
        final double longitude = voteData['longitude'] is int
            ? (voteData['longitude'] as int).toDouble()
            : (voteData['longitude'] ?? 0.0).toDouble();

        double getValidPercent(int votes) {
          double totalVotes = (optionAVotes + optionBVotes).toDouble();
          double percent = totalVotes > 0 ? votes / totalVotes : 0.0;
          return percent.clamp(0.0, 1.0);
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Vote Details'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (voteData['preferredGender'] != "Any")
                    SlideBanner(
                      message:
                          "This meeting is for ${voteData['preferredGender']} only",
                    ),
                  Text(
                    voteData['Subject'] ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 200,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(latitude, longitude),
                        zoom: 14,
                      ),
                      markers: {
                        Marker(
                          markerId: MarkerId('voteLocation'),
                          position: LatLng(latitude, longitude),
                        ),
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.emoji_people),
                              SizedBox(width: 20),
                              Text(
                                "For " + voteData['Major'] + " Students",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            voteData['question'] ?? '',
                            style: TextStyle(
                              color: Color.fromARGB(255, 2, 0, 3),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () => _vote(widget.voteRef, 'optionA', true),
                            onLongPress: () => _showVoters(context, 'optionA'),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 8,
                                  child: LinearPercentIndicator(
                                    width:
                                        MediaQuery.of(context).size.width - 150,
                                    animation: true,
                                    lineHeight: 60,
                                    animationDuration: 1000,
                                    percent: getValidPercent(optionAVotes),
                                    barRadius: const Radius.circular(20),
                                    progressColor: kPrimaryColor,
                                    backgroundColor: const Color.fromARGB(
                                        255, 224, 217, 217),
                                    center: Text(
                                      voteData['optionA'] ?? '',
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 2, 0, 3)),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    '$optionAVotes votes',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 2, 0, 3)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () =>
                                _vote(widget.voteRef, 'optionB', false),
                            onLongPress: () => _showVoters(context, 'optionB'),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 8,
                                  child: LinearPercentIndicator(
                                    width:
                                        MediaQuery.of(context).size.width - 150,
                                    animation: true,
                                    lineHeight: 60,
                                    animationDuration: 1000,
                                    percent: getValidPercent(optionBVotes),
                                    barRadius: const Radius.circular(20),
                                    progressColor: kPrimaryColor,
                                    backgroundColor: const Color.fromARGB(
                                        255, 224, 217, 217),
                                    center: Text(
                                      voteData['optionB'] ?? '',
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 2, 0, 3)),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    '$optionBVotes votes',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 2, 0, 3)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Total Voters: $totalVoters',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _vote(DocumentReference voteRef, String field, bool isUpVote) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must be signed in to vote')),
      );
      return;
    }

    String userId = user.uid;

    final voteDoc = await voteRef.get();
    final voteData = voteDoc.data() as Map<String, dynamic>;
    final voters = voteData['voters'] as Map<String, dynamic>?;

    if (voters != null && voters.containsKey(userId)) {
      final previousVote = voters[userId] as String?;
      if (previousVote == field) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You have already voted for this option')),
        );
        return;
      }
    }

    setState(() {
      if (isUpVote) {
        votedUp = true;
        votedDown = false;
      } else {
        votedUp = false;
        votedDown = true;
      }
    });

    String voteField = isUpVote ? 'optionAVotes' : 'optionBVotes';

    final batch = FirebaseFirestore.instance.batch();

    batch.update(voteRef, {
      'voters.$userId': field,
      voteField: FieldValue.increment(1),
    });

    if (voters != null) {
      final previousVote = voters[userId] as String?;
      if (previousVote != null) {
        batch.update(voteRef, {
          'option${previousVote.substring(6)}Votes': FieldValue.increment(-1),
        });
      }
    }

    await batch.commit();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Vote submitted')),
    );
  }

  void _showVoters(BuildContext context, String option) async {
    final voteDoc = await widget.voteRef.get();
    final voteData = voteDoc.data() as Map<String, dynamic>;
    final voters = voteData['voters'] as Map<String, dynamic>?;

    if (voters == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No voters found')),
      );
      return;
    }

    List<VoterInfo> voterInfoList = [];

    for (String userId in voters.keys) {
      if (voters[userId] == option) {
        DocumentSnapshot studentDoc = await FirebaseFirestore.instance
            .collection('Students')
            .doc(userId)
            .get();

        if (studentDoc.exists) {
          final studentData = studentDoc.data() as Map<String, dynamic>;
          voterInfoList.add(VoterInfo(
              name: studentData['email'] ?? 'Unknown',
              profileImageUrl: studentData['profileImageUrl'] ?? '',
              voteOption: voters[userId] ?? '',
              IDNumber: studentData['IDNumber'] ?? '00000'));
        }
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VotersListScreen(voterInfoList: voterInfoList),
      ),
    );
  }
}
*/

/*

import 'package:appwithapi/Cstum/SlideBanner.dart';
import 'package:appwithapi/Cstum/constant.dart';
import 'package:appwithapi/poll/voterinfo.dart';
import 'package:appwithapi/poll/voterlistscreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';

class VoteDetailScreen extends StatefulWidget {
  final DocumentReference voteRef;

  VoteDetailScreen({required this.voteRef});

  @override
  _VoteDetailScreenState createState() => _VoteDetailScreenState();
}

class _VoteDetailScreenState extends State<VoteDetailScreen> {
  late Stream<DocumentSnapshot> _voteStream;
  bool votedUp = false;
  bool votedDown = false;

  @override
  void initState() {
    super.initState();
    _voteStream = widget.voteRef.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _voteStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator while waiting for data
        }

        if (!snapshot.hasData || snapshot.data!.data() == null) {
          return Text('No data found'); // Show message if no data available
        }

        final voteData = snapshot.data!.data() as Map<String, dynamic>;
        final int optionAVotes = (voteData['optionAVotes'] ?? 0).toInt();
        final int optionBVotes = (voteData['optionBVotes'] ?? 0).toInt();
        final Map<String, dynamic> voters =
            (voteData['voters'] ?? {}) as Map<String, dynamic>;
        final int totalVoters = voters.length;
        final double latitude = voteData['latitude'] is int
            ? (voteData['latitude'] as int).toDouble()
            : (voteData['latitude'] ?? 0.0).toDouble();
        final double longitude = voteData['longitude'] is int
            ? (voteData['longitude'] as int).toDouble()
            : (voteData['longitude'] ?? 0.0).toDouble();

        double getValidPercent(int votes) {
          double totalVotes = (optionAVotes + optionBVotes).toDouble();
          double percent = totalVotes > 0 ? votes / totalVotes : 0.0;
          return percent.clamp(0.0, 1.0);
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Vote Details'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (voteData['preferredGender'] != "Any")
                    SlideBanner(
                      message:
                          "This meeting is for ${voteData['preferredGender']} only",
                    ),
                  Text(
                    voteData['Subject'] ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 200,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(latitude, longitude),
                        zoom: 14,
                      ),
                      markers: {
                        Marker(
                          markerId: MarkerId('voteLocation'),
                          position: LatLng(latitude, longitude),
                        ),
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.emoji_people),
                              SizedBox(width: 20),
                              Text(
                                "For " + voteData['Major'] + " Students",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            voteData['question'] ?? '',
                            style: TextStyle(
                              color: Color.fromARGB(255, 2, 0, 3),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () => _vote(widget.voteRef, 'optionA', true),
                            onLongPress: () => _showVoters(context, 'optionA'),
                            child: Stack(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 8,
                                      child: LinearPercentIndicator(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                150,
                                        animation: true,
                                        lineHeight: 60,
                                        animationDuration: 1000,
                                        percent: getValidPercent(optionAVotes),
                                        barRadius: const Radius.circular(20),
                                        progressColor: kPrimaryColor,
                                        backgroundColor: const Color.fromARGB(
                                            255, 224, 217, 217),
                                        center: Text(
                                          voteData['optionA'] ?? '',
                                          style: TextStyle(
                                              color:
                                                  Color.fromARGB(255, 2, 0, 3)),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        children: [
                                          Text(
                                            '$optionAVotes ',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 2, 0, 3)),
                                          ),
                                          SizedBox(
                                            width: 2,
                                          ),
                                          Positioned(
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () => _showVoters(
                                                  context, 'optionA'),
                                              child: Container(
                                                width: 25,
                                                height: 25,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: kPrimaryColor,
                                                ),
                                                child: Icon(
                                                  Icons.people,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () =>
                                _vote(widget.voteRef, 'optionB', false),
                            onLongPress: () => _showVoters(context, 'optionB'),
                            child: Stack(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 8,
                                      child: LinearPercentIndicator(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                150,
                                        animation: true,
                                        lineHeight: 60,
                                        animationDuration: 1000,
                                        percent: getValidPercent(optionBVotes),
                                        barRadius: const Radius.circular(20),
                                        progressColor: kPrimaryColor,
                                        backgroundColor: const Color.fromARGB(
                                            255, 224, 217, 217),
                                        center: Text(
                                          voteData['optionB'] ?? '',
                                          style: TextStyle(
                                              color:
                                                  Color.fromARGB(255, 2, 0, 3)),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        children: [
                                          Text(
                                            '$optionBVotes ',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 2, 0, 3)),
                                          ),
                                          SizedBox(
                                            width: 2,
                                          ),
                                          Positioned(
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () => _showVoters(
                                                  context, 'optionB'),
                                              child: Container(
                                                width: 25,
                                                height: 25,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: kPrimaryColor,
                                                ),
                                                child: Icon(
                                                  Icons.people,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Total Voters: $totalVoters',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _vote(DocumentReference voteRef, String field, bool isUpVote) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must be signed in to vote')),
      );
      return;
    }

    String userId = user.uid;

    final voteDoc = await voteRef.get();
    final voteData = voteDoc.data() as Map<String, dynamic>;
    final voters = voteData['voters'] as Map<String, dynamic>?;

    if (voters != null && voters.containsKey(userId)) {
      final previousVote = voters[userId] as String?;
      if (previousVote == field) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You have already voted for this option')),
        );
        return;
      }
    }

    setState(() {
      if (isUpVote) {
        votedUp = true;
        votedDown = false;
      } else {
        votedUp = false;
        votedDown = true;
      }
    });

    String voteField = isUpVote ? 'optionAVotes' : 'optionBVotes';

    final batch = FirebaseFirestore.instance.batch();

    batch.update(voteRef, {
      'voters.$userId': field,
      voteField: FieldValue.increment(1),
    });

    if (voters != null) {
      final previousVote = voters[userId] as String?;
      if (previousVote != null) {
        batch.update(voteRef, {
          'option${previousVote.substring(6)}Votes': FieldValue.increment(-1),
        });
      }
    }

    await batch.commit();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Vote submitted')),
    );
  }

  void _showVoters(BuildContext context, String option) async {
    final voteDoc = await widget.voteRef.get();
    final voteData = voteDoc.data() as Map<String, dynamic>;
    final voters = voteData['voters'] as Map<String, dynamic>?;

    if (voters == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No voters found')),
      );
      return;
    }

    List<VoterInfo> voterInfoList = [];

    for (String userId in voters.keys) {
      if (voters[userId] == option) {
        DocumentSnapshot studentDoc = await FirebaseFirestore.instance
            .collection('Students')
            .doc(userId)
            .get();

        if (studentDoc.exists) {
          final studentData = studentDoc.data() as Map<String, dynamic>;
          voterInfoList.add(VoterInfo(
              name: studentData['email'] ?? 'Unknown',
              profileImageUrl: studentData['profileImageUrl'] ?? '',
              voteOption: voters[userId] ?? '',
              IDNumber: studentData['IDNumber'] ?? '00000'));
        }
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VotersListScreen(voterInfoList: voterInfoList),
      ),
    );
  }
}
*/

import 'package:appwithapi/Cstum/SlideBanner.dart';
import 'package:appwithapi/Cstum/constant.dart';
import 'package:appwithapi/poll/voterinfo.dart';
import 'package:appwithapi/poll/voterlistscreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';

class VoteDetailScreen extends StatefulWidget {
  final DocumentReference voteRef;

  VoteDetailScreen({required this.voteRef});

  @override
  _VoteDetailScreenState createState() => _VoteDetailScreenState();
}

class _VoteDetailScreenState extends State<VoteDetailScreen> {
  late Stream<DocumentSnapshot> _voteStream;
  bool votedUp = false;
  bool votedDown = false;

  @override
  void initState() {
    super.initState();
    _voteStream = widget.voteRef.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _voteStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator while waiting for data
        }

        if (!snapshot.hasData || snapshot.data!.data() == null) {
          return Text('No data found'); // Show message if no data available
        }

        final voteData = snapshot.data!.data() as Map<String, dynamic>;
        final int optionAVotes = (voteData['optionAVotes'] ?? 0).toInt();
        final int optionBVotes = (voteData['optionBVotes'] ?? 0).toInt();
        final voters = voteData['voters'];
        Map<String, dynamic>? votersMap;

        if (voters is Map<String, dynamic>) {
          votersMap = voters;
        } else {
          votersMap = {};
        }
        final votersData = voteData['voters'];
        int totalVoters = 0;

        if (votersData != null && votersData is Map<String, dynamic>) {
          totalVoters = votersData.length;
        }
        final double latitude = voteData['latitude'] is int
            ? (voteData['latitude'] as int).toDouble()
            : (voteData['latitude'] ?? 0.0).toDouble();
        final double longitude = voteData['longitude'] is int
            ? (voteData['longitude'] as int).toDouble()
            : (voteData['longitude'] ?? 0.0).toDouble();

        double getValidPercent(int votes) {
          double totalVotes = (optionAVotes + optionBVotes).toDouble();
          double percent = totalVotes > 0 ? votes / totalVotes : 0.0;
          return percent.clamp(0.0, 1.0);
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Vote Details'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (voteData['preferredGender'] != "Any")
                    SlideBanner(
                      message:
                          "This meeting is for ${voteData['preferredGender']} only",
                    ),
                  Text(
                    voteData['Subject'] ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 200,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(latitude, longitude),
                        zoom: 14,
                      ),
                      markers: {
                        Marker(
                          markerId: MarkerId('voteLocation'),
                          position: LatLng(latitude, longitude),
                        ),
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.emoji_people),
                              SizedBox(width: 20),
                              Text(
                                "For " + voteData['Major'] + " Students",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            voteData['question'] ?? '',
                            style: TextStyle(
                              color: Color.fromARGB(255, 2, 0, 3),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () => _vote(widget.voteRef, 'optionA', true),
                            onLongPress: () => _showVoters(context, 'optionA'),
                            child: Stack(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 8,
                                      child: LinearPercentIndicator(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                150,
                                        animation: true,
                                        lineHeight: 60,
                                        animationDuration: 1000,
                                        percent: getValidPercent(optionAVotes),
                                        barRadius: const Radius.circular(20),
                                        progressColor: kPrimaryColor,
                                        backgroundColor: const Color.fromARGB(
                                            255, 224, 217, 217),
                                        center: Text(
                                          voteData['optionA'] ?? '',
                                          style: TextStyle(
                                              color:
                                                  Color.fromARGB(255, 2, 0, 3)),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        children: [
                                          Text(
                                            '$optionAVotes ',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 2, 0, 3)),
                                          ),
                                          SizedBox(width: 2),
                                          GestureDetector(
                                            onTap: () =>
                                                _showVoters(context, 'optionA'),
                                            child: Container(
                                              width: 25,
                                              height: 25,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: kPrimaryColor,
                                              ),
                                              child: Icon(
                                                Icons.people,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () =>
                                _vote(widget.voteRef, 'optionB', false),
                            onLongPress: () => _showVoters(context, 'optionB'),
                            child: Stack(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 8,
                                      child: LinearPercentIndicator(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                150,
                                        animation: true,
                                        lineHeight: 60,
                                        animationDuration: 1000,
                                        percent: getValidPercent(optionBVotes),
                                        barRadius: const Radius.circular(20),
                                        progressColor: kPrimaryColor,
                                        backgroundColor: const Color.fromARGB(
                                            255, 224, 217, 217),
                                        center: Text(
                                          voteData['optionB'] ?? '',
                                          style: TextStyle(
                                              color:
                                                  Color.fromARGB(255, 2, 0, 3)),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        children: [
                                          Text(
                                            '$optionBVotes ',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 2, 0, 3)),
                                          ),
                                          SizedBox(width: 2),
                                          GestureDetector(
                                            onTap: () =>
                                                _showVoters(context, 'optionB'),
                                            child: Container(
                                              width: 25,
                                              height: 25,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: kPrimaryColor,
                                              ),
                                              child: Icon(
                                                Icons.people,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Total Voters: $totalVoters',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _vote(DocumentReference voteRef, String field, bool isUpVote) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must be signed in to vote')),
      );
      return;
    }

    String userId = user.uid;

    // Retrieve user's gender from Firestore
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('Students')
        .doc(userId)
        .get();
    Map<String, dynamic>? userData = userDoc.data() as Map<String,
        dynamic>?; // Explicit cast to Map<String, dynamic> or null
    String userGender = userData?['gender'] ?? 'Any';

    final voteDoc = await voteRef.get();
    final voteData = voteDoc.data() as Map<String, dynamic>;

    // Check if the vote is restricted by gender
    String preferredGender = voteData['preferredGender'] ?? 'Any';

    if (preferredGender != 'Any' && userGender != preferredGender) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Only $preferredGender can vote in this poll')),
      );
      return;
    }

    // Access previous vote
    final voters = voteData['voters'] as Map<String, dynamic>?;

    if (voters != null && voters.containsKey(userId)) {
      final previousVote = voters[userId];
      if (previousVote is String) {
        if (previousVote == field) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('You have already voted for this option')),
          );
          return;
        }
      }
    }

    // Update the UI
    setState(() {
      if (isUpVote) {
        votedUp = true;
        votedDown = false;
      } else {
        votedUp = false;
        votedDown = true;
      }
    });

    // Update Firestore
    String voteField = isUpVote ? 'optionAVotes' : 'optionBVotes';

    final batch = FirebaseFirestore.instance.batch();

    batch.update(voteRef, {
      'voters.$userId': field,
      voteField: FieldValue.increment(1),
    });

    if (voters != null) {
      final previousVote = voters[userId];
      if (previousVote is String) {
        batch.update(voteRef, {
          'option${previousVote.substring(6)}Votes': FieldValue.increment(-1),
        });
      }
    }

    await batch.commit();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Vote submitted')),
    );
  }

  void _showVoters(BuildContext context, String option) async {
    final voteDoc = await widget.voteRef.get();
    final voteData = voteDoc.data() as Map<String, dynamic>;
    final voters = voteData['voters'] as Map<String, dynamic>?;

    if (voters == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No voters found')),
      );
      return;
    }

    List<VoterInfo> voterInfoList = [];

    for (String userId in voters.keys) {
      if (voters[userId] == option) {
        DocumentSnapshot studentDoc = await FirebaseFirestore.instance
            .collection('Students')
            .doc(userId)
            .get();

        if (studentDoc.exists) {
          final studentData = studentDoc.data() as Map<String, dynamic>;
          voterInfoList.add(VoterInfo(
              name: studentData['email'] ?? 'Unknown',
              profileImageUrl: studentData['profileImageUrl'] ?? '',
              voteOption: voters[userId] ?? '',
              IDNumber: studentData['IDNumber'] ?? '00000'));
        }
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VotersListScreen(voterInfoList: voterInfoList),
      ),
    );
  }
}
