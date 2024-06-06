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
