/*import 'package:appwithapi/Cstum/constant.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class VoteList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        title: Text('Vote List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Votes').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var votes = snapshot.data!.docs;

          return ListView.builder(
            itemCount: votes.length,
            itemBuilder: (context, index) {
              var vote = votes[index];
              return VoteTile(vote: vote);
            },
          );
        },
      ),
    );
  }
}

class VoteTile extends StatefulWidget {
  final DocumentSnapshot vote;

  const VoteTile({Key? key, required this.vote}) : super(key: key);

  @override
  _VoteTileState createState() => _VoteTileState();
}

class _VoteTileState extends State<VoteTile> {
  bool votedUp = false;
  bool votedDown = false;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final voteData = widget.vote.data() as Map<String, dynamic>;
        final int optionAVotes = voteData['optionAVotes'] ?? 0;
        final int optionBVotes = voteData['optionBVotes'] ?? 0;
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

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    width: 400,
                    height: 500,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.white
                        // Colors.grey,
                        ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            voteData['question'], // Display question here
                            style: GoogleFonts.poppins(
                              color: Color.fromARGB(255, 2, 0, 3),
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
                          LinearPercentIndicator(
                            width: MediaQuery.of(context).size.width - 100,
                            animation: true,
                            lineHeight: 60,
                            animationDuration: 1000,
                            percent: getValidPercent(optionAVotes),
                            barRadius: const Radius.circular(20),
                            progressColor: Colors.green,
                            backgroundColor:
                                const Color.fromARGB(255, 224, 217, 217),
                            center: Text(
                              voteData['optionA'], // Display option A here
                              style: GoogleFonts.poppins(
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
                            progressColor: Colors.green,
                            backgroundColor: Color.fromARGB(255, 224, 217, 217),
                            center: Text(
                              voteData['optionB'], // Display option B here
                              style: GoogleFonts.poppins(
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
                                    color: votedUp ? Colors.blue : null),
                                onPressed: () =>
                                    _vote(widget.vote.id, 'optionA', true),
                              ),
                              Text(optionAVotes.toString()),
                              IconButton(
                                icon: Icon(Icons.thumb_down,
                                    color: votedDown ? Colors.red : null),
                                onPressed: () =>
                                    _vote(widget.vote.id, 'optionB', false),
                              ),
                              Text(optionBVotes.toString()),
                              IconButton(
                                icon: Icon(Icons.people),
                                onPressed: () => _showVoters(context,
                                    votedUp ? optionAVotes : optionBVotes),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _vote(String voteId, String field, bool isUpVote) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must be signed in to vote')),
      );
      return;
    }

    String userId = user.uid;

    // Retrieve vote data
    DocumentSnapshot voteSnapshot =
        await FirebaseFirestore.instance.collection('Votes').doc(voteId).get();
    Map<String, dynamic>? voteData =
        voteSnapshot.data() as Map<String, dynamic>?;

    // Check if voters map exists and if user has already voted
    if (voteData != null && voteData['voters'] != null) {
      Map<String, dynamic> voters = voteData['voters'];
      if (voters.containsKey(userId)) {
        String previousVote = voters[userId];
        if (previousVote == field) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('You have already voted for this option')),
          );
          return;
        } else {
          // Remove previous vote
          await FirebaseFirestore.instance
              .collection('Votes')
              .doc(voteId)
              .update({
            'voters.$userId': FieldValue.delete(),
            'option${previousVote.substring(6)}Votes': FieldValue.increment(-1),
          });
        }
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

    // Update vote data in Firestore
    await FirebaseFirestore.instance.collection('Votes').doc(voteId).update({
      voteField: FieldValue.increment(1),
      'voters.$userId': field,
    });
  }

  void _showVoters(BuildContext context, int votes) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VotersListScreen(voters: votes),
      ),
    );
  }
}

class VotersListScreen extends StatelessWidget {
  final int voters;

  VotersListScreen({required this.voters});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voters List'),
      ),
      body: ListView.builder(
        itemCount: voters,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Voter ${index + 1}'),
          );
        },
      ),
    );
  }
}
*/