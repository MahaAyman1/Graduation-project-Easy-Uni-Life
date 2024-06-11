import 'package:appwithapi/Cstum/constant.dart';
import 'package:appwithapi/poll/CreateVoteForm.dart';
import 'package:appwithapi/poll/VoteDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VotedList extends StatefulWidget {
  @override
  State<VotedList> createState() => _VotedListState();
}

class _VotedListState extends State<VotedList> {
  late TextEditingController _searchController;
  String selectedGender = 'All';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          'Study With Me',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showFilterDialog(context);
            },
            icon: Icon(
              Icons.filter_list,
              color: Colors.white,
            ),
          ),
        ],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {});
                  },
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
                labelStyle: TextStyle(color: Colors.white),
              ),
              style: TextStyle(color: Colors.white),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('Votes').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final votes = snapshot.data!.docs;

                final filteredVotes = votes.where((vote) {
                  final department =
                      vote['Department'].toString().toLowerCase();
                  final major = vote['Major'].toString().toLowerCase();
                  final subject = vote['Subject'].toString().toLowerCase();
                  final searchValue = _searchController.text.toLowerCase();
                  return department.contains(searchValue) ||
                      major.contains(searchValue) ||
                      subject.contains(searchValue);
                }).toList();
                final genderFilteredVotes = selectedGender != 'All'
                    ? filteredVotes
                        .where(
                            (vote) => vote['preferredGender'] == selectedGender)
                        .toList()
                    : filteredVotes;

                /*      final genderFilteredVotes = selectedGender != 'Any'
                    ? filteredVotes
                        .where(
                            (vote) => vote['preferredGender'] == selectedGender)
                        .toList()
                    : filteredVotes;*/

                return ListView.builder(
                  itemCount: genderFilteredVotes.length,
                  itemBuilder: (context, index) {
                    final vote = genderFilteredVotes[index];
                    final department = vote['Department'];
                    final major = vote['Major'];
                    final subject = vote['Subject'];
                    final time = vote['time'];
                    final preferredGender = vote['preferredGender'];

                    final remainingTime = time != null
                        ? (time as Timestamp)
                            .toDate()
                            .difference(DateTime.now())
                        : null;

                    final remainingDays =
                        remainingTime != null ? remainingTime.inDays : null;

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Colors.white,
                        child: ListTile(
                          title: Center(
                            child: Text(
                              ' $department',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 8),
                              Text(' $major'),
                              SizedBox(height: 8),
                              Text(' $subject'),
                              SizedBox(height: 8),
                              if (remainingDays != null)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.timer_sharp),
                                        Text(' $remainingDays days'),
                                      ],
                                    ),
                                    if (preferredGender != 'Any')
                                      Text('Just For $preferredGender')
                                    else
                                      Text("Welcome, everyone!")
                                  ],
                                )
                              else
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('No time limit'),
                                    if (preferredGender != 'Any')
                                      Text('Just For $preferredGender')
                                    else
                                      Text("Welcome, everyone!")
                                  ],
                                ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    VoteDetailScreen(voteRef: vote.reference),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateVoteForm(),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
    );
  }

  /*void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Filter By Gender'),
        content: DropdownButton<String>(
          value: selectedGender,
          onChanged: (value) {
            setState(() {
              selectedGender = value!;
            });
            Navigator.pop(context);
          },
          items: <String>['Any', 'Male', 'Female']
              .map((String value) => DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  ))
              .toList(),
        ),
      ),
    );*/

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Filter By Gender'),
        content: DropdownButton<String>(
          value: selectedGender,
          onChanged: (value) {
            setState(() {
              selectedGender = value!;
            });
            Navigator.pop(context);
          },
          items:
              <String>['All', 'Any', 'Male', 'Female'] // Add 'All' as an option
                  .map((String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ))
                  .toList(),
        ),
      ),
    );
  }
}
