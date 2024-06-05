/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VoteList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    int optionAVotes = widget.vote['optionAVotes'] ?? 0;
    int optionBVotes = widget.vote['optionBVotes'] ?? 0;
    List<dynamic> optionAVoters = widget.vote['optionAVoters'] ?? [];
    List<dynamic> optionBVoters = widget.vote['optionBVoters'] ?? [];

    return ListTile(
      title: Text(widget.vote['optionA']),
      subtitle: Text(widget.vote['optionB']),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.thumb_up, color: votedUp ? Colors.blue : null),
            onPressed: () => _vote(widget.vote.id, 'optionA', true),
          ),
          Text(optionAVotes.toString()),
          IconButton(
            icon: Icon(Icons.thumb_down, color: votedDown ? Colors.red : null),
            onPressed: () => _vote(widget.vote.id, 'optionB', false),
          ),
          Text(optionBVotes.toString()),
          IconButton(
            icon: Icon(Icons.people),
            onPressed: () =>
                _showVoters(context, votedUp ? optionAVoters : optionBVoters),
          ),
        ],
      ),
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
    DocumentReference voteRef =
        FirebaseFirestore.instance.collection('Votes').doc(voteId);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(voteRef);
      if (!snapshot.exists) {
        throw Exception("Vote does not exist!");
      }

      var data = snapshot.data() as Map<String, dynamic>?;

      if (data == null) {
        throw Exception("Document data is null!");
      }

      List voters = data['voters'] ?? [];
      bool hasVoted = voters.contains(userId);

      // If user has already voted for this option and wants to remove vote
      if (hasVoted && ((isUpVote && votedUp) || (!isUpVote && votedDown))) {
        int currentVotes = data[field + 'Votes'];
        transaction.update(voteRef, {
          field + 'Votes': currentVotes - 1,
          'voters': FieldValue.arrayRemove([userId]),
          isUpVote ? 'optionAVoters' : 'optionBVoters':
              FieldValue.arrayRemove([userId]),
        });

        setState(() {
          if (isUpVote) {
            votedUp = false;
          } else {
            votedDown = false;
          }
        });
      } else {
        // If user hasn't voted for this option or wants to change vote
        // First, remove user's vote from any other option
        for (var otherField in ['optionA', 'optionB']) {
          if (otherField != field) {
            List otherVoters = data[otherField + 'Voters'] ?? [];
            if (otherVoters.contains(userId)) {
              transaction.update(voteRef, {
                otherField + 'Votes': data[otherField + 'Votes'] - 1,
                otherField + 'Voters': FieldValue.arrayRemove([userId]),
              });
            }
          }
        }

        // Add the vote for the selected option
        int currentVotes = data[field + 'Votes'];
        transaction.update(voteRef, {
          field + 'Votes': currentVotes + 1,
          'voters': FieldValue.arrayUnion([userId]),
          isUpVote ? 'optionAVoters' : 'optionBVoters':
              FieldValue.arrayUnion([userId]),
        });

        setState(() {
          if (isUpVote) {
            votedUp = true;
            votedDown = false;
          } else {
            votedUp = false;
            votedDown = true;
          }
        });
      }
    });
  }

  void _showVoters(BuildContext context, List<dynamic> voters) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VotersListScreen(voters: voters),
      ),
    );
  }
}

class VotersListScreen extends StatelessWidget {
  final List<dynamic> voters;

  VotersListScreen({required this.voters});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voters List'),
      ),
      body: ListView.builder(
        itemCount: voters.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(voters[index]),
          );
        },
      ),
    );
  }
}
*/

/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class VoteList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    int optionAVotes = widget.vote['optionAVotes'] ?? 0;
    int optionBVotes = widget.vote['optionBVotes'] ?? 0;

    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.grey,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          widget.vote['question'], // Display question here
                          style: GoogleFonts.poppins(
                            color: Color.fromARGB(255, 2, 0, 3),
                          ),
                        ),
                        const SizedBox(height: 10),
                        LinearPercentIndicator(
                          width: MediaQuery.of(context).size.width - 100,
                          animation: true,
                          lineHeight: 60,
                          animationDuration: 1000,
                          percent: optionAVotes / 10, // Adjust as needed
                          barRadius: const Radius.circular(20),
                          progressColor: Colors.green,
                          backgroundColor:
                              const Color.fromARGB(255, 224, 217, 217),
                          center: Text(
                            widget.vote['optionA'], // Display option A here
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
                          percent: optionBVotes / 10, // Adjust as needed
                          barRadius: const Radius.circular(20),
                          progressColor: Colors.green,
                          backgroundColor: Color.fromARGB(255, 224, 217, 217),
                          center: Text(
                            widget.vote['optionB'], // Display option B here
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
        );
      },
    );
  }

  /*void _vote(String voteId, String field, bool isUpVote) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must be signed in to vote')),
      );
      return;
    }

    String userId = user.uid;
    DocumentReference voteRef =
        FirebaseFirestore.instance.collection('Votes').doc(voteId);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(voteRef);
      if (!snapshot.exists) {
        throw Exception("Vote does not exist!");
      }

      var data = snapshot.data() as Map<String, dynamic>?;

      if (data == null) {
        throw Exception("Document data is null!");
      }

      List voters = data['voters'] ?? [];
      bool hasVoted = voters.contains(userId);

      // If user has already voted for this option and wants to remove vote
      if (hasVoted && ((isUpVote && votedUp) || (!isUpVote && votedDown))) {
        int currentVotes = data[field + 'Votes'];
        transaction.update(voteRef, {
          field + 'Votes': currentVotes - 1,
          'voters': FieldValue.arrayRemove([userId]),
          isUpVote ? 'optionAVoters' : 'optionBVoters':
              FieldValue.arrayRemove([userId]),
        });

        setState(() {
          if (isUpVote) {
            votedUp = false;
          } else {
            votedDown = false;
          }
        });
      } else {
        // If user hasn't voted for this option or wants to change vote
        // First, remove user's vote from any other option
        for (var otherField in ['optionA', 'optionB']) {
          if (otherField != field) {
            List otherVoters = data[otherField + 'Voters'] ?? [];
            if (otherVoters.contains(userId)) {
              transaction.update(voteRef, {
                otherField + 'Votes': data[otherField + 'Votes'] - 1,
                otherField + 'Voters': FieldValue.arrayRemove([userId]),
              });
            }
          }
        }

        // Add the vote for the selected option
        int currentVotes = data[field + 'Votes'];
        transaction.update(voteRef, {
          field + 'Votes': currentVotes + 1,
          'voters': FieldValue.arrayUnion([userId]),
          isUpVote ? 'optionAVoters' : 'optionBVoters':
              FieldValue.arrayUnion([userId]),
        });

        setState(() {
          if (isUpVote) {
            votedUp = true;
            votedDown = false;
          } else {
            votedUp = false;
            votedDown = true;
          }
        });
      }
    });
  }*/
  void _vote(String voteId, String field, bool isUpVote) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must be signed in to vote')),
      );
      return;
    }

    String userId = user.uid;
    DocumentReference voteRef =
        FirebaseFirestore.instance.collection('Votes').doc(voteId);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(voteRef);
      if (!snapshot.exists) {
        throw Exception("Vote does not exist!");
      }

      var data = snapshot.data() as Map<String, dynamic>?;

      if (data == null) {
        throw Exception("Document data is null!");
      }

      List voters = data['voters'] ?? [];
      bool hasVoted = voters.contains(userId);

      if (hasVoted) {
        // User has already voted, so remove the previous vote
        String previousVoteField = isUpVote ? 'optionB' : 'optionA';
        int previousVoteCount = data[previousVoteField + 'Votes'];
        transaction.update(voteRef, {
          previousVoteField + 'Votes': previousVoteCount - 1,
          'voters': FieldValue.arrayRemove([userId]),
          isUpVote ? 'optionBVoters' : 'optionAVoters':
              FieldValue.arrayRemove([userId]),
        });
      }

      // Add the vote for the selected option
      int currentVotes = data[field + 'Votes'];
      transaction.update(voteRef, {
        field + 'Votes': currentVotes + 1,
        'voters': FieldValue.arrayUnion([userId]),
        isUpVote ? 'optionAVoters' : 'optionBVoters':
            FieldValue.arrayUnion([userId]),
      });

      setState(() {
        if (isUpVote) {
          votedUp = true;
          votedDown = false;
        } else {
          votedUp = false;
          votedDown = true;
        }
      });
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

/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class VoteList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    int optionAVotes = widget.vote['optionAVotes'] ?? 0;
    int optionBVotes = widget.vote['optionBVotes'] ?? 0;

    double getValidPercent(int votes) {
      double percent = votes / 10;
      if (percent < 0.0) {
        percent = 0.0;
      } else if (percent > 1.0) {
        percent = 1.0;
      }
      return percent;
    }

    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.grey,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          widget.vote['question'], // Display question here
                          style: GoogleFonts.poppins(
                            color: Color.fromARGB(255, 2, 0, 3),
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
                            widget.vote['optionA'], // Display option A here
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
                            widget.vote['optionB'], // Display option B here
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
    DocumentReference voteRef =
        FirebaseFirestore.instance.collection('Votes').doc(voteId);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(voteRef);
      if (!snapshot.exists) {
        throw Exception("Vote does not exist!");
      }

      var data = snapshot.data() as Map<String, dynamic>?;

      if (data == null) {
        throw Exception("Document data is null!");
      }

      List voters = data['voters'] ?? [];
      bool hasVoted = voters.contains(userId);

      if (hasVoted) {
        // User has already voted, so remove the previous vote
        String previousVoteField = isUpVote ? 'optionB' : 'optionA';
        int previousVoteCount = data[previousVoteField + 'Votes'];
        transaction.update(voteRef, {
          previousVoteField + 'Votes': previousVoteCount - 1,
          'voters': FieldValue.arrayRemove([userId]),
          isUpVote ? 'optionBVoters' : 'optionAVoters':
              FieldValue.arrayRemove([userId]),
        });
      }

      // Add the vote for the selected option
      int currentVotes = data[field + 'Votes'];
      transaction.update(voteRef, {
        field + 'Votes': currentVotes + 1,
        'voters': FieldValue.arrayUnion([userId]),
        isUpVote ? 'optionAVoters' : 'optionBVoters':
            FieldValue.arrayUnion([userId]),
      });

      setState(() {
        if (isUpVote) {
          votedUp = true;
          votedDown = false;
        } else {
          votedUp = false;
          votedDown = true;
        }
      });
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
/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class VoteList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    int optionAVotes = widget.vote['optionAVotes'] ?? 0;
    int optionBVotes = widget.vote['optionBVotes'] ?? 0;
    double latitude = widget.vote['latitude'];
    double longitude = widget.vote['longitude'];

    double getValidPercent(int votes) {
      double percent = votes / 10;
      if (percent < 0.0) {
        percent = 0.0;
      } else if (percent > 1.0) {
        percent = 1.0;
      }
      return percent;
    }

    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.grey,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          widget.vote['question'], // Display question here
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
                            widget.vote['optionA'], // Display option A here
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
                            widget.vote['optionB'], // Display option B here
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
    DocumentReference voteRef =
        FirebaseFirestore.instance.collection('Votes').doc(voteId);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(voteRef);
      if (!snapshot.exists) {
        throw Exception("Vote does not exist!");
      }

      var data = snapshot.data() as Map<String, dynamic>?;

      if (data == null) {
        throw Exception("Document data is null!");
      }

      List voters = data['voters'] ?? [];
      bool hasVoted = voters.contains(userId);

      if (hasVoted) {
        // User has already voted, so remove the previous vote
        String previousVoteField = isUpVote ? 'optionB' : 'optionA';
        int previousVoteCount = data[previousVoteField + 'Votes'];
        transaction.update(voteRef, {
          previousVoteField + 'Votes': previousVoteCount - 1,
          'voters': FieldValue.arrayRemove([userId]),
          isUpVote ? 'optionBVoters' : 'optionAVoters':
              FieldValue.arrayRemove([userId]),
        });
      }

      // Add the vote for the selected option
      int currentVotes = data[field + 'Votes'];
      transaction.update(voteRef, {
        field + 'Votes': currentVotes + 1,
        'voters': FieldValue.arrayUnion([userId]),
        isUpVote ? 'optionAVoters' : 'optionBVoters':
            FieldValue.arrayUnion([userId]),
      });

      setState(() {
        if (isUpVote) {
          votedUp = true;
          votedDown = false;
        } else {
          votedUp = false;
          votedDown = true;
        }
      });
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

/*promlem on size and shzpe
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
    int optionAVotes = widget.vote['optionAVotes'] ?? 0;
    int optionBVotes = widget.vote['optionBVotes'] ?? 0;
    double latitude = widget.vote['latitude'];
    double longitude = widget.vote['longitude'];

    double getValidPercent(int votes) {
      double percent = votes / 10;
      if (percent < 0.0) {
        percent = 0.0;
      } else if (percent > 1.0) {
        percent = 1.0;
      }
      return percent;
    }

    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.grey,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            widget.vote['question'], // Display question here
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
                              widget.vote['optionA'], // Display option A here
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
                              widget.vote['optionB'], // Display option B here
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
    User? user = FirebaseAuth.instance.currentUser!;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must be signed in to vote')),
      );
      return;
    }

    String userId = user.uid;
    DocumentReference voteRef =
        FirebaseFirestore.instance.collection('Votes').doc(voteId);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(voteRef);
      if (!snapshot.exists) {
        throw Exception("Vote does not exist!");
      }

      var data = snapshot.data() as Map<String, dynamic>?;

      if (data == null) {
        throw Exception("Document data is null!");
      }

      List voters = data['voters'] ?? [];
      bool hasVoted = voters.contains(userId);

      if (hasVoted) {
        // User has already voted, so remove the previous vote
        String previousVoteField = isUpVote ? 'optionB' : 'optionA';
        int previousVoteCount = data[previousVoteField + 'Votes'];
        transaction.update(voteRef, {
          previousVoteField + 'Votes': previousVoteCount - 1,
          'voters': FieldValue.arrayRemove([userId]),
          isUpVote ? 'optionBVoters' : 'optionAVoters':
              FieldValue.arrayRemove([userId]),
        });
      }

      // Add the vote for the selected option
      int currentVotes = data[field + 'Votes'];
      transaction.update(voteRef, {
        field + 'Votes': currentVotes + 1,
        'voters': FieldValue.arrayUnion([userId]),
        isUpVote ? 'optionAVoters' : 'optionBVoters':
            FieldValue.arrayUnion([userId]),
      });

      setState(() {
        if (isUpVote) {
          votedUp = true;
          votedDown = false;
        } else {
          votedUp = false;
          votedDown = true;
        }
      });
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

/*  is Correct
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
    int optionAVotes = widget.vote['optionAVotes'] ?? 0;
    int optionBVotes = widget.vote['optionBVotes'] ?? 0;
    double latitude = widget.vote['latitude'];
    double longitude = widget.vote['longitude'];

    double getValidPercent(int votes) {
      double percent = votes / 10;
      if (percent < 0.0) {
        percent = 0.0;
      } else if (percent > 1.0) {
        percent = 1.0;
      }
      return percent;
    }

    return Builder(
      builder: (context) {
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
                      color: Colors.grey,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            widget.vote['question'], // Display question here
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
                              widget.vote['optionA'], // Display option A here
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
                              widget.vote['optionB'], // Display option B here
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

    if (votedUp && isUpVote || votedDown && !isUpVote) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You have already voted for this option')),
      );
      return;
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

    await FirebaseFirestore.instance.collection('Votes').doc(voteId).update({
      voteField: FieldValue.increment(1),
      'voters.$userId': isUpVote ? 'optionA' : 'optionB',
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

import 'package:appwithapi/Cstum/constant.dart';
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

  /*void _vote(String voteId, String field, bool isUpVote) async {
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

    // Update vote data in Firestore
    await FirebaseFirestore.instance.collection('Votes').doc(voteId).update({
      voteField: FieldValue.increment(1),
      'voters.$userId': isUpVote ? 'optionA' : 'optionB',
    });
  }
*/
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
