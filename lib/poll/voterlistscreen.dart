import 'package:appwithapi/Cstum/constant.dart';
import 'package:appwithapi/poll/voterinfo.dart';
import 'package:appwithapi/tutoring/visitProfile.dart';
import 'package:flutter/material.dart';

class VotersListScreen extends StatelessWidget {
  final List<VoterInfo> voterInfoList;

  VotersListScreen({required this.voterInfoList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        title: Text('Voters List'),
      ),
      body: ListView.builder(
        itemCount: voterInfoList.length,
        itemBuilder: (context, index) {
          final voterInfo = voterInfoList[index];
          return Card(
            child: ListTile(
              tileColor: Colors.white,
              leading: CircleAvatar(
                backgroundImage: NetworkImage(voterInfo.profileImageUrl),
              ),
              title: Text(voterInfo.name),
              subtitle: Text(voterInfo.voteOption == 'optionA'
                  ? 'Voted for Option A'
                  : 'Voted for Option B'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VistingProfileScreen(
                            studentId: voterInfo.IDNumber,
                          )),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
